//
//  BXTNewWorkOrderViewController.m
//  YouFeel
//
//  Created by Jason on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTNewWorkOrderViewController.h"
#import "BXTAttributeView.h"
#import "UIView+Extnesion.h"
#import "BXTOrderTypeInfo.h"
#import "BXTSearchPlaceViewController.h"
#import "BXTRepairDetailView.h"
#import "BXTCustomButton.h"
#import "BXTChooseItemView.h"
#import "BXTDeviceListInfo.h"
#import "ANKeyValueTable.h"
#import "UIView+SDAutoLayout.h"

static NSInteger const DeviceButtonTag = 11;
static NSInteger const DateButtonTag   = 12;
static CGFloat const ChooseViewHeight  = 328.f;

@interface BXTNewWorkOrderViewController ()<AttributeViewDelegate,BXTDataResponseDelegate,UITextFieldDelegate>

@property (nonatomic, strong) BXTPlaceInfo      *placeInfo;
@property (nonatomic, copy  ) NSString          *notes;
@property (nonatomic, strong) BXTCustomButton   *deviceBtn;
@property (nonatomic, strong) BXTCustomButton   *dateBtn;
@property (nonatomic, strong) UIView            *blackBV;
@property (nonatomic, strong) BXTChooseItemView *chooseView;
@property (nonatomic, strong) NSMutableArray    *devicesArray;
@property (nonatomic, strong) BXTDeviceListInfo *selectDeviceInfo;
@property (nonatomic, strong) NSDictionary      *selectTimeDic;
@property (nonatomic, strong) BXTOrderTypeInfo  *selectFaultInfo;

@end

@implementation BXTNewWorkOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"我要报修" andRightTitle:nil andRightImage:nil];
    self.commitBtn.layer.cornerRadius = 4.f;
    [self.placeTF setValue:colorWithHexString(@"#3cafff") forKeyPath:@"_placeholderLabel.textColor"];
    self.placeTF.layer.cornerRadius = 3.f;
    self.placeTF.delegate = self;
    self.devicesArray = [NSMutableArray array];
    self.notes = @"";
    
    //图片视图
    BXTPhotosView *photoView = [[BXTPhotosView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [photoView.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
    [self.photosBV addSubview:photoView];
    
    //添加图片点击事件
    @weakify(self);
    UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
    [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self loadMWPhotoBrowser:photoView.imgViewOne.tag];
    }];
    [photoView.imgViewOne addGestureRecognizer:tapGROne];
    UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
    [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self loadMWPhotoBrowser:photoView.imgViewTwo.tag];
    }];
    [photoView.imgViewTwo addGestureRecognizer:tapGRTwo];
    UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
    [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self loadMWPhotoBrowser:photoView.imgViewThree.tag];
    }];
    [photoView.imgViewThree addGestureRecognizer:tapGRThree];
    self.photosView = photoView;
    
    //报修内容
    BXTRepairDetailView *repairDetail = [[BXTRepairDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90) block:^(NSString *notes) {
        @strongify(self);
        self.notes = notes;
    }];
    [self.notesBV addSubview:repairDetail];
    
    if ([BXTGlobal shareGlobal].isRepair)
    {
        UIButton *leftBtn = [self initialButton:YES];
        [leftBtn setTitle:@"我来修" forState:UIControlStateNormal];
        @weakify(self);
        [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self commitOrder:@"2"];
        }];

        UIButton *rightBtn = [self initialButton:NO];
        [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
        [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self commitOrder:@"1"];
        }];
        
        leftBtn.sd_layout
        .leftSpaceToView(self.buttonBV,20)
        .topSpaceToView(self.buttonBV,12)
        .rightSpaceToView(self.buttonBV,SCREEN_WIDTH/2.f + 10.f)
        .heightIs(44);
        rightBtn.sd_layout
        .leftSpaceToView(leftBtn,20)
        .topEqualToView(leftBtn)
        .rightSpaceToView(self.buttonBV,20)
        .heightIs(44);
    }
    else
    {
        UIButton *btn = [self initialButton:NO];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self commitOrder:@"1"];
        }];
        
        CGFloat space = IS_IPHONE6 ? 100.f : 60.f;
        btn.sd_layout
        .leftSpaceToView(self.buttonBV,space)
        .rightSpaceToView(self.buttonBV,space)
        .topSpaceToView(self.buttonBV,12)
        .heightIs(44);
    }
    
    [BXTGlobal showLoadingMBP:@"请稍候..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /** 工单类型 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request orderTypeList];
    });
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateContentView];
}

