//
//  BXTMaintenanceDetailViewController.m
//  YouFeel
//
//  Created by Jason on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenanceDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "BXTHeaderForVC.h"
#import "BXTDrawView.h"
#import "BXTSelectBoxView.h"
#import "BXTPersonInfromViewController.h"
#import "BXTMMProcessViewController.h"
#import "BXTManListViewController.h"
#import "BXTRejectOrderViewController.h"
#import "BXTEvaluationViewController.h"
#import "AMRatingControl.h"
#import "BXTButtonInfo.h"
#import "UIView+SDAutoLayout.h"

//底部白色背景图高度
#define YBottomBackHeight 67.f

@interface BXTMaintenanceDetailViewController ()<BXTDataResponseDelegate>

@property (nonatomic ,strong) NSString         *repair_id;
@property (nonatomic ,strong) NSArray          *comeTimeArray;
@property (nonatomic ,strong) UIView           *bgView;
@property (nonatomic ,assign) NSTimeInterval   timeInterval;
@property (nonatomic, strong) NSMutableArray   *manIDArray;
@property (nonatomic ,strong) UIButton         *evaluationBtn;
@property (nonatomic ,strong) UIView           *evaBackView;
@property (nonatomic, strong) NSMutableArray   *btnArray;

@end

@implementation BXTMaintenanceDetailViewController

- (void)dataWithRepairID:(NSString *)repairID sceneType:(SceneType)type
{
    [BXTGlobal shareGlobal].maxPics = 3;
    self.repair_id = repairID;
    self.sceneType = type;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.isRejectVC)
    {
        [self navigationSetting:@"工单详情" andRightTitle:@"关闭工单" andRightImage:nil];
    }
    else
    {
        //TODO: 去掉增加人员
        [self navigationSetting:@"工单详情" andRightTitle:@"增加人员" andRightImage:nil];
    }
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    self.btnArray = buttons;
    isFirst = YES;
    _connectTa.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    _connectTa.layer.borderWidth = 1.f;
    _connectTa.layer.cornerRadius = 4.f;
    
    //联系他
    @weakify(self);
    [[_connectTa rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTRepairPersonInfo *rpInfo = self.repairDetail.fault_user_arr[0];
        [self handleUserInfo:@{@"UserID":rpInfo.rpID,
                               @"UserName":rpInfo.name,
                               @"HeadPic":rpInfo.head_pic}];
    }];
    _orderType.layer.masksToBounds = YES;
    _orderType.layer.cornerRadius = 3.f;
    self.manIDArray = [[NSMutableArray alloc] init];
    //点击头像
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        BXTRepairPersonInfo *repairPerson = self.repairDetail.fault_user_arr[0];
        BXTPersonInfromViewController *personVC = [[BXTPersonInfromViewController alloc] init];
        personVC.userID = repairPerson.rpID;
        NSArray *shopArray = [BXTGlobal getUserProperty:U_SHOPIDS];
        personVC.shopID = shopArray[0];
        [self.navigationController pushViewController:personVC animated:YES];
    }];
    [_headImgView addGestureRecognizer:tapGesture];
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"])
    {
        [timeArray addObject:[NSString stringWithFormat:@"%@分钟内", timeStr]];
    }
    [timeArray addObject:@"自定义"];
    self.comeTimeArray = timeArray;
    
    //???: 这个是怎么个情况
    //    //由于详情采用了统一的详情，所以如果是报修者的身份，则一下信息是不让看的
    //    if (![BXTGlobal shareGlobal].isRepair)
    //    {
    //        _headImgView.hidden = YES;
    //        _repairerName.hidden = YES;
    //        _connectTa.hidden = YES;
    //        [_repairID layoutIfNeeded];
    //    }
    
    //发起请求
    [self requestDetail];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RequestDetail" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self requestDetail];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
}

#pragma mark -
#pragma mark 请求数据
- (void)requestDetail
{
    [BXTGlobal showLoadingMBP:@"努力加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**获取详情**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request repairDetail:[NSString stringWithFormat:@"%@",_repair_id]];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求控制按钮显示**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request handlePermission:self.repair_id sceneID:[NSString stringWithFormat:@"%ld",(long)self.sceneType]];
    });
}

