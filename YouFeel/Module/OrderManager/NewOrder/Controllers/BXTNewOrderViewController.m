//
//  BXTNewOrderViewController.m
//  YouFeel
//
//  Created by Jason on 15/11/12.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTNewOrderViewController.h"
#import "BXTHeaderForVC.h"
#import "UIImageView+WebCache.h"
#import "BXTRepairDetailInfo.h"
#import "BXTRejectOrderViewController.h"

#define DispatchBackViewHeight 60.f
#define BottomButtonHeight 50.f
#define FaultImageWidth (SCREEN_WIDTH - 15.f - 15.f - 20.f - 20.f)/3.f

@interface BXTNewOrderViewController ()<BXTDataResponseDelegate>
{
    AVAudioPlayer       *player;
}

@property (nonatomic, strong) NSString *currentOrderID;

@end

@implementation BXTNewOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"新工单指派" andRightTitle:@"" andRightImage:nil];

    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"]] error:nil];
    player.volume = 0.8f;
    player.numberOfLoops = -1;
    
    ++[BXTGlobal shareGlobal].assignNumber;

    /**获取详情**/
    [self showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    NSInteger index = [BXTGlobal shareGlobal].assignNumber;
    self.currentOrderID = [[BXTGlobal shareGlobal].assignOrderIDs objectAtIndex:index - 1];
    [request repairDetail:[NSString stringWithFormat:@"%@",self.currentOrderID]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (player)
    {
        player = nil;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (player)
    {
        [player stop];
    }
}

#pragma mark -
#pragma mark 闹铃
- (void)afterTime
{
    [player play];
    __block NSInteger count = 20;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 3), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_time, ^{
        count--;
        if (count <= 0)
        {
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [player stop];
            });
        }
    });
    dispatch_resume(_time);
}

- (IBAction)rejectOrder:(id)sender
{
    BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:self.currentOrderID viewControllerType:AssignVCType];
    [self.navigationController pushViewController:rejectVC animated:YES];
}

