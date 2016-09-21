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
#import "BXTSearchItemViewController.h"
#import "BXTRepairDetailView.h"
#import "BXTCustomButton.h"
#import "BXTChooseItemView.h"
#import "BXTDeviceListInfo.h"
#import "ANKeyValueTable.h"
#import "BXTFaultInfo.h"
#import "UIView+SDAutoLayout.h"
#import "BXTProjectManageViewController.h"
#import "BXTSelectBoxView.h"

static NSInteger const DeviceButtonTag = 11;
static NSInteger const DateButtonTag   = 12;
static CGFloat const ChooseViewHeight  = 328.f;

@interface BXTNewWorkOrderViewController ()<AttributeViewDelegate,BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate,UITextFieldDelegate>

@property (nonatomic, strong) BXTPlaceInfo      *placeInfo;
@property (nonatomic, strong) NSString          *adsText;//手动输入的位置
@property (nonatomic, copy  ) NSString          *notes;
@property (nonatomic, strong) BXTCustomButton   *deviceBtn;
@property (nonatomic, strong) BXTCustomButton   *dateBtn;
@property (nonatomic, strong) BXTCustomButton   *urgentBtn;
@property (nonatomic, strong) UIView            *blackBV;
@property (nonatomic, strong) BXTChooseItemView *chooseView;
@property (nonatomic, strong) NSMutableArray    *faultTypeArray;
@property (nonatomic, strong) NSMutableArray    *devicesArray;
@property (nonatomic, strong) BXTDeviceListInfo *selectDeviceInfo;
@property (nonatomic, strong) NSDictionary      *selectTimeDic;
@property (nonatomic, strong) BXTOrderTypeInfo  *selectOrderInfo;
@property (nonatomic, strong) BXTFaultInfo      *selectFaultInfo;
@property (nonatomic, strong) UIView            *bgView;
@property (nonatomic, strong) BXTSelectBoxView  *boxView;

@end

@implementation BXTNewWorkOrderViewController