- (UIButton *)initialButton:(BOOL)isLeft
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (isLeft)
    {
        btn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        btn.layer.borderWidth = 1.f;
        [btn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
    }
    else
    {
        btn.backgroundColor = colorWithHexString(@"3cafff");
        [btn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    }
    btn.layer.cornerRadius = 4.f;
    [self.buttonBV addSubview:btn];
    
    return btn;
}

- (void)updateContentView
{
    UIView *subview = nil;
    if (self.openSwitch.on)
    {
        subview = self.dateSelectBtnBV;
    }
    else
    {
        subview = self.openSwitch;
    }
    if (CGRectGetMaxY(subview.frame) + 20.f > SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 68.f)
    {
        self.content_height.constant = CGRectGetMaxY(subview.frame) + 20.f;
    }
    else
    {
        self.content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 68.f;
    }
    [self.contentView layoutIfNeeded];
}

- (void)navigationLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        [BXTGlobal shareGlobal].presentNav = nil;
    }];
}

- (void)showDevicesList
{
    if (self.devicesArray.count > 0)
    {
        self.deviceSelectBtnBV.hidden = NO;
        if (!self.deviceBtn)
        {
            //设备选择按钮
            self.deviceBtn = [[BXTCustomButton alloc] initWithType:SelectBtnType];
            self.deviceBtn.tag = DeviceButtonTag;
            [self.deviceBtn setFrame:CGRectMake(20.f, 0, SCREEN_WIDTH - 40.f, 46.f)];
            self.deviceBtn.layer.borderColor = colorWithHexString(@"#CCCCCC").CGColor;
            self.deviceBtn.layer.borderWidth = 0.6f;
            self.deviceBtn.layer.cornerRadius = 3.f;
            [self.deviceBtn addTarget:self action:@selector(showSelectedView:) forControlEvents:UIControlEventTouchUpInside];
            self.deviceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [self.deviceBtn setTitle:@"选择设备" forState:UIControlStateNormal];
            [self.deviceBtn setTitleColor:colorWithHexString(@"#6E6E6E") forState:UIControlStateNormal];
            [self.deviceBtn setImage:[UIImage imageNamed:@"wo_down_arrow"] forState:UIControlStateNormal];
            [self.deviceSelectBtnBV addSubview:self.deviceBtn];
        }
        self.notes_image_top.constant = 76.f;
    }
    else
    {
        self.deviceSelectBtnBV.hidden = YES;
        self.notes_image_top.constant = 20.f;
    }
    
    [self.notes_image layoutIfNeeded];
    [self updateContentView];
}

- (void)showSelectedView:(UIButton *)btn
{
    self.blackBV = [[UIView alloc] initWithFrame:self.view.bounds];
    self.blackBV.backgroundColor = [UIColor blackColor];
    self.blackBV.alpha = 0.6f;
    self.blackBV.tag = 101;
    [self.view addSubview:self.blackBV];
    
    ChooseViewType viewType = DeviceListType;
    if (btn.tag == DateButtonTag)
    {
        viewType = DatePickerType;
    }
    if (!self.chooseView)
    {
        @weakify(self);
        self.chooseView = [[BXTChooseItemView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ChooseViewHeight) type:viewType array:self.devicesArray block:^(id item, ChooseViewType chooseType, BOOL isDone) {
            @strongify(self);
            if (item && chooseType == DeviceListType && isDone)
            {
                self.selectDeviceInfo = item;
                [self.deviceBtn setTitle:self.selectDeviceInfo.name forState:UIControlStateNormal];
            }
            else if (item && chooseType == DatePickerType && isDone)
            {
                self.selectTimeDic = item;
                [self.dateBtn setTitle:[self.selectTimeDic objectForKey:@"time"] forState:UIControlStateNormal];
            }
            [self.blackBV removeFromSuperview];
            [UIView animateWithDuration:0.3f animations:^{
                [self.chooseView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ChooseViewHeight)];
            } completion:nil];
        }];
        [self.view addSubview:self.chooseView];
    }
    else
    {
        [self.chooseView refreshChooseView:viewType array:self.devicesArray];
    }
    [self.view bringSubviewToFront:self.chooseView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.chooseView setFrame:CGRectMake(0, SCREEN_HEIGHT - ChooseViewHeight, SCREEN_WIDTH, ChooseViewHeight)];
    }];
}