#pragma mark -
#pragma mark 更新ContentView高度
- (void)updateContentConstant:(UIView *)view
{
    if (CGRectGetMaxY(view.frame) + 12.f + YBottomBackHeight > SCREEN_HEIGHT  - KNAVIVIEWHEIGHT)
    {
        _content_height.constant = CGRectGetMaxY(view.frame) + 12.f + YBottomBackHeight;
    }
    else
    {
        _content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT;
    }
    [_contentView layoutIfNeeded];
}

- (void)loadDeviceList
{
    //设备列表相关
    NSInteger deviceCount = self.repairDetail.device_list.count;
    CGFloat secondHeight = 32.f + 63.f * deviceCount;
    if (deviceCount)
    {
        _fifthBV.hidden = NO;
        //先清除，后添加
        for (UIView *subview in _fifthBV.subviews)
        {
            //设备列表（label）以及其下面的线（view）
            if (subview.tag == 1)
            {
                continue;
            }
            [subview removeFromSuperview];
        }
        _fifth_bv_height.constant = secondHeight;
        [_fifthBV layoutIfNeeded];
        for (NSInteger i = 0; i < deviceCount; i++)
        {
            BOOL isLast = deviceCount == i + 1 ? YES : NO;
            UIView *deviceView = [self deviceLists:i comingFromDeviceInfo:self.isComingFromDeviceInfo isLast:isLast];
            [_fifthBV addSubview:deviceView];
        }
    }
    else
    {
        _fifthBV.hidden = YES;
    }
}

- (void)loadMMList
{
    //维修员相关
    NSInteger usersCount = self.repairDetail.repair_user_arr.count;
    if (usersCount)
    {
        _sixthBV.hidden = NO;
        _mmScroller.contentSize = CGSizeMake(113.f * usersCount, 0);
        //先清除，后添加
        for (UIView *subview in _mmScroller.subviews)
        {
            [subview removeFromSuperview];
        }
        
        [self.manIDArray removeAllObjects];
        for (NSInteger i = 0; i < usersCount; i++)
        {
            BXTMaintenanceManInfo *mmInfo = self.repairDetail.repair_user_arr[i];
            [self.manIDArray addObject:mmInfo.mmID];
            UIView *userBack = [self viewForUser:i andMaintenance:mmInfo];
            [_mmScroller addSubview:userBack];
        }
    }
    else
    {
        _sixthBV.hidden = YES;
    }
}

- (void)loadMaintenanceReports
{
    //维修报告相关
    //TODO: 服务器还没有完好，缺少字段
    _endTime.text = [NSString stringWithFormat:@"结束时间：%@",@"2016.3.22 18:20:39"];
    _maintencePlace.text = [NSString stringWithFormat:@"维修位置：%@",@"铁建广场603"];
    _doneFaultType.text = [NSString stringWithFormat:@"故障类型：%@",@"生活水泵"];
    _doneState.text = [NSString stringWithFormat:@"维修状态：%@",@"已修好"];
    _doneNotes.text = [NSString stringWithFormat:@"维修记录：%@",self.repairDetail.workprocess];
    [_contentView layoutIfNeeded];
    _seventh_bv_height.constant = CGRectGetMaxY(_doneNotes.frame) + 10.f;
    [_seventhBV layoutIfNeeded];
}