- (void)deviceInfoWithDictionary:(NSDictionary *)dic
{
    self.dataDic = dic;
    BXTDeviceListInfo *deviceInfo = [BXTDeviceListInfo new];
    deviceInfo.deviceID = [dic objectForKey:@"deviceID"];
    self.selectDeviceInfo = deviceInfo;
    
    BXTPlaceInfo *placeInfo = [BXTPlaceInfo new];
    placeInfo.place = [dic objectForKey:@"placeName"];
    placeInfo.placeID = [dic objectForKey:@"placeID"];
    self.placeInfo = placeInfo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"我要报修" andRightTitle:nil andRightImage:nil];
    [self.placeTF setValue:colorWithHexString(@"#3cafff") forKeyPath:@"_placeholderLabel.textColor"];
    self.placeTF.layer.cornerRadius = 3.f;
    self.placeTF.delegate = self;
    self.devicesArray = [NSMutableArray array];
    self.notes = @"";
    if (!IS_IOS_8)
    {
        self.content_top.constant = -20;
    }
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    if ([companyInfo.company_id isEqualToString:@"4"])
    {
        self.first_image_top.constant = 45.f;
        [self.contentView layoutIfNeeded];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 37);
        button.backgroundColor = colorWithHexString(@"F0EFF5");
        [button setTitle:@"请选择您所在的项目  >>" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            // 商铺列表
            BXTProjectManageViewController *pivc = [[BXTProjectManageViewController alloc] init];
            [self.navigationController pushViewController:pivc animated:YES];
        }];
        [self.contentView addSubview:button];
    }
    
    //侦听删除事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"DeleteTheImage" object:nil];
    
    UITapGestureRecognizer *panGR = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [[panGR rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    [self.contentView addGestureRecognizer:panGR];

    //图片视图
    BXTPhotosView *photoView = [[BXTPhotosView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [photoView.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
    [self.photosBV addSubview:photoView];
    
    //添加图片点击事件
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
    
    self.faultTypeArray = [NSMutableArray array];
    [BXTGlobal showLoadingMBP:@"请稍候..."];
    /** 紧急类型 **/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request urgentFaultType];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.dataDic && !self.deviceBtn)
    {
        [self initailButtonWithTitle:[self.dataDic objectForKey:@"deviceName"]];
        self.notes_image_top.constant = 76.f;
        [self.notes_image layoutIfNeeded];
        self.placeTF.text = self.placeInfo.place;
    }
}

- (void)deleteImage:(NSNotification *)notification
{
    NSNumber *number = notification.object;
    [self handleData:[number integerValue]];
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
    btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    btn.layer.cornerRadius = 4.f;
    [self.buttonBV addSubview:btn];
    
    return btn;
}

- (void)updateContentView
{
    [self.view layoutIfNeeded];

    UIView *subview = nil;
    if (self.urgentBV.hidden)
    {
        self.alarm_image.hidden = NO;
        self.alarm_label.hidden = NO;
        self.openSwitch.hidden = NO;
        if (self.openSwitch.on)
        {
            [self.dateSelectBtnBV layoutIfNeeded];
            subview = self.dateSelectBtnBV;
        }
        else
        {
            [self.openSwitch layoutIfNeeded];
            subview = self.openSwitch;
        }
    }
    else
    {
        self.alarm_image.hidden = YES;
        self.alarm_label.hidden = YES;
        self.openSwitch.hidden = YES;
        [self.photosBV layoutIfNeeded];
        subview = self.photosBV;
    }
    NSLog(@"subview.frame:%@", NSStringFromCGRect(subview.frame));
    
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
    if ([BXTGlobal shareGlobal].presentNav)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [BXTGlobal shareGlobal].presentNav = nil;
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showDevicesList
{
    if (self.devicesArray.count > 0)
    {
        if (!self.deviceBtn)
        {
            [self initailButtonWithTitle:@"选择设备"];
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

- (void)initailButtonWithTitle:(NSString *)title
{
    //设备选择按钮
    self.deviceSelectBtnBV.hidden = NO;
    self.deviceBtn = [[BXTCustomButton alloc] initWithType:SelectBtnType];
    self.deviceBtn.tag = DeviceButtonTag;
    [self.deviceBtn setFrame:CGRectMake(20.f, 0, SCREEN_WIDTH - 40.f, 46.f)];
    self.deviceBtn.layer.borderColor = colorWithHexString(@"#CCCCCC").CGColor;
    self.deviceBtn.layer.borderWidth = 0.6f;
    self.deviceBtn.layer.cornerRadius = 3.f;
    self.deviceBtn.titleLabel.numberOfLines = 0;
    self.deviceBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.deviceBtn addTarget:self action:@selector(showSelectedView:) forControlEvents:UIControlEventTouchUpInside];
    self.deviceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.deviceBtn setTitle:title forState:UIControlStateNormal];
    [self.deviceBtn setTitleColor:colorWithHexString(@"#6E6E6E") forState:UIControlStateNormal];
    [self.deviceBtn setImage:[UIImage imageNamed:@"wo_down_arrow"] forState:UIControlStateNormal];
    [self.deviceSelectBtnBV addSubview:self.deviceBtn];
}

#pragma mark -
#pragma mark 紧急按钮点击事件
- (void)selectUrgentView
{
    [self.view endEditing:YES];
    self.bgView = [[UIView alloc] initWithFrame:ApplicationWindow.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.6f;
    self.bgView.tag = 101;
    [ApplicationWindow addSubview:_bgView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.bgView removeFromSuperview];
        [self.boxView removeFromSuperview];
    }];
    [self.bgView addGestureRecognizer:tapGesture];
    
    self.boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260.f) boxTitle:@"请选择紧急类型" boxSelectedViewType:FaultTypeView listDataSource:self.faultTypeArray markID:nil actionDelegate:self];
    [ApplicationWindow addSubview:self.boxView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 260.f, SCREEN_WIDTH, 260.f)];
    }];
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
                NSString *title = [NSString stringWithFormat:@"%@\r%@",self.selectDeviceInfo.name,self.selectDeviceInfo.code_number];
                [self.deviceBtn setTitle:title forState:UIControlStateNormal];
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