- (IBAction)reaciveOrder:(id)sender
{
    [self showLoadingMBP:@"请稍候..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request reaciveDispatchedOrderID:self.repairDetail.orderID];
}

- (void)addTapToImageView:(UIImageView *)imageView
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    [imageView addGestureRecognizer:tapGR];
    @weakify(self);
    [[tapGR rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        self.mwPhotosArray = [self containAllPhotos:self.repairDetail.fault_pic];
        [self loadMWPhotoBrowser:imageView.tag];
    }];
}

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairDetail && data.count > 0)
    {
        [self afterTime];

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
        [BXTFaultPicInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"picID":@"id"};
        }];
        
        BXTRepairDetailInfo *repairDetail = [BXTRepairDetailInfo mj_objectWithKeyValues:dictionary];
        self.repairDetail = repairDetail;
        
        // 指派人信息
        BXTMaintenanceManInfo *dispathPerson = self.repairDetail.dispatch_ower_arr[0];
        NSString *headURL = dispathPerson.head_pic;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headURL]];
        self.dispathName.text = dispathPerson.name;
        self.departmentName.text = dispathPerson.department_name;
        UIFont *font = [UIFont systemFontOfSize:17.f];
        CGSize jobSize = MB_MULTILINE_TEXTSIZE(dispathPerson.duty_name, font, CGSizeMake(200, 20), NSLineBreakByWordWrapping);
        self.job_width.constant = jobSize.width + 15;
        [self.jobName layoutIfNeeded];
        self.jobName.text = dispathPerson.duty_name;

        // 报修人信息
        BXTRepairPersonInfo *repairPerson = repairDetail.fault_user_arr[0];
        NSString *repairHeadURL = repairPerson.head_pic;
        [self.repairHeadImgView sd_setImageWithURL:[NSURL URLWithString:repairHeadURL]];
        self.repairNameLabel.text = repairPerson.name;
        self.departmentNameLabel.text = repairPerson.department_name;
        UIFont *jobFont = [UIFont systemFontOfSize:17.f];
        CGSize job_size = MB_MULTILINE_TEXTSIZE(repairPerson.duty_name, jobFont, CGSizeMake(200, 20), NSLineBreakByWordWrapping);
        self.job_name_width.constant = job_size.width + 15;
        [self.jobNameLabel layoutIfNeeded];
        self.jobNameLabel.text = repairPerson.duty_name;
        
        // 工单号
        self.orderNumberLabel.text = repairDetail.orderid;
        
        // 报单时间
        NSArray *timesArray = [repairDetail.fault_time_name componentsSeparatedByString:@" "];
        self.repairTimeLabel.text = timesArray[0];
        self.hoursLabel.text = timesArray[1];
        
        // 是否预约
        self.appointmentImgView.hidden = [repairDetail.is_appointment isEqualToString:@"1"] ? NO : YES;
        
        // 位置
        self.placeLabel.text = repairDetail.place_name;
        [self.view layoutIfNeeded];
        self.second_view_height.constant = CGRectGetMaxY(self.placeLabel.frame) + 15.f;
        [self.second_bg_view layoutIfNeeded];
        
        // 故障类型
        self.faultTypeLabel.text = repairDetail.faulttype_name;
        
        // 故障描述
        self.repairContent.text = repairDetail.cause;
        [self.view layoutIfNeeded];
        
        // 故障图片
        NSArray *imgArray = repairDetail.fault_pic;
        if (imgArray.count)
        {
            UIImageView *imageViewOne = nil;
            if (imgArray.count == 1)
            {
                BXTFaultPicInfo *faultPic = repairDetail.fault_pic[0];
                
                imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.lineView.frame) + 15.f, FaultImageWidth, FaultImageWidth)];
                imageViewOne.tag = 0;
                imageViewOne.layer.masksToBounds = YES;
                imageViewOne.userInteractionEnabled = YES;
                imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
                [imageViewOne sd_setImageWithURL:[NSURL URLWithString:faultPic.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
                [self.third_bg_view addSubview:imageViewOne];
                
                [self addTapToImageView:imageViewOne];
            }
            else if (imgArray.count == 2)
            {
                BXTFaultPicInfo *faultPicOne = repairDetail.fault_pic[0];
                BXTFaultPicInfo *faultPicTwo = repairDetail.fault_pic[1];
                
                imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.lineView.frame) + 15.f, FaultImageWidth, FaultImageWidth)];
                imageViewOne.tag = 0;
                imageViewOne.layer.masksToBounds = YES;
                imageViewOne.userInteractionEnabled = YES;
                imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
                [imageViewOne sd_setImageWithURL:[NSURL URLWithString:faultPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
                [self.third_bg_view addSubview:imageViewOne];
                
                UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageViewOne.frame) + 20.f, CGRectGetMaxY(self.lineView.frame) + 15.f, FaultImageWidth, FaultImageWidth)];
                imageViewTwo.tag = 1;
                imageViewTwo.layer.masksToBounds = YES;
                imageViewTwo.userInteractionEnabled = YES;
                imageViewTwo.contentMode = UIViewContentModeScaleAspectFill;
                [imageViewTwo sd_setImageWithURL:[NSURL URLWithString:faultPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
                [self.third_bg_view addSubview:imageViewTwo];
                
                [self addTapToImageView:imageViewOne];
                [self addTapToImageView:imageViewTwo];
            }
            else
            {
                BXTFaultPicInfo *faultPicOne = repairDetail.fault_pic[0];
                BXTFaultPicInfo *faultPicTwo = repairDetail.fault_pic[1];
                BXTFaultPicInfo *faultPicThree = repairDetail.fault_pic[2];
                
                imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.lineView.frame) + 15.f, FaultImageWidth, FaultImageWidth)];
                imageViewOne.tag = 0;
                imageViewOne.layer.masksToBounds = YES;
                imageViewOne.userInteractionEnabled = YES;
                imageViewOne.contentMode = UIViewContentModeScaleAspectFill;
                [imageViewOne sd_setImageWithURL:[NSURL URLWithString:faultPicOne.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
                [self.third_bg_view addSubview:imageViewOne];
                
                UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageViewOne.frame) + 20.f, CGRectGetMaxY(self.lineView.frame) + 15.f, FaultImageWidth, FaultImageWidth)];
                imageViewTwo.tag = 1;
                imageViewTwo.layer.masksToBounds = YES;
                imageViewTwo.userInteractionEnabled = YES;
                imageViewTwo.contentMode = UIViewContentModeScaleAspectFill;
                [imageViewTwo sd_setImageWithURL:[NSURL URLWithString:faultPicTwo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
                [self.third_bg_view addSubview:imageViewTwo];
                
                UIImageView *imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageViewTwo.frame) + 20.f, CGRectGetMaxY(self.lineView.frame) + 15.f, FaultImageWidth, FaultImageWidth)];
                imageViewThree.tag = 2;
                imageViewThree.layer.masksToBounds = YES;
                imageViewThree.userInteractionEnabled = YES;
                imageViewThree.contentMode = UIViewContentModeScaleAspectFill;
                [imageViewThree sd_setImageWithURL:[NSURL URLWithString:faultPicThree.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
                [self.third_bg_view addSubview:imageViewThree];
                
                [self addTapToImageView:imageViewOne];
                [self addTapToImageView:imageViewTwo];
                [self addTapToImageView:imageViewThree];
            }
            
            if (CGRectGetMinY(self.third_bg_view.frame) + CGRectGetMaxY(imageViewOne.frame) + 20.f < SCREEN_HEIGHT - KNAVIVIEWHEIGHT - DispatchBackViewHeight - BottomButtonHeight)
            {
                self.third_view_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - DispatchBackViewHeight - BottomButtonHeight - CGRectGetMinY(self.third_bg_view.frame);
            }
            else
            {
                self.third_view_height.constant = CGRectGetMaxY(imageViewOne.frame) + 20.f;
            }
        }
        else
        {
            if (CGRectGetMinY(self.third_bg_view.frame) + CGRectGetMaxY(self.lineView.frame) + 20.f < SCREEN_HEIGHT - KNAVIVIEWHEIGHT - DispatchBackViewHeight - BottomButtonHeight)
            {
                self.third_view_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - DispatchBackViewHeight - BottomButtonHeight - CGRectGetMinY(self.third_bg_view.frame);
            }
            else
            {
                self.third_view_height.constant = CGRectGetMaxY(self.lineView.frame) + 20.f;
            }
        }
        [self.third_bg_view layoutIfNeeded];
        
        if (CGRectGetMaxY(self.third_bg_view.frame) > SCREEN_HEIGHT - KNAVIVIEWHEIGHT - DispatchBackViewHeight - BottomButtonHeight)
        {
            self.content_height.constant = CGRectGetMaxY(self.third_bg_view.frame);
        }
        else
        {
            self.content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - DispatchBackViewHeight - BottomButtonHeight;
        }
        [self.contentView layoutIfNeeded];
    }
    else if (type == ReaciveOrder)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReaciveOrderSuccess" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadListData" object:nil];
            [self showMBP:@"接单成功！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
                --[BXTGlobal shareGlobal].assignNumber;
                [[BXTGlobal shareGlobal].assignOrderIDs removeObject:self.currentOrderID];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"041"])
        {
            [self showMBP:@"工单已被抢！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
                --[BXTGlobal shareGlobal].assignNumber;
                [[BXTGlobal shareGlobal].assignOrderIDs removeObject:self.currentOrderID];
            }];
        }
        else
        {
            [self showMBP:@"接单失败！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
                --[BXTGlobal shareGlobal].assignNumber;
                [[BXTGlobal shareGlobal].assignOrderIDs removeObject:self.currentOrderID];
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    if (type == ReaciveOrder)
    {
        [self showMBP:@"接单失败！" withBlock:^(BOOL hidden) {
            [self.navigationController popViewControllerAnimated:YES];
            --[BXTGlobal shareGlobal].assignNumber;
            [[BXTGlobal shareGlobal].assignOrderIDs removeObject:self.currentOrderID];
        }];
    }
    else
    {
        [self hideMBP];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
