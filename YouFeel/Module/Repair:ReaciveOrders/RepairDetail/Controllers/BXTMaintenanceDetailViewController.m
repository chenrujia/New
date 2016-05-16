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
#import "BXTMenViewController.h"
#import "BXTRejectOrderViewController.h"
#import "BXTEvaluationViewController.h"
#import "AMRatingControl.h"
#import "BXTButtonInfo.h"
#import "UIView+SDAutoLayout.h"

//底部白色背景图高度
#define YBottomBackHeight 64.f

@interface BXTMaintenanceDetailViewController ()<BXTDataResponseDelegate>
{
    BOOL isHaveButtons;//底部是否有按钮
}
@property (nonatomic ,strong) NSString         *repair_id;
@property (nonatomic ,strong) NSArray          *comeTimeArray;
@property (nonatomic ,strong) UIView           *bgView;
@property (nonatomic ,assign) NSTimeInterval   timeInterval;
@property (nonatomic ,strong) NSMutableArray   *manIDArray;
@property (nonatomic ,strong) UIButton         *evaluationBtn;
@property (nonatomic ,strong) UIView           *evaBackView;
@property (nonatomic ,strong) NSMutableArray   *btnArray;

/**
 *  确认工单 - 驳回工单 - 评价 三者点击返回后需要刷新列表
 */
@property (assign, nonatomic) BOOL isNeedRefresh;

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
        [self navigationSetting:@"工单详情" andRightTitle:nil andRightImage:nil];
    }
    if (!self.affairID) {
        self.affairID = @"";
    }
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    self.btnArray = buttons;
    isFirst = YES;
    self.connectTa.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    self.connectTa.layer.borderWidth = 1.f;
    self.connectTa.layer.cornerRadius = 4.f;
    
    //联系他
    @weakify(self);
    [[self.connectTa rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTRepairPersonInfo *repairPerson = self.repairDetail.fault_user_arr[0];
        [self handleUserInfo:@{@"UserID":repairPerson.out_userid,
                               @"UserName":repairPerson.name,
                               @"HeadPic":repairPerson.head_pic}];
    }];
    self.orderType.layer.masksToBounds = YES;
    self.orderType.layer.cornerRadius = 3.f;
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
    [self.headImgView addGestureRecognizer:tapGesture];
    
    //给故障图片、维修完成图片、评论图片的点击事件
    [self addTapToImageView:self.faultPicOne];
    [self addTapToImageView:self.faultPicTwo];
    [self addTapToImageView:self.faultPicThree];
    [self addTapToImageView:self.fixPicOne];
    [self addTapToImageView:self.fixPicTwo];
    [self addTapToImageView:self.fixPicThree];
    [self addTapToImageView:self.evaluatePicOne];
    [self addTapToImageView:self.evaluatePicTwo];
    [self addTapToImageView:self.evaluatePicThree];
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"])
    {
        [timeArray addObject:[NSString stringWithFormat:@"%@分钟内", timeStr]];
    }
    [timeArray addObject:@"自定义"];
    self.comeTimeArray = timeArray;
    
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
    self.navigationController.navigationBarHidden = NO;
}