- (void)loadFaultPic
{
    switch (self.repairDetail.fault_pic.count)
    {
        case 1:
        {
            BXTFaultPicInfo *faultPic = self.repairDetail.fault_pic[0];
            _faultPicOne.hidden = NO;
            [_faultPicOne sd_setImageWithURL:[NSURL URLWithString:faultPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 2:
        {
            BXTFaultPicInfo *faultPicOne = self.repairDetail.fault_pic[0];
            _faultPicOne.hidden = NO;
            [_faultPicOne sd_setImageWithURL:[NSURL URLWithString:faultPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *faultPicTwo = self.repairDetail.fault_pic[1];
            _faultPicTwo.hidden = NO;
            [_faultPicTwo sd_setImageWithURL:[NSURL URLWithString:faultPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 3:
        {
            BXTFaultPicInfo *faultPicOne = self.repairDetail.fault_pic[0];
            _faultPicOne.hidden = NO;
            [_faultPicOne sd_setImageWithURL:[NSURL URLWithString:faultPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *faultPicTwo = self.repairDetail.fault_pic[1];
            _faultPicTwo.hidden = NO;
            [_faultPicTwo sd_setImageWithURL:[NSURL URLWithString:faultPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *faultPicThree = self.repairDetail.fault_pic[2];
            _faultPicThree.hidden = NO;
            [_faultPicThree sd_setImageWithURL:[NSURL URLWithString:faultPicThree.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        default:
            break;
    }
    
}

- (void)loadFixedPic
{
    //维修后图片相关
    switch (self.repairDetail.fixed_pic.count)
    {
        case 1:
        {
            BXTFaultPicInfo *fixPic = self.repairDetail.fixed_pic[0];
            _fixPicOne.hidden = NO;
            [_fixPicOne sd_setImageWithURL:[NSURL URLWithString:fixPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 2:
        {
            BXTFaultPicInfo *fixPicOne = self.repairDetail.fixed_pic[0];
            _fixPicOne.hidden = NO;
            [_fixPicOne sd_setImageWithURL:[NSURL URLWithString:fixPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *fixPicTwo = self.repairDetail.fixed_pic[1];
            _fixPicTwo.hidden = NO;
            [_fixPicTwo sd_setImageWithURL:[NSURL URLWithString:fixPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 3:
        {
            BXTFaultPicInfo *fixPicOne = self.repairDetail.fixed_pic[0];
            _fixPicOne.hidden = NO;
            [_fixPicOne sd_setImageWithURL:[NSURL URLWithString:fixPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *fixPicTwo = self.repairDetail.fixed_pic[1];
            _fixPicTwo.hidden = NO;
            [_fixPicTwo sd_setImageWithURL:[NSURL URLWithString:fixPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *fixPicThree = self.repairDetail.fixed_pic[2];
            _fixPicThree.hidden = NO;
            [_fixPicThree sd_setImageWithURL:[NSURL URLWithString:fixPicThree.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        default:
            break;
    }
}

- (void)loadEvaluationContent
{
    //评价相关
    for (UIView *subview in _ninthBV.subviews)
    {
        if (subview.tag == 10 || subview.tag == 11 || subview.tag == 12)
        {
            [subview removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < 3; i++)
    {
        UIImage *dot = [UIImage imageNamed:@"star_selected"];
        UIImage *star = [UIImage imageNamed:@"star"];
        AMRatingControl *imagesRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(130, 44 + 40 * i)
                                                                              emptyImage:dot
                                                                              solidImage:star
                                                                            andMaxRating:5];
        imagesRatingControl.tag = 10 + i;
        imagesRatingControl.rating = 5;
        imagesRatingControl.userInteractionEnabled = NO;
        [_ninthBV addSubview:imagesRatingControl];
    }
    _evaluateNotes.text = self.repairDetail.evaluation_notes;
    [_contentView layoutIfNeeded];
    _ninth_bv_height.constant = CGRectGetMaxY(_evaluateNotes.frame) + 10.f;
    [_ninthBV layoutIfNeeded];
}

- (void)loadEvaluationPic
{
    //评价图片相关
    switch (self.repairDetail.evaluation_pic.count)
    {
        case 1:
        {
            BXTFaultPicInfo *evaluationPic = self.repairDetail.evaluation_pic[0];
            _evaluatePicOne.hidden = NO;
            [_evaluatePicOne sd_setImageWithURL:[NSURL URLWithString:evaluationPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 2:
        {
            BXTFaultPicInfo *evaluationPic = self.repairDetail.evaluation_pic[0];
            _evaluatePicOne.hidden = NO;
            [_evaluatePicOne sd_setImageWithURL:[NSURL URLWithString:evaluationPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *evaluationPicTwo = self.repairDetail.evaluation_pic[1];
            _evaluatePicTwo.hidden = NO;
            [_evaluatePicTwo sd_setImageWithURL:[NSURL URLWithString:evaluationPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 3:
        {
            BXTFaultPicInfo *evaluationPic = self.repairDetail.evaluation_pic[0];
            _evaluatePicOne.hidden = NO;
            [_evaluatePicOne sd_setImageWithURL:[NSURL URLWithString:evaluationPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *evaluationPicTwo = self.repairDetail.evaluation_pic[1];
            _evaluatePicTwo.hidden = NO;
            [_evaluatePicTwo sd_setImageWithURL:[NSURL URLWithString:evaluationPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *evaluationPicThree = self.repairDetail.evaluation_pic[2];
            _evaluatePicThree.hidden = NO;
            [_evaluatePicThree sd_setImageWithURL:[NSURL URLWithString:evaluationPicThree.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        default:
            break;
    }
}

- (void)loadAllOthers
{
    //有维修报告
    if (self.repairDetail.man_hours.length > 0)
    {
        [self loadMaintenanceReports];
        //有维修后图片
        if (self.repairDetail.fixed_pic.count)
        {
            [self loadFixedPic];
            //有评价内容
            if (self.repairDetail.evaluation_notes.length > 0)
            {
                [self loadEvaluationContent];
                //有评价图片
                if (self.repairDetail.evaluation_pic.count)
                {
                    [self loadEvaluationPic];
                    _content_height.constant = CGRectGetMaxY(_tenthBV.frame)+ 10.f + YBottomBackHeight + 12.f;
                }
                else
                {
                    _tenthBV.hidden = YES;
                    _content_height.constant = CGRectGetMaxY(_ninthBV.frame)+ 10.f + YBottomBackHeight + 12.f;
                }
            }
            else
            {
                _ninthBV.hidden = YES;
                _tenthBV.hidden = YES;
                _content_height.constant = CGRectGetMaxY(_eighthBV.frame)+ 10.f + YBottomBackHeight + 12.f;
            }
        }
        else
        {
            //有评价内容
            if (self.repairDetail.evaluation_notes.length > 0)
            {
                _ninth_top.constant = 12.f;
                [_ninthBV layoutIfNeeded];
                [self loadEvaluationContent];
                //有评价图片
                if (self.repairDetail.evaluation_pic.count)
                {
                    [self loadEvaluationPic];
                    _content_height.constant = CGRectGetMaxY(_tenthBV.frame)+ 10.f + YBottomBackHeight + 12.f;
                }
                else
                {
                    _tenthBV.hidden = YES;
                    _content_height.constant = CGRectGetMaxY(_ninthBV.frame)+ 10.f + YBottomBackHeight + 12.f;
                }
            }
            else
            {
                _ninthBV.hidden = YES;
                _tenthBV.hidden = YES;
                _content_height.constant = CGRectGetMaxY(_eighthBV.frame)+ 10.f + YBottomBackHeight + 12.f;
            }
        }
    }
    else
    {
        _seventhBV.hidden = YES;
        _eighthBV.hidden = YES;
        _ninthBV.hidden = YES;
        _tenthBV.hidden = YES;
        if (CGRectGetMaxY(_sixthBV.frame) + 12.f + YBottomBackHeight > SCREEN_HEIGHT  - KNAVIVIEWHEIGHT)
        {
            _content_height.constant = CGRectGetMaxY(_sixthBV.frame) + 12.f + YBottomBackHeight;
        }
        else
        {
            _content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT;
        }
    }
}

- (void)loadButtons
{
    self.eleventhBV.hidden = NO;
    switch (self.btnArray.count) {
        case 1:
        {
            BXTButtonInfo *btnInfo = self.btnArray[0];
            UIButton *btn = [self initialButton];
            [btn setTitle:btnInfo.button_name forState:UIControlStateNormal];
            @weakify(self);
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self actionWithButtonInfo:btnInfo];
            }];
            
            btn.sd_layout
            .leftSpaceToView(self.eleventhBV,100)
            .rightSpaceToView(self.eleventhBV,100)
            .topSpaceToView(self.eleventhBV,12)
            .heightIs(44);
        }
            break;
        case 2:
        {
            BXTButtonInfo *leftBtnInfo = self.btnArray[0];
            UIButton *leftBtn = [self initialButton];
            [leftBtn setTitle:leftBtnInfo.button_name forState:UIControlStateNormal];
            @weakify(self);
            [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self actionWithButtonInfo:leftBtnInfo];
            }];
            BXTButtonInfo *rightBtnInfo = self.btnArray[1];
            UIButton *rightBtn = [self initialButton];
            [rightBtn setTitle:rightBtnInfo.button_name forState:UIControlStateNormal];
            [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self actionWithButtonInfo:rightBtnInfo];
            }];
            
            leftBtn.sd_layout
            .leftSpaceToView(self.eleventhBV,20)
            .topSpaceToView(self.eleventhBV,12)
            .rightSpaceToView(self.eleventhBV,SCREEN_WIDTH/2.f + 10.f)
            .heightIs(44);
            rightBtn.sd_layout
            .leftSpaceToView(leftBtn,20)
            .topEqualToView(leftBtn)
            .rightSpaceToView(self.eleventhBV,20)
            .heightIs(44);
        }
            break;
        default:
            self.eleventhBV.hidden = YES;
            
            break;
    }
}

- (UIButton *)initialButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    btn.layer.borderWidth = 1.f;
    btn.layer.cornerRadius = 4.f;
    [btn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
    [self.eleventhBV addSubview:btn];
    return btn;
}

#pragma mark -
#pragma mark 关闭工单（跟权限相关）
- (void)navigationRightButton
{
    //TODO: 替换回来
//    BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:self.repairDetail.orderID viewControllerType:ExamineVCType];
//    [self.navigationController pushViewController:rejectVC animated:YES];
    BXTManListViewController *manListVC = [[BXTManListViewController alloc] initWithNibName:@"BXTManListViewController" bundle:nil repairID:self.repairDetail.orderID manList:self.repairDetail.repair_user_arr controllerType:DetailType];
    [self.manIDArray addObject:[NSString stringWithFormat:@"%@", [BXTGlobal getUserProperty:U_BRANCHUSERID]]];
    manListVC.manIDArray = self.manIDArray;
    [self.navigationController pushViewController:manListVC animated:YES];
}

#pragma mark -
#pragma mark 底部按钮事件处理
- (void)actionWithButtonInfo:(BXTButtonInfo *)btnInfo
{
    //1.取消按钮 2.接单按钮 3.派工按钮 4.增援按钮 5.开始维修 6.结束维修 7.确认驳回 8.确认工单 9.评价工单 10.已评价 11.派工驳回 12.派工确认
    if (btnInfo.button_key == 1)
    {
        [self cancelTheRepair];
    }
    else if (btnInfo.button_key == 2 || btnInfo.button_key == 12)
    {
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request reaciveOrderID:self.repairDetail.orderID];
    }
    else if (btnInfo.button_key == 3 || btnInfo.button_key == 4)
    {
        ControllerType cvType = btnInfo.button_key == 3 ? AssignType : DetailType;
        BXTManListViewController *manListVC = [[BXTManListViewController alloc] initWithNibName:@"BXTManListViewController" bundle:nil repairID:self.repairDetail.orderID manList:self.repairDetail.repair_user_arr controllerType:cvType];
        [self.manIDArray addObject:[NSString stringWithFormat:@"%@", [BXTGlobal getUserProperty:U_BRANCHUSERID]]];
        manListVC.manIDArray = self.manIDArray;
        [self.navigationController pushViewController:manListVC animated:YES];
    }
    else if (btnInfo.button_key == 5)
    {
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request startRepair:self.repairDetail.orderID];
    }
    else if (btnInfo.button_key == 6)
    {
        [self endMaintence];
    }
    else if (btnInfo.button_key == 7)
    {
        BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:self.repairDetail.orderID viewControllerType:RejectType];
        [self.navigationController pushViewController:rejectVC animated:YES];
    }
    else if (btnInfo.button_key == 8)
    {
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request isFixed:self.repairDetail.orderID confirmState:@"1" confirmNotes:@""];
    }
    else if (btnInfo.button_key == 9)
    {
        BXTEvaluationViewController *evaVC = [[BXTEvaluationViewController alloc] initWithRepairID:self.repairDetail.orderID];
        [self.navigationController pushViewController:evaVC animated:YES];
    }
    else if (btnInfo.button_key == 11)
    {
        BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:self.repairDetail.orderID viewControllerType:AssignVCType];
        [self.navigationController pushViewController:rejectVC animated:YES];
    }
}

- (void)cancelTheRepair
{
    if ([self.repairDetail.repairstate integerValue] == 1)
    {
        if (IS_IOS_8)
        {
            UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"您确定要取消此工单?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertCtr addAction:cancelAction];
            @weakify(self);
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                @strongify(self);
                /**删除工单**/
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request deleteRepair:self.repairDetail.orderID];
            }];
            [alertCtr addAction:doneAction];
            [self presentViewController:alertCtr animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要取消此工单?"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            @weakify(self);
            [[alert rac_buttonClickedSignal] subscribeNext:^(id x) {
                @strongify(self);
                if ([x integerValue] == 1)
                {
                    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                    [request deleteRepair:self.repairDetail.orderID];
                }
            }];
            [alert show];
        }
    }
    else
    {
        [self showMBP:@"此工单正在进行中，不允许删除!" withBlock:nil];
    }
}

- (void)endMaintence
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"您是否确定当前工单已结束？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:nil];
        [alertCtr addAction:cancelAction];
        @weakify(self);
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            @strongify(self);
            //如果还有设备在维保中，则不让修改维保过程
            if (self.repairDetail.all_inspection_state == 1)
            {
                [self showMBP:@"设备正在维保中，此刻不能更改维修过程！" withBlock:nil];
            }
            else
            {
                BXTMMProcessViewController *procossVC = [[BXTMMProcessViewController alloc] initWithNibName:@"BXTMMProcessViewController" bundle:nil repairID:self.repairDetail.orderID deviceList:self.repairDetail.device_list];
                [self.navigationController pushViewController:procossVC animated:YES];
            }
        }];
        [alertCtr addAction:doneAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您是否确定当前工单已结束？"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"再看看"
                                              otherButtonTitles:@"确定",nil];
        @weakify(self);
        [[alert rac_buttonClickedSignal] subscribeNext:^(id x) {
            @strongify(self);
            if ([x integerValue] == 1)
            {
                [self showLoadingMBP:@"请稍等..."];
                //如果还有设备在维保中，则不让修改维保过程
                if (self.repairDetail.all_inspection_state == 1)
                {
                    [self showMBP:@"设备正在维保中，此刻不能更改维修过程！" withBlock:nil];
                }
                else
                {
                    BXTMMProcessViewController *procossVC = [[BXTMMProcessViewController alloc] initWithNibName:@"BXTMMProcessViewController" bundle:nil repairID:self.repairDetail.orderID deviceList:self.repairDetail.device_list];
                    [self.navigationController pushViewController:procossVC animated:YES];
                }
            }
        }];
        [alert show];
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairDetail && data.count > 0)
    {
        NSDictionary *dictionary = data[0];
        [BXTRepairDetailInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"orderID":@"id"};
        }];
        [BXTMaintenanceManInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"mmID":@"id"};
        }];
        [BXTDeviceMMListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"deviceMMID":@"id"};
        }];
        [BXTAdsNameInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"adsNameID":@"id"};
        }];
        [BXTRepairPersonInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"rpID":@"id"};
        }];
        self.repairDetail = [BXTRepairDetailInfo mj_objectWithKeyValues:dictionary];
        
        //状态相关
        self.orderState.text = self.repairDetail.repairstate_name;
        BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, StateViewHeight) withProgress:self.repairDetail.progress isShowState:NO];
        [_firstBV addSubview:drawView];
        
        //各种赋值
        BXTRepairPersonInfo *repairPerson = self.repairDetail.fault_user_arr[0];
        NSString *headURL = repairPerson.head_pic;
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        _repairerName.text = repairPerson.name;
        _departmentName.text = [NSString stringWithFormat:@"部门：%@",repairPerson.department_name];
        _positionName.text = [NSString stringWithFormat:@"职位：%@",repairPerson.duty_name];
        _repairID.text = [NSString stringWithFormat:@"工单编号:%@",self.repairDetail.orderid];
        _repairTime.text = [NSString stringWithFormat:@"报修时间:%@",self.repairDetail.fault_time_name];
        _place.text = [NSString stringWithFormat:@"报修位置:%@",self.repairDetail.place_name];
        _faultType.text = [NSString stringWithFormat:@"故障类型:%@",self.repairDetail.faulttype_name];
        _cause.text = [NSString stringWithFormat:@"故障描述:%@",self.repairDetail.cause];
        [_contentView layoutIfNeeded];
        _first_bv_height.constant = CGRectGetMaxY(_cause.frame) + 10.f;
        [_firstBV layoutIfNeeded];
        
        //故障图相关
        [self loadFaultPic];
        
        /**阿西吧！需要各种判断，醉了。。**/
        if (self.repairDetail.fault_pic.count == 0 &&
            self.repairDetail.device_list.count == 0 &&
            self.repairDetail.repair_user_arr.count == 0)
        {
            _fouthBV.hidden = YES;
            _fifthBV.hidden = YES;
            _sixthBV.hidden = YES;
            _seventhBV.hidden = YES;
            _eighthBV.hidden = YES;
            _ninthBV.hidden = YES;
            _tenthBV.hidden = YES;
            [self updateContentConstant:self.thirdBV];
            return;
        }
        else if (self.repairDetail.fault_pic.count &&
                 self.repairDetail.device_list.count == 0 &&
                 self.repairDetail.repair_user_arr.count == 0)
        {
            _fifthBV.hidden = YES;
            _sixthBV.hidden = YES;
            _seventhBV.hidden = YES;
            _eighthBV.hidden = YES;
            _ninthBV.hidden = YES;
            _tenthBV.hidden = YES;
            [self updateContentConstant:self.fouthBV];
            return;
        }
        else if (self.repairDetail.fault_pic.count == 0 &&
                 self.repairDetail.device_list.count &&
                 self.repairDetail.repair_user_arr.count == 0)
        {
            _fouthBV.hidden = YES;
            _sixthBV.hidden = YES;
            _seventhBV.hidden = YES;
            _eighthBV.hidden = YES;
            _ninthBV.hidden = YES;
            _tenthBV.hidden = YES;
            //设备列表相关
            [self loadDeviceList];
            self.fifth_top.constant = 12.f;
            [self.fifthBV layoutIfNeeded];
            [self updateContentConstant:self.fifthBV];
            return;
        }
        else if (self.repairDetail.fault_pic.count &&
                 self.repairDetail.device_list.count &&
                 self.repairDetail.repair_user_arr.count == 0)
        {
            _sixthBV.hidden = YES;
            _seventhBV.hidden = YES;
            _eighthBV.hidden = YES;
            _ninthBV.hidden = YES;
            _tenthBV.hidden = YES;
            //故障图片
            [self loadFaultPic];
            //设备列表相关
            [self loadDeviceList];
            [self updateContentConstant:self.fifthBV];
            return;
        }
        else if (self.repairDetail.fault_pic.count == 0 &&
                 self.repairDetail.device_list.count == 0 &&
                 self.repairDetail.repair_user_arr.count)
        {
            _fouthBV.hidden = YES;
            _fifthBV.hidden = YES;
            _sixth_top.constant = 12.f;
            [_sixthBV layoutIfNeeded];
            //维修员相关
            [self loadMMList];
            [self loadAllOthers];
            [_contentView layoutIfNeeded];
            return;
        }
        else if (self.repairDetail.fault_pic.count &&
                 self.repairDetail.device_list.count &&
                 self.repairDetail.repair_user_arr.count)
        {
            //设备列表相关
            [self loadDeviceList];
            //维修员相关
            [self loadMMList];
            [self loadAllOthers];
            [_contentView layoutIfNeeded];
            return;
        }
        
        //设备列表相关
        [self loadDeviceList];
        //维修员相关
        [self loadMMList];
        //维修报告相关
        [self loadMaintenanceReports];
        //维修后图片相关
        [self loadFixedPic];
        //评价相关
        [self loadEvaluationContent];
        //评价图片相关
        [self loadEvaluationPic];
        
        _content_height.constant = CGRectGetMaxY(_tenthBV.frame)+ 10.f + YBottomBackHeight + 12.f;
        [_contentView layoutIfNeeded];
    }
    else if (type == HandlePermission && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        for (UIView *view in self.eleventhBV.subviews)
        {
            [view removeFromSuperview];
        }
        [self.btnArray removeAllObjects];
        [self.btnArray addObjectsFromArray:[BXTButtonInfo mj_objectArrayWithKeyValuesArray:data]];
        [self loadButtons];
    }
    else if (type == StartRepair && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
        __weak typeof(self) weakSelf = self;
        [self showMBP:@"已经开始！" withBlock:^(BOOL hidden) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    else if (type == ReaciveOrder)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReaciveOrderSuccess" object:nil];
            [self showMBP:@"接单成功！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
    else if (type == DeleteRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
            [self showMBP:@"删除成功!" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
    else if (type == StartRepair && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
        __weak typeof(self) weakSelf = self;
        [self showMBP:@"维修开始！" withBlock:^(BOOL hidden) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
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
