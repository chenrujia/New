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
#import "BXTDeviceList.h"

static NSInteger const DeviceButtonTag = 11;
static NSInteger const DateButtonTag   = 12;
static CGFloat const ChooseViewHeight  = 328.f;

@interface BXTNewWorkOrderViewController ()<AttributeViewDelegate,BXTDataResponseDelegate,UITextFieldDelegate>

@property (nonatomic, strong) BXTPlace          *placeInfo;
@property (nonatomic, copy  ) NSString          *notes;
@property (nonatomic, strong) BXTCustomButton   *deviceBtn;
@property (nonatomic, strong) BXTCustomButton   *dateBtn;
@property (nonatomic, strong) UIView            *blackBV;
@property (nonatomic, strong) BXTChooseItemView *chooseView;
@property (nonatomic, strong) NSMutableArray    *devicesArray;

@end

@implementation BXTNewWorkOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"我要报修" andRightTitle:nil andRightImage:nil];
    _commitBtn.layer.cornerRadius = 4.f;
    [_placeTF setValue:colorWithHexString(@"#3cafff") forKeyPath:@"_placeholderLabel.textColor"];
    _placeTF.layer.cornerRadius = 3.f;
    _placeTF.delegate = self;
    self.devicesArray = [NSMutableArray array];
    
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
    BXTRepairDetailView *repairDetail = [[BXTRepairDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    [self.notesBV addSubview:repairDetail];
    
    if (CGRectGetMaxY(self.openSwitch.frame) + 20.f + 68 > SCREEN_HEIGHT  - KNAVIVIEWHEIGHT)
    {
        _content_height.constant = CGRectGetMaxY(self.openSwitch.frame) + 20.f;
    }
    else
    {
        _content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 68.f;
    }
    [_contentView layoutIfNeeded];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /** 工单类型 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request orderTypeList];
    });
    dispatch_async(concurrentQueue, ^{
        /** 设备列表 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request devicesWithPlaceID:@"1"];
    });
}

- (void)navigationLeftButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSelectedView:(UIButton *)btn
{
    self.blackBV = [[UIView alloc] initWithFrame:self.view.bounds];
    self.blackBV.backgroundColor = [UIColor blackColor];
    self.blackBV.alpha = 0.6f;
    self.blackBV.tag = 101;
    [self.view addSubview:self.blackBV];
    
    if (!self.chooseView)
    {
        self.chooseView = [[BXTChooseItemView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ChooseViewHeight)];
        [self.view addSubview:self.chooseView];
    }
    [self.view bringSubviewToFront:self.chooseView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.chooseView setFrame:CGRectMake(0, SCREEN_HEIGHT - ChooseViewHeight, SCREEN_WIDTH, ChooseViewHeight)];
    }];
    
    if (btn.tag == DeviceButtonTag)
    {
        
    }
    else if (btn.tag == DateButtonTag)
    {
        
    }
}

- (IBAction)commitOrder:(id)sender
{
    
}

- (IBAction)switchValueChanged:(id)sender
{
    UISwitch *swt = sender;
    if (swt.on)
    {
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
        
        if (CGRectGetMaxY(self.dateSelectBtnBV.frame) + 20.f + 68 > SCREEN_HEIGHT  - KNAVIVIEWHEIGHT)
        {
            _content_height.constant = CGRectGetMaxY(self.dateSelectBtnBV.frame) + 20.f;
        }
        else
        {
            _content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 68.f;
        }
        [_contentView layoutIfNeeded];
    }
    else
    {
        self.dateSelectBtnBV.hidden = YES;
        if (CGRectGetMaxY(self.openSwitch.frame) + 20.f + 68 > SCREEN_HEIGHT  - KNAVIVIEWHEIGHT)
        {
            _content_height.constant = CGRectGetMaxY(self.openSwitch.frame) + 20.f;
        }
        else
        {
            _content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 68.f;
        }
        [_contentView layoutIfNeeded];
    }
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
    NSLog(@"title:.....%@",selectType.faulttype);
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTSearchPlaceViewController *searchVC = (BXTSearchPlaceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTSearchPlaceViewController"];
    @weakify(self);
    [searchVC userChoosePlaceInfo:^(BXTPlace *placeInfo) {
        @strongify(self);
        self.placeTF.text = placeInfo.place;
        self.placeInfo = placeInfo;
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    LogRed(@"dic......%@",dic);
    NSArray *data = [dic objectForKey:@"data"];
    if (type == OrderFaultType)
    {
        [BXTOrderTypeInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"orderTypeID":@"id"};
        }];
        NSMutableArray *orderListArray = [NSMutableArray array];
        [orderListArray addObjectsFromArray:[[[BXTOrderTypeInfo mj_objectArrayWithKeyValuesArray:data] reverseObjectEnumerator] allObjects]];
        //工单类型
        BXTAttributeView *attView = [BXTAttributeView attributeViewWithTitleFont:[UIFont boldSystemFontOfSize:17] attributeTexts:orderListArray viewWidth:SCREEN_WIDTH];
        attView.y = 0;
        _order_type_height.constant = attView.height;
        [_orderTypeBV layoutIfNeeded];
        attView.attribute_delegate = self;
        [self.orderTypeBV addSubview:attView];
    }
    else if (type == DeviceList)
    {
        [BXTDeviceList mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"deviceID":@"id"};
        }];
        [self.devicesArray addObjectsFromArray:[BXTDeviceList mj_objectArrayWithKeyValuesArray:data]];
    }
}

- (void)requestError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