- (void)navigationLeftButton
{
    if (self.sceneType == OtherAffairType)
    {
        if (self.delegateSignal && self.isNeedRefresh)
        {
            [self.delegateSignal sendNext:nil];
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
}

- (void)addTapToImageView:(UIImageView *)imageView
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    [imageView addGestureRecognizer:tapGR];
    @weakify(self);
    [[tapGR rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        UIView *supView = imageView.superview;
        if (supView == self.fouthBV)
        {
            self.mwPhotosArray = [self containAllPhotos:self.repairDetail.fault_pic];
        }
        else if (supView == self.eighthBV)
        {
            self.mwPhotosArray = [self containAllPhotos:self.repairDetail.fixed_pic];
        }
        else if (supView == self.tenthBV)
        {
            self.mwPhotosArray = [self containAllPhotos:self.repairDetail.evaluation_pic];
        }
        [self loadMWPhotoBrowser:imageView.tag];
    }];
}

#pragma mark -
#pragma mark 请求数据
- (void)requestDetail
{
    [BXTGlobal showLoadingMBP:@"加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**请求控制按钮显示**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request handlePermission:self.repair_id sceneID:[NSString stringWithFormat:@"%ld",(long)self.sceneType]];
    });
    dispatch_async(concurrentQueue, ^{
        /**获取详情**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request repairDetail:[NSString stringWithFormat:@"%@",_repair_id]];
    });
}

#pragma mark -
#pragma mark 更新ContentView高度
- (void)updateContentConstant:(UIView *)view
{
    CGFloat bottomBVHeight = isHaveButtons ? YBottomBackHeight : 0.f;
    self.scroller_bottom.constant = isHaveButtons ? YBottomBackHeight : 0.f;
    [self.contentScrollView layoutIfNeeded];
    if (CGRectGetMaxY(view.frame) + 12.f + bottomBVHeight > SCREEN_HEIGHT - KNAVIVIEWHEIGHT)
    {
        self.content_height.constant = CGRectGetMaxY(view.frame) + 12.f;
    }
    else
    {
        self.content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - bottomBVHeight;
    }
    [self.contentView layoutIfNeeded];
}

- (void)loadDeviceList
{
    //设备列表相关
    NSInteger deviceCount = self.repairDetail.device_lists.count;
    CGFloat secondHeight = 32.f + 63.f * deviceCount;
    if (deviceCount)
    {
        self.fifthBV.hidden = NO;
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
        self.fifth_bv_height.constant = secondHeight;
        [self.fifthBV layoutIfNeeded];
        for (NSInteger i = 0; i < deviceCount; i++)
        {
            BOOL isLast = deviceCount == i + 1 ? YES : NO;
            UIView *deviceView = [self deviceLists:i comingFromDeviceInfo:self.isComingFromDeviceInfo isLast:isLast];
            [self.fifthBV addSubview:deviceView];
        }
        CGFloat space = self.fouthBV.hidden ? 24.f : 159.f;
        self.sixth_top.constant = space + secondHeight;
        [self.sixthBV layoutIfNeeded];
    }
    else
    {
        self.fifthBV.hidden = YES;
    }
}

- (void)loadMMList
{
    //维修员相关
    NSInteger usersCount = self.repairDetail.repair_user_arr.count;
    if (usersCount)
    {
        self.sixthBV.hidden = NO;
        self.mmScroller.contentSize = CGSizeMake(113.f * usersCount, 0);
        //先清除，后添加
        for (UIView *subview in self.mmScroller.subviews)
        {
            [subview removeFromSuperview];
        }
        
        [self.manIDArray removeAllObjects];
        for (NSInteger i = 0; i < usersCount; i++)
        {
            BXTMaintenanceManInfo *mmInfo = self.repairDetail.repair_user_arr[i];
            [self.manIDArray addObject:mmInfo.mmID];
            UIView *userBack = [self viewForUser:i andMaintenance:mmInfo];
            [self.mmScroller addSubview:userBack];
        }
    }
    else
    {
        self.sixthBV.hidden = YES;
    }
}

- (void)loadMaintenanceReports
{
    //维修报告相关
    self.seventhBV.hidden = NO;
    self.scroller_bottom.constant = isHaveButtons ? YBottomBackHeight : 0.f;
    [self.contentScrollView layoutIfNeeded];
    self.endTime.text = [NSString stringWithFormat:@"结束时间：%@",self.repairDetail.report.end_time_name];
    if ([self.repairDetail.task_type integerValue] == 2)
    {
        self.maintencePlace.text = [NSString stringWithFormat:@"维保位置：%@",self.repairDetail.report.real_place_name];
        self.doneFaultType.text = [NSString stringWithFormat:@"维保项目：%@",self.repairDetail.report.real_faulttype_name];
        self.doneState.text = [NSString stringWithFormat:@"维保状态：%@",self.repairDetail.report.real_repairstate_name];
        self.doneNotes.text = [NSString stringWithFormat:@"维保记录：%@",self.repairDetail.report.workprocess];
        [self.view layoutIfNeeded];
        self.seventh_bv_height.constant = CGRectGetMaxY(self.doneNotes.frame) + 10.f;
        [self.view layoutIfNeeded];
    }
    else
    {
        self.maintencePlace.text = [NSString stringWithFormat:@"维修位置：%@",self.repairDetail.report.real_place_name];
        self.doneFaultType.text = [NSString stringWithFormat:@"故障类型：%@",self.repairDetail.report.real_faulttype_name];
        self.doneState.text = [NSString stringWithFormat:@"维修状态：%@",self.repairDetail.report.real_repairstate_name];
        self.doneNotes.text = [NSString stringWithFormat:@"维修记录：%@",self.repairDetail.report.workprocess];
        if (self.repairDetail.instructions_info.opt_content.length > 0)
        {
            self.commentContent.hidden = NO;
            self.commentContent.text = [NSString stringWithFormat:@"批注内容：%@  %@\r%@",self.repairDetail.instructions_info.opt_name,self.repairDetail.instructions_info.opt_data,self.repairDetail.instructions_info.opt_content];
            [self.view layoutIfNeeded];
            self.seventh_bv_height.constant = CGRectGetMaxY(self.commentContent.frame) + 10.f;
            [self.view layoutIfNeeded];
        }
        else
        {
            [self.view layoutIfNeeded];
            self.seventh_bv_height.constant = CGRectGetMaxY(self.doneNotes.frame) + 10.f;
            [self.view layoutIfNeeded];
        }
    }
}

- (void)loadFaultPic
{
    self.fouthBV.hidden = NO;
    switch (self.repairDetail.fault_pic.count)
    {
        case 1:
        {
            BXTFaultPicInfo *faultPic = self.repairDetail.fault_pic[0];
            self.faultPicOne.hidden = NO;
            [self.faultPicOne sd_setImageWithURL:[NSURL URLWithString:faultPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 2:
        {
            BXTFaultPicInfo *faultPicOne = self.repairDetail.fault_pic[0];
            self.faultPicOne.hidden = NO;
            [self.faultPicOne sd_setImageWithURL:[NSURL URLWithString:faultPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *faultPicTwo = self.repairDetail.fault_pic[1];
            self.faultPicTwo.hidden = NO;
            [self.faultPicTwo sd_setImageWithURL:[NSURL URLWithString:faultPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 3:
        {
            BXTFaultPicInfo *faultPicOne = self.repairDetail.fault_pic[0];
            self.faultPicOne.hidden = NO;
            [self.faultPicOne sd_setImageWithURL:[NSURL URLWithString:faultPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *faultPicTwo = self.repairDetail.fault_pic[1];
            self.faultPicTwo.hidden = NO;
            [self.faultPicTwo sd_setImageWithURL:[NSURL URLWithString:faultPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *faultPicThree = self.repairDetail.fault_pic[2];
            self.faultPicThree.hidden = NO;
            [self.faultPicThree sd_setImageWithURL:[NSURL URLWithString:faultPicThree.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        default:
            self.fouthBV.hidden = YES;
            break;
    }
}

- (void)loadFixedPic
{
    //维修后图片相关
    self.eighthBV.hidden = NO;
    switch (self.repairDetail.fixed_pic.count)
    {
        case 1:
        {
            BXTFaultPicInfo *fixPic = self.repairDetail.fixed_pic[0];
            self.fixPicOne.hidden = NO;
            [self.fixPicOne sd_setImageWithURL:[NSURL URLWithString:fixPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 2:
        {
            BXTFaultPicInfo *fixPicOne = self.repairDetail.fixed_pic[0];
            self.fixPicOne.hidden = NO;
            [self.fixPicOne sd_setImageWithURL:[NSURL URLWithString:fixPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *fixPicTwo = self.repairDetail.fixed_pic[1];
            self.fixPicTwo.hidden = NO;
            [self.fixPicTwo sd_setImageWithURL:[NSURL URLWithString:fixPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 3:
        {
            BXTFaultPicInfo *fixPicOne = self.repairDetail.fixed_pic[0];
            self.fixPicOne.hidden = NO;
            [self.fixPicOne sd_setImageWithURL:[NSURL URLWithString:fixPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *fixPicTwo = self.repairDetail.fixed_pic[1];
            self.fixPicTwo.hidden = NO;
            [self.fixPicTwo sd_setImageWithURL:[NSURL URLWithString:fixPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *fixPicThree = self.repairDetail.fixed_pic[2];
            self.fixPicThree.hidden = NO;
            [self.fixPicThree sd_setImageWithURL:[NSURL URLWithString:fixPicThree.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        default:
            self.eighthBV.hidden = YES;
            break;
    }
}

- (void)loadEvaluationContent
{
    //评价相关
    self.ninthBV.hidden = NO;
    for (UIView *subview in self.ninthBV.subviews)
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
        [self.ninthBV addSubview:imagesRatingControl];
    }
    self.scroller_bottom.constant = isHaveButtons ? YBottomBackHeight : 0.f;
    [self.contentScrollView layoutIfNeeded];
    self.evaluateNotes.text = self.repairDetail.evaluation_notes;
    [self.contentView layoutIfNeeded];
    self.ninth_bv_height.constant = CGRectGetMaxY(self.evaluateNotes.frame) + 10.f;
    [self.view layoutIfNeeded];
}

- (void)loadEvaluationPic
{
    //评价图片相关
    self.tenthBV.hidden = NO;
    switch (self.repairDetail.evaluation_pic.count)
    {
        case 1:
        {
            BXTFaultPicInfo *evaluationPic = self.repairDetail.evaluation_pic[0];
            self.evaluatePicOne.hidden = NO;
            [self.evaluatePicOne sd_setImageWithURL:[NSURL URLWithString:evaluationPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 2:
        {
            BXTFaultPicInfo *evaluationPic = self.repairDetail.evaluation_pic[0];
            self.evaluatePicOne.hidden = NO;
            [self.evaluatePicOne sd_setImageWithURL:[NSURL URLWithString:evaluationPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *evaluationPicTwo = self.repairDetail.evaluation_pic[1];
            self.evaluatePicTwo.hidden = NO;
            [self.evaluatePicTwo sd_setImageWithURL:[NSURL URLWithString:evaluationPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        case 3:
        {
            BXTFaultPicInfo *evaluationPic = self.repairDetail.evaluation_pic[0];
            self.evaluatePicOne.hidden = NO;
            [self.evaluatePicOne sd_setImageWithURL:[NSURL URLWithString:evaluationPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *evaluationPicTwo = self.repairDetail.evaluation_pic[1];
            self.evaluatePicTwo.hidden = NO;
            [self.evaluatePicTwo sd_setImageWithURL:[NSURL URLWithString:evaluationPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
            BXTFaultPicInfo *evaluationPicThree = self.repairDetail.evaluation_pic[2];
            self.evaluatePicThree.hidden = NO;
            [self.evaluatePicThree sd_setImageWithURL:[NSURL URLWithString:evaluationPicThree.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
            break;
        default:
            self.tenthBV.hidden = YES;
            break;
    }
}

- (void)loadAllOthers
{
    //有维修报告
    if ([self.repairDetail.repairstate integerValue] > 3)
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
                    self.content_height.constant = CGRectGetMaxY(self.tenthBV.frame) + 12.f;
                }
                else
                {
                    self.tenthBV.hidden = YES;
                    self.content_height.constant = CGRectGetMaxY(self.ninthBV.frame) + 12.f;
                }
            }
            else
            {
                self.ninthBV.hidden = YES;
                self.tenthBV.hidden = YES;
                self.content_height.constant = CGRectGetMaxY(self.eighthBV.frame) + 12.f;
            }
        }
        else
        {
            //有评价内容
            if (self.repairDetail.evaluation_notes.length > 0)
            {
                self.ninth_top.constant = 12.f;
                [self.ninthBV layoutIfNeeded];
                [self loadEvaluationContent];
                //有评价图片
                if (self.repairDetail.evaluation_pic.count)
                {
                    [self loadEvaluationPic];
                    self.content_height.constant = CGRectGetMaxY(self.tenthBV.frame)+ 10.f + 12.f;
                }
                else
                {
                    self.tenthBV.hidden = YES;
                    self.content_height.constant = CGRectGetMaxY(self.ninthBV.frame)+ 10.f + 12.f;
                }
            }
            else
            {
                self.eighthBV.hidden = YES;
                self.ninthBV.hidden = YES;
                self.tenthBV.hidden = YES;
                [self updateContentConstant:self.seventhBV];
            }
        }
    }
    else
    {
        self.seventhBV.hidden = YES;
        self.eighthBV.hidden = YES;
        self.ninthBV.hidden = YES;
        self.tenthBV.hidden = YES;
        [self updateContentConstant:self.sixthBV];
    }
}

- (void)loadButtons
{
    self.buttonBV.hidden = NO;
    switch (self.btnArray.count)
    {
        case 1:
        {
            BXTButtonInfo *btnInfo = self.btnArray[0];
            UIButton *btn = [self initialButton:NO];
            [btn setTitle:btnInfo.button_name forState:UIControlStateNormal];
            @weakify(self);
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self actionWithButtonInfo:btnInfo];
            }];
            
            CGFloat space = IS_IPHONE6 ? 100.f : 60.f;
            btn.sd_layout
            .leftSpaceToView(self.buttonBV,space)
            .rightSpaceToView(self.buttonBV,space)
            .topSpaceToView(self.buttonBV,12)
            .heightIs(44);
        }
            break;
        case 2:
        {
            BOOL isContain = NO;
            NSInteger index = 0;
            for (NSInteger i = 0; i < 2; i++)
            {
                BXTButtonInfo *btnInfo = self.btnArray[i];
                if (btnInfo.button_key == 2)
                {
                    isContain = YES;
                    index = i;
                    break;
                }
            }
            
            UIButton *leftBtn = [self initialButton:YES];
            UIButton *rightBtn = [self initialButton:NO];
            if (isContain && index == 0)
            {
                BXTButtonInfo *leftBtnInfo = self.btnArray[1];
                [leftBtn setTitle:leftBtnInfo.button_name forState:UIControlStateNormal];
                @weakify(self);
                [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    [self actionWithButtonInfo:leftBtnInfo];
                }];
                
                BXTButtonInfo *rightBtnInfo = self.btnArray[0];
                [rightBtn setTitle:rightBtnInfo.button_name forState:UIControlStateNormal];
                [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    [self actionWithButtonInfo:rightBtnInfo];
                }];
            }
            else
            {
                BXTButtonInfo *leftBtnInfo = self.btnArray[0];
                [leftBtn setTitle:leftBtnInfo.button_name forState:UIControlStateNormal];
                @weakify(self);
                [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    [self actionWithButtonInfo:leftBtnInfo];
                }];
                
                BXTButtonInfo *rightBtnInfo = self.btnArray[1];
                [rightBtn setTitle:rightBtnInfo.button_name forState:UIControlStateNormal];
                [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    [self actionWithButtonInfo:rightBtnInfo];
                }];
            }
            
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
            break;
        default:
            self.buttonBV.hidden = YES;
            
            break;
    }
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

- (void)showRepairInfo
{
    self.scroller_bottom.constant = isHaveButtons ? YBottomBackHeight : 0.f;
    [self.contentScrollView layoutIfNeeded];
    //状态相关
    self.orderState.text = self.repairDetail.repairstate_name;
    BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, StateViewHeight) withProgress:self.repairDetail.progress isShowState:NO];
    [self.firstBV addSubview:drawView];
    
    //各种赋值
    BXTRepairPersonInfo *repairPerson = self.repairDetail.fault_user_arr[0];
    NSString *headURL = repairPerson.head_pic;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    self.repairerName.text = repairPerson.name;
    if ([repairPerson.rpID isEqualToString:[BXTGlobal getUserProperty:U_BRANCHUSERID]])
    {
        self.connectTa.hidden = YES;
    }
    if ([self.repairDetail.is_appointment isEqualToString:@"2"])
    {
        self.alarm.hidden = NO;
    }
    if ([self.repairDetail.task_type integerValue] == 2)
    {
        self.time_width.constant = 290.f;
    }
    self.orderStyle.text = [self.repairDetail.task_type intValue] == 1 ? @"日常" : @"维保";
    self.orderStyle.backgroundColor = [self.repairDetail.task_type intValue] == 1 ? colorWithHexString(@"#F0B660") : colorWithHexString(@"#7EC86E");
    self.departmentName.text = [NSString stringWithFormat:@"部门：%@",repairPerson.department_name];
    self.positionName.text = [NSString stringWithFormat:@"职位：%@",repairPerson.duty_name];
    self.repairID.text = [NSString stringWithFormat:@"工单编号:%@",self.repairDetail.orderid];
    if ([self.repairDetail.task_type integerValue] == 2)
    {
        self.repairPerson.text = @"计划人:";
        self.repairUsers.text = @"维保员:";
        self.maintenceRecord.text = @"维保报告:";
        self.repairTime.text = [NSString stringWithFormat:@"时间范围:%@",self.repairDetail.fault_time_name];
        self.place.text = [NSString stringWithFormat:@"维保位置:%@",self.repairDetail.place_name];
        self.faultType.text = [NSString stringWithFormat:@"维保项目:%@",self.repairDetail.faulttype_name];
        self.cause.text = [NSString stringWithFormat:@"维保内容:%@",self.repairDetail.cause];
    }
    else
    {
        self.repairPerson.text = @"报修人:";
        self.repairUsers.text = @"维修员:";
        self.maintenceRecord.text = @"维修报告:";
        self.repairTime.text = [NSString stringWithFormat:@"报修时间:%@",self.repairDetail.fault_time_name];
        self.place.text = [NSString stringWithFormat:@"报修位置:%@",self.repairDetail.place_name];
        self.faultType.text = [NSString stringWithFormat:@"故障类型:%@",self.repairDetail.faulttype_name];
        self.cause.text = [NSString stringWithFormat:@"故障描述:%@",self.repairDetail.cause];
    }
    [self.contentView layoutIfNeeded];
    self.first_bv_height.constant = CGRectGetMaxY(self.cause.frame) + 10.f;
    [self.firstBV layoutIfNeeded];
    
    //故障图相关
    [self loadFaultPic];
    
    /**阿西吧！需要各种判断，醉了。。**/
    if (self.repairDetail.fault_pic.count == 0 &&
        self.repairDetail.device_lists.count == 0 &&
        self.repairDetail.repair_user_arr.count == 0)
    {
        self.fouthBV.hidden = YES;
        self.fifthBV.hidden = YES;
        self.sixthBV.hidden = YES;
        self.seventhBV.hidden = YES;
        self.eighthBV.hidden = YES;
        self.ninthBV.hidden = YES;
        self.tenthBV.hidden = YES;
        [self updateContentConstant:self.thirdBV];
        return;
    }
    else if (self.repairDetail.fault_pic.count &&
             self.repairDetail.device_lists.count == 0 &&
             self.repairDetail.repair_user_arr.count == 0)
    {
        self.fifthBV.hidden = YES;
        self.sixthBV.hidden = YES;
        self.seventhBV.hidden = YES;
        self.eighthBV.hidden = YES;
        self.ninthBV.hidden = YES;
        self.tenthBV.hidden = YES;
        [self updateContentConstant:self.fouthBV];
        return;
    }
    else if (self.repairDetail.fault_pic.count == 0 &&
             self.repairDetail.device_lists.count &&
             self.repairDetail.repair_user_arr.count == 0)
    {
        self.fouthBV.hidden = YES;
        self.sixthBV.hidden = YES;
        self.seventhBV.hidden = YES;
        self.eighthBV.hidden = YES;
        self.ninthBV.hidden = YES;
        self.tenthBV.hidden = YES;
        //设备列表相关
        [self loadDeviceList];
        self.fifth_top.constant = 12.f;
        [self.fifthBV layoutIfNeeded];
        [self updateContentConstant:self.fifthBV];
        return;
    }
    else if (self.repairDetail.fault_pic.count &&
             self.repairDetail.device_lists.count &&
             self.repairDetail.repair_user_arr.count == 0)
    {
        self.sixthBV.hidden = YES;
        self.seventhBV.hidden = YES;
        self.eighthBV.hidden = YES;
        self.ninthBV.hidden = YES;
        self.tenthBV.hidden = YES;
        //故障图片
        [self loadFaultPic];
        //设备列表相关
        [self loadDeviceList];
        [self updateContentConstant:self.fifthBV];
        return;
    }
    else if (self.repairDetail.fault_pic.count == 0 &&
             self.repairDetail.device_lists.count == 0 &&
             self.repairDetail.repair_user_arr.count)
    {
        self.fouthBV.hidden = YES;
        self.fifthBV.hidden = YES;
        self.sixth_top.constant = 12.f;
        [self.sixthBV layoutIfNeeded];
        //维修员相关
        [self loadMMList];
        [self loadAllOthers];
        [self.contentView layoutIfNeeded];
        return;
    }
    else if (self.repairDetail.fault_pic.count &&
             self.repairDetail.device_lists.count == 0 &&
             self.repairDetail.repair_user_arr.count)
    {
        self.fifthBV.hidden = YES;
        self.sixth_top.constant = 147.f;
        [self.sixthBV layoutIfNeeded];
        //维修员相关
        [self loadMMList];
        [self loadAllOthers];
        [self.contentView layoutIfNeeded];
        return;
    }
    else if (self.repairDetail.fault_pic.count == 0 &&
             self.repairDetail.device_lists.count &&
             self.repairDetail.repair_user_arr.count)
    {
        self.fouthBV.hidden = YES;
        self.fifth_top.constant = 12.f;
        [self.fifthBV layoutIfNeeded];
        //设备列表相关
        [self loadDeviceList];
        [self loadMMList];
        [self loadAllOthers];
        return;
    }
    else if (self.repairDetail.fault_pic.count &&
             self.repairDetail.device_lists.count &&
             self.repairDetail.repair_user_arr.count)
    {
        //设备列表相关
        [self loadDeviceList];
        //维修员相关
        [self loadMMList];
        [self loadAllOthers];
        [self.contentView layoutIfNeeded];
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
    
    CGFloat bottomBVHeight = isHaveButtons ? YBottomBackHeight : 0.f;
    self.content_height.constant = CGRectGetMaxY(self.tenthBV.frame)+ 10.f + bottomBVHeight + 12.f;
    [self.contentView layoutIfNeeded];
}

#pragma mark -
#pragma mark 关闭工单（跟权限相关）
- (void)navigationRightButton
{
    BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:self.repairDetail.orderID viewControllerType:ExamineVCType];
    [self.navigationController pushViewController:rejectVC animated:YES];
}

#pragma mark -
#pragma mark 底部按钮事件处理
- (void)actionWithButtonInfo:(BXTButtonInfo *)btnInfo
{
    //1.取消按钮 2.接单按钮 3.派工按钮 4.增援按钮 5.开始维修 6.结束维修 7.确认驳回 8.确认工单 9.评价工单 11.派工驳回 12.派工确认
    if (btnInfo.button_key == 1)
    {
        [self cancelTheRepair];
    }
    else if (btnInfo.button_key == 2 || btnInfo.button_key == 12)
    {
        [BXTGlobal showLoadingMBP:@"加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request reaciveOrderID:self.repairDetail.orderID];
    }
    else if (btnInfo.button_key == 3 || btnInfo.button_key == 4)
    {
        BXTMenViewController *menVC = [[BXTMenViewController alloc] initWithNibName:@"BXTMenViewController" bundle:nil repairID:self.repairDetail.orderID repairUserList:self.repairDetail.repair_user_arr dispatchUserList:self.repairDetail.dispatch_user_arr];
        [self.navigationController pushViewController:menVC animated:YES];
    }
    else if (btnInfo.button_key == 5)
    {
        [BXTGlobal showLoadingMBP:@"加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request startRepair:self.repairDetail.orderID];
    }
    else if (btnInfo.button_key == 6)
    {
        if ([self.repairDetail.task_type integerValue] == 2)
        {
            [self showLoadingMBP:@"加载中..."];
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request endMaintenceOrder:self.repairDetail.orderID];
        }
        else
        {
            [self endMaintence];
        }
    }
    else if (btnInfo.button_key == 7)
    {
        self.isNeedRefresh = YES;
        
        BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:self.repairDetail.orderID viewControllerType:RejectType];
        rejectVC.affairID = self.affairID;
        [self.navigationController pushViewController:rejectVC animated:YES];
    }
    else if (btnInfo.button_key == 8)
    {
        self.isNeedRefresh = YES;
        
        [BXTGlobal showLoadingMBP:@"加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request isFixed:self.repairDetail.orderID confirmState:@"1" confirmNotes:@"" affairsID:self.affairID];
    }
    else if (btnInfo.button_key == 9)
    {
        self.isNeedRefresh = YES;
        
        BXTEvaluationViewController *evaVC = [[BXTEvaluationViewController alloc] initWithRepairID:self.repairDetail.orderID];
        evaVC.affairID = self.affairID;
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
    NSString *mmLog = self.repairDetail.report.workprocess.length ? self.repairDetail.report.workprocess : @"";
    BXTMMProcessViewController *procossVC = [[BXTMMProcessViewController alloc] initWithNibName:@"BXTMMProcessViewController"
                                                                                         bundle:nil
                                                                                       repairID:self.repairDetail.orderID
                                                                                        placeID:self.repairDetail.place_id
                                                                                      placeName:self.repairDetail.place_name
                                                                                    faultTypeID:self.repairDetail.faulttype_id
                                                                                  faultTypeName:self.repairDetail.faulttype_name
                                                                                 maintenceNotes:mmLog
                                                                                     deviceList:self.repairDetail.device_lists];
    [self.navigationController pushViewController:procossVC animated:YES];
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
        [self showRepairInfo];
    }
    else if (type == HandlePermission && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        for (UIView *view in self.buttonBV.subviews)
        {
            [view removeFromSuperview];
        }
        [self.btnArray removeAllObjects];
        [self.btnArray addObjectsFromArray:[BXTButtonInfo mj_objectArrayWithKeyValuesArray:data]];
        isHaveButtons = self.btnArray.count > 0 ? YES : NO;
        [self loadButtons];
        if (self.repairDetail)
        {
            [self showRepairInfo];
        }
    }
    else if (type == StartRepair && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [self requestDetail];
        }
    }
    else if (type == ReaciveOrder)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReaciveOrderSuccess" object:nil];
            [self requestDetail];
        }
    }
    else if (type == DeleteRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (type == IsSure && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [self requestDetail];
    }
    else if (type == EndMaintenceOrder)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
        [self showMBP:@"维保任务已结束！" withBlock:^(BOOL hidden) {
            [self.navigationController popViewControllerAnimated:YES];
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
