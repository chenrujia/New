//
//  BXTGrabOrderViewController.m
//  YFBX
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTGrabOrderViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTDataRequest.h"
#import "BXTGrabUserConfigView.h"
#import "BXTRepairDetailInfo.h"
#import "UIImageView+WebCache.h"

#define GrabButtonHeight 98.f
#define FaultImageWidth (SCREEN_WIDTH - 15.f - 15.f - 20.f - 20.f)/3.f

@interface BXTGrabOrderViewController ()<BXTDataResponseDelegate>
{
    AVAudioPlayer *player;
    CGFloat       width;
}

@property (nonatomic, strong) NSString              *orderID;
@property (nonatomic, strong) BXTGrabUserConfigView *nameView;
@property (nonatomic, strong) BXTGrabUserConfigView *departmentView;
@property (nonatomic, strong) BXTGrabUserConfigView *jobView;

@end

@implementation BXTGrabOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"实时抢单" andRightTitle:nil andRightImage:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initialSubviews];
    
    ++[BXTGlobal shareGlobal].numOfPresented;
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"]] error:nil];
    player.volume = 0.8f;
    player.numberOfLoops = -1;
    
    NSInteger index = [BXTGlobal shareGlobal].numOfPresented - 1;
    if ([BXTGlobal shareGlobal].newsOrderIDs.count - 1 >= index)
    {
        self.orderID = [[BXTGlobal shareGlobal].newsOrderIDs objectAtIndex:index];
        /**获取详情**/
        [self showLoadingMBP:@"加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request repairDetail:self.orderID];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (player)
    {
        [player stop];
    }
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
#pragma mark 初始化视图
- (void)initialSubviews
{
    self.nameView = [[BXTGrabUserConfigView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3.f, 47.f) imageSize:CGSizeMake(31.f, 31.f) imageName:@"polaroid"];
    self.nameView.iconImgView.layer.masksToBounds = YES;
    self.nameView.iconImgView.layer.cornerRadius = 15.5f;
    self.nameView.contentLabel.text = @"高录扬";
    [self.first_bg_view addSubview:self.nameView];
    
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameView.frame) - 1.f, 8, 1.f, 31.f)];
    lineOne.backgroundColor = colorWithHexString(@"e2e6e8");
    [self.first_bg_view addSubview:lineOne];
    
    self.departmentView = [[BXTGrabUserConfigView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameView.frame), 0, SCREEN_WIDTH/3.f, 47.f) imageSize:CGSizeMake(22.f, 22.f) imageName:@"icon_Rectangle"];
    self.departmentView.contentLabel.text = @"电气组";
    [self.first_bg_view addSubview:self.departmentView];
    
    UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.departmentView.frame) - 1.f, 8, 1.f, 31.f)];
    lineTwo.backgroundColor = colorWithHexString(@"e2e6e8");
    [self.first_bg_view addSubview:lineTwo];
    
    self.jobView = [[BXTGrabUserConfigView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.departmentView.frame), 0, SCREEN_WIDTH/3.f, 47.f) imageSize:CGSizeMake(24.f, 24.f) imageName:@"icon_job"];
    self.jobView.contentLabel.text = @"维修员";
    [self.first_bg_view addSubview:self.jobView];
}

#pragma mark -
#pragma mark 事件
- (IBAction)grabOrder:(id)sender
{
    [self showLoadingMBP:@"抢单中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    NSInteger index = [BXTGlobal shareGlobal].numOfPresented - 1;
    NSString *orderID = [[BXTGlobal shareGlobal].newsOrderIDs objectAtIndex:index];
    [request reaciveOrderID:orderID];
}

- (void)navigationLeftButton
{
    if (self.orderID)
    {
        [[BXTGlobal shareGlobal].newsOrderIDs removeObject:self.orderID];
        --[BXTGlobal shareGlobal].numOfPresented;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairDetail && data.count != 0)
    {
        [player play];
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
        
        // 报修人信息
        BXTRepairPersonInfo *repairPerson = repairDetail.fault_user_arr[0];
        NSString *headURL = repairPerson.head_pic;
        [self.nameView.iconImgView sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        self.nameView.contentLabel.text = repairPerson.name;
        self.departmentView.contentLabel.text = repairPerson.department_name;
        self.jobView.contentLabel.text = repairPerson.duty_name;
        
        // 工单号
        self.orderNumberLabel.text = repairDetail.orderid;
        
        // 报单时间
        NSArray *timesArray = [repairDetail.fault_time_name componentsSeparatedByString:@" "];
        self.repairTimeLabel.text = timesArray[0];
        self.hoursTimeLabel.text = timesArray[1];
        
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
        self.repairContentLabel.text = repairDetail.cause;
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
            
            if (CGRectGetMinY(self.third_bg_view.frame) + CGRectGetMaxY(imageViewOne.frame) + 20.f < SCREEN_HEIGHT - KNAVIVIEWHEIGHT - GrabButtonHeight)
            {
                self.third_view_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - GrabButtonHeight - CGRectGetMinY(self.third_bg_view.frame);
            }
            else
            {
                self.third_view_height.constant = CGRectGetMaxY(imageViewOne.frame) + 20.f;
            }
        }
        else
        {
            if (CGRectGetMinY(self.third_bg_view.frame) + CGRectGetMaxY(self.lineView.frame) + 20.f < SCREEN_HEIGHT - KNAVIVIEWHEIGHT - GrabButtonHeight)
            {
                self.third_view_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - GrabButtonHeight - CGRectGetMinY(self.third_bg_view.frame);
            }
            else
            {
                self.third_view_height.constant = CGRectGetMaxY(self.lineView.frame) + 20.f;
            }
        }
        [self.third_bg_view layoutIfNeeded];

        if (CGRectGetMaxY(self.third_bg_view.frame) > SCREEN_HEIGHT - KNAVIVIEWHEIGHT - GrabButtonHeight)
        {
            self.content_height.constant = CGRectGetMaxY(self.third_bg_view.frame);
        }
        else
        {
            self.content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - GrabButtonHeight;
        }
        [self.contentView layoutIfNeeded];
    }
    else if (type == ReaciveOrder)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReaciveOrderSuccess" object:nil];
            [self showMBP:@"抢单成功！" withBlock:^(BOOL hidden) {
                [self navigationLeftButton];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"041"])
        {
            [self showMBP:@"工单已被抢！" withBlock:^(BOOL hidden) {
                [self navigationLeftButton];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"002"])
        {
            [self showMBP:@"抢单失败，工单已取消！" withBlock:^(BOOL hidden) {
                [self navigationLeftButton];
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