- (void)commitOrder:(NSString *)isMySelf
{
    if (self.notes.length == 0)
    {
        if (IS_IOS_8)
        {
            UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"请输入故障详情描述" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertCtr addAction:doneAction];
            [self presentViewController:alertCtr animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入故障详情描述" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        return;
    }
    
    [BXTGlobal showLoadingMBP:@"请稍候..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    NSString *appointmentTime = @"";
    NSString *deviceID = @"";
    if (self.selectTimeDic)
    {
        appointmentTime = [self.selectTimeDic objectForKey:@"timeInterval"];
    }
    if (self.selectDeviceInfo)
    {
        deviceID = self.selectDeviceInfo.deviceID;
    }
    [request createRepair:appointmentTime
              faultTypeID:self.selectFaultInfo.orderTypeID
               faultCause:self.notes
                  placeID:self.placeInfo.placeID
                deviceIDs:deviceID
               imageArray:self.resultPhotos
          repairUserArray:[NSArray array]
                 isMySelf:isMySelf];
}

- (IBAction)switchValueChanged:(id)sender
{
    UISwitch *swt = sender;
    UIView *subview = nil;
    if (swt.on)
    {
        subview = self.dateSelectBtnBV;
        self.dateSelectBtnBV.hidden = NO;
        if (!self.dateBtn)
        {
            //时间选择按钮
            self.dateBtn = [[BXTCustomButton alloc] initWithType:SelectBtnType];
            self.dateBtn.tag = DateButtonTag;
            [self.dateBtn setFrame:CGRectMake(20.f, 0, SCREEN_WIDTH - 40.f, 46.f)];
            self.dateBtn.layer.borderColor = colorWithHexString(@"#CCCCCC").CGColor;
            self.dateBtn.layer.borderWidth = 0.6f;
            self.dateBtn.layer.cornerRadius = 3.f;
            [self.dateBtn addTarget:self action:@selector(showSelectedView:) forControlEvents:UIControlEventTouchUpInside];
            self.dateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [self.dateBtn setTitle:@"选择预约时间" forState:UIControlStateNormal];
            [self.dateBtn setTitleColor:colorWithHexString(@"#6E6E6E") forState:UIControlStateNormal];
            [self.dateBtn setImage:[UIImage imageNamed:@"wo_down_arrow"] forState:UIControlStateNormal];
            [self.dateSelectBtnBV addSubview:self.dateBtn];
        }
    }
    else
    {
        subview = self.openSwitch;
        self.dateSelectBtnBV.hidden = YES;
    }
    [self updateContentView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        [view removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            [self.chooseView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ChooseViewHeight)];
        } completion:nil];
    }
}

#pragma mark -
#pragma mark AttributeViewDelegate
- (void)attributeViewSelectType:(BXTOrderTypeInfo *)selectType
{
    self.selectFaultInfo = selectType;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTSearchPlaceViewController *searchVC = (BXTSearchPlaceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTSearchPlaceViewController"];
    NSArray *dataSource = [[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE];
    @weakify(self);
    [searchVC userChoosePlace:dataSource type:PlaceSearchType block:^(BXTBaseClassifyInfo *classifyInfo,NSString *name) {
        @strongify(self);
        BXTPlaceInfo *placeInfo = (BXTPlaceInfo *)classifyInfo;
        self.placeTF.text = name;
        self.placeInfo = placeInfo;
        [BXTGlobal showLoadingMBP:@"请稍候..."];
        /** 设备列表 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request devicesWithPlaceID:self.placeInfo.placeID];
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == OrderFaultType)
    {
        [BXTOrderTypeInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"orderTypeID":@"id"};
        }];
        NSMutableArray *orderListArray = [NSMutableArray array];
        [orderListArray addObjectsFromArray:[BXTOrderTypeInfo mj_objectArrayWithKeyValuesArray:data]];
        //工单类型
        BXTAttributeView *attView = [BXTAttributeView attributeViewWithTitleFont:[UIFont boldSystemFontOfSize:17] attributeTexts:orderListArray viewWidth:SCREEN_WIDTH delegate:self];
        attView.y = 0;
        _order_type_height.constant = attView.height;
        [_orderTypeBV layoutIfNeeded];
        [self.orderTypeBV addSubview:attView];
    }
    else if (type == DeviceList)
    {
        [self.devicesArray removeAllObjects];
        [BXTDeviceListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"deviceID":@"id"};
        }];
        [self.devicesArray addObjectsFromArray:[BXTDeviceListInfo mj_objectArrayWithKeyValuesArray:data]];
        [self showDevicesList];
    }
    else if (type == CreateRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestRepairList" object:nil];
            [self showMBP:@"新工单已创建！" withBlock:^(BOOL hidden) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [BXTGlobal shareGlobal].presentNav = nil;
                }];
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