- (void)showAlertView:(NSString *)title message:(NSString *)message
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCtr addAction:doneAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark 提交按钮
- (void)commitOrder:(NSString *)isMySelf
{
    if (!self.selectOrderInfo)
    {
        [self showAlertView:@"请选择工单类型" message:nil];
        return;
    }
    if (!self.placeInfo && !self.adsText)
    {
        [self showAlertView:@"请确定报修位置" message:nil];
        return;
    }
    if (self.notes.length == 0)
    {
        [self showAlertView:@"请输入故障详情描述" message:nil];
        return;
    }
    
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
    NSString *faultTypeID;
    if (self.urgentBV.hidden)
    {
        faultTypeID = self.selectOrderInfo.orderTypeID;
    }
    else
    {
        if (self.selectFaultInfo)
        {
            faultTypeID = self.selectFaultInfo.fault_id;
        }
        else
        {
            [self showAlertView:@"请确定紧急类型" message:nil];
            return;
        }
    }
    [BXTGlobal showLoadingMBP:@"请稍候..."];
    [request createRepair:appointmentTime
              faultTypeID:faultTypeID
               faultCause:self.notes
                  placeID:self.placeInfo.placeID
                  adsText:self.adsText
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
        NSTimeInterval minTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval appointmentTime = minTime + 60 * 60;
        NSString *timeInterval = [NSString stringWithFormat:@"%.0f",appointmentTime];
        NSDate *appointmentDate = [NSDate dateWithTimeIntervalSince1970:appointmentTime];
        NSString *dateStr = [BXTGlobal transTimeWithDate:appointmentDate withType:@"yyyy/MM/dd HH:mm"];
        self.selectTimeDic = @{@"time":dateStr,@"timeInterval":timeInterval};
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
            [self.dateBtn setTitleColor:colorWithHexString(@"#6E6E6E") forState:UIControlStateNormal];
            [self.dateBtn setImage:[UIImage imageNamed:@"wo_down_arrow"] forState:UIControlStateNormal];
            [self.dateSelectBtnBV addSubview:self.dateBtn];
        }
        [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
    }
    else
    {
        subview = self.openSwitch;
        self.selectTimeDic = nil;
        self.dateSelectBtnBV.hidden = YES;
    }
    [self updateContentView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    [self.bgView removeFromSuperview];
    [self.boxView removeFromSuperview];
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
#pragma mark BXTBoxSelectedTitleDelegate
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    [self.bgView removeFromSuperview];
    [self.boxView removeFromSuperview];
    if (!obj)
    {
        return;
    }
    BXTFaultInfo *faultTypeInfo = obj;
    self.selectFaultInfo = faultTypeInfo;
    [self.urgentBtn setTitle:faultTypeInfo.faulttype forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark AttributeViewDelegate
- (void)attributeViewSelectType:(BXTOrderTypeInfo *)selectType
{
    if (self.selectOrderInfo && [selectType.orderTypeID isEqualToString:self.selectOrderInfo.orderTypeID])
    {
        self.selectOrderInfo = nil;
    }
    else
    {
        self.selectOrderInfo = selectType;
    }
    self.selectFaultInfo = nil;
    if ([self.selectOrderInfo.faulttype isEqualToString:@"紧急"])
    {
        self.urgentBV.hidden = NO;
        self.selectTimeDic = nil;
        //紧急类型选择按钮
        if (!self.urgentBtn)
        {
            self.urgentBtn = [[BXTCustomButton alloc] initWithType:SelectBtnType];
            self.urgentBtn.tag = DateButtonTag;
            [self.urgentBtn setFrame:CGRectMake(20.f, 0, SCREEN_WIDTH - 40.f, 46.f)];
            self.urgentBtn.layer.borderColor = colorWithHexString(@"#CCCCCC").CGColor;
            self.urgentBtn.layer.borderWidth = 0.6f;
            self.urgentBtn.layer.cornerRadius = 3.f;
            [self.urgentBtn addTarget:self action:@selector(selectUrgentView) forControlEvents:UIControlEventTouchUpInside];
            self.urgentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [self.urgentBtn setTitle:@"选择紧急类型" forState:UIControlStateNormal];
            [self.urgentBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            [self.urgentBtn setImage:[UIImage imageNamed:@"wo_down_arrow"] forState:UIControlStateNormal];
            [self.urgentBV addSubview:self.urgentBtn];
        }
        else
        {
            [self.urgentBtn setTitle:@"选择紧急类型" forState:UIControlStateNormal];
        }
        self.repair_image_top.constant = 66.f;
        [self.repair_image layoutIfNeeded];
    }
    else
    {
        self.urgentBV.hidden = YES;
        self.repair_image_top.constant = 0.f;
        [self.repair_image layoutIfNeeded];
    }
    [self updateContentView];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTSearchItemViewController *searchVC = (BXTSearchItemViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTSearchItemViewController"];
    NSArray *dataSource = [[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE];
    @weakify(self);
    [searchVC userChoosePlace:dataSource isProgress:NO type:PlaceSearchType block:^(BXTBaseClassifyInfo *classifyInfo,NSString *name) {
        @strongify(self);
        if (classifyInfo)
        {
            self.adsText = nil;
            BXTPlaceInfo *placeInfo = (BXTPlaceInfo *)classifyInfo;
            self.placeTF.text = name;
            self.placeInfo = placeInfo;
            [BXTGlobal showLoadingMBP:@"请稍候..."];
            /** 设备列表 **/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request devicesWithPlaceID:self.placeInfo.placeID];
        }
        else
        {
            self.adsText = name;
            self.placeTF.text = name;
        }
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

#pragma mark -
#pragma mark 数据请求代理
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
        if (self.faultTypeArray.count > 0)
        {
            BXTOrderTypeInfo *orderType = [[BXTOrderTypeInfo alloc] init];
            orderType.faulttype = @"紧急";
            [orderListArray addObject:orderType];
        }
        
        //工单类型
        BXTAttributeView *attView = [BXTAttributeView attributeViewWithTitleFont:[UIFont boldSystemFontOfSize:17] attributeTexts:orderListArray viewWidth:SCREEN_WIDTH delegate:self];
        attView.y = 0;
        self.order_type_height.constant = attView.height;
        [self.orderTypeBV layoutIfNeeded];
        [self.orderTypeBV addSubview:attView];
        [self updateContentView];
    }
    else if (type == FaultType)
    {
        [BXTFaultInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"fault_id":@"id"};
        }];
        [self.faultTypeArray addObjectsFromArray:[BXTFaultInfo mj_objectArrayWithKeyValuesArray:data]];
        [BXTGlobal showLoadingMBP:@"请稍候..."];
        /** 工单类型 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request orderTypeList];
    }
    else if (type == DeviceList)
    {
        [self.devicesArray removeAllObjects];
        [BXTDeviceListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"deviceID":@"id"};
        }];
        [self.devicesArray addObjectsFromArray:[BXTDeviceListInfo mj_objectArrayWithKeyValuesArray:data]];
        if (!self.dataDic)
        {
            [self showDevicesList];
        }
    }
    else if (type == CreateRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestRepairList" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDeviceCurrentOrders" object:nil];
            @weakify(self);
            [BXTGlobal showText:@"新工单已创建！" completionBlock:^{
                @strongify(self);
                if ([BXTGlobal shareGlobal].presentNav)
                {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [BXTGlobal shareGlobal].presentNav = nil;
                    }];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"049"])
        {
            [self showAlertView:@"报修失败" message:@"请到“项目管理”中进行验证"];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    if (type == FaultType)
    {
        [BXTGlobal showLoadingMBP:@"请稍候..."];
        /** 工单类型 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request orderTypeList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
