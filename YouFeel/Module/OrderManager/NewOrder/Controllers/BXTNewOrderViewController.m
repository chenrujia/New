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
#import "BXTAssignOrderViewModel.h"

#define DispatchBackViewHeight 70.f
#define BottomButtonHeight 50.f
#define FaultImageWidth (SCREEN_WIDTH - 15.f - 15.f - 20.f - 20.f)/3.f

@interface BXTNewOrderViewController ()

@property (nonatomic, strong) BXTAssignOrderViewModel *assignViewModel;

@end

@implementation BXTNewOrderViewController

- (BXTAssignOrderViewModel *)assignViewModel
{
    if (_assignViewModel == nil)
    {
        _assignViewModel = [[BXTAssignOrderViewModel alloc] init];
    }
    
    return _assignViewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"新工单指派" andRightTitle:@"" andRightImage:nil];
    [self bindingViewModel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.assignViewModel.player)
    {
        [self.assignViewModel.player stop];
    }
}

- (void)bindingViewModel
{
    @weakify(self);
    [[self.assignViewModel.detailRequestCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        // 指派人信息
        BXTMaintenanceManInfo *dispathPerson = self.assignViewModel.orderDetail.dispatch_ower_arr[0];
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
        [self.repairHeadImgView sd_setImageWithURL:[NSURL URLWithString:self.assignViewModel.r_p_headURL]];
        self.repairNameLabel.text = self.assignViewModel.r_p_name;
        self.departmentNameLabel.text = self.assignViewModel.r_p_departmantName;
        self.job_name_width.constant = self.assignViewModel.r_p_job_width;
        [self.jobNameLabel layoutIfNeeded];
        self.jobNameLabel.text = self.assignViewModel.r_p_jobName;
        // 工单号
        self.orderNumberLabel.text = self.assignViewModel.orderDetail.orderid;
        // 是否预约
        self.appointmentImgView.hidden = self.assignViewModel.appointmentHidden;
        // 报单时间
        if (self.assignViewModel.appointmentHidden)
        {
            self.time_right.constant = 20.f;
            [self.repairTimeLabel layoutIfNeeded];
        }
        self.repairTimeLabel.attributedText = self.assignViewModel.r_p_time;
        self.urgentImgView.hidden = [self.assignViewModel.orderDetail.timeout_state integerValue] == 5 ? NO : YES;
        // 位置
        self.placeLabel.text = self.assignViewModel.orderDetail.place_name;
        [self.view layoutIfNeeded];
        self.second_view_height.constant = CGRectGetMaxY(self.placeLabel.frame) + 15.f;
        [self.second_bg_view layoutIfNeeded];
        // 故障类型
        self.faultTypeLabel.text = self.assignViewModel.orderDetail.faulttype_name;
        // 故障描述
        self.repairContent.text = self.assignViewModel.orderDetail.cause;
        [self.view layoutIfNeeded];
        // 故障图片
        NSArray *imgArray = self.assignViewModel.orderDetail.fault_pic;
        if (imgArray.count)
        {
            UIImageView *imageViewOne = nil;
            if (imgArray.count == 1)
            {
                BXTFaultPicInfo *faultPic = self.assignViewModel.orderDetail.fault_pic[0];
                
                imageViewOne = [self initalImageView:CGPointMake(15.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPic imageViewTag:0];
                [self.third_bg_view addSubview:imageViewOne];
            }
            else if (imgArray.count == 2)
            {
                BXTFaultPicInfo *faultPicOne = self.assignViewModel.orderDetail.fault_pic[0];
                BXTFaultPicInfo *faultPicTwo = self.assignViewModel.orderDetail.fault_pic[1];
                
                imageViewOne = [self initalImageView:CGPointMake(15.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicOne imageViewTag:0];
                [self.third_bg_view addSubview:imageViewOne];
                
                UIImageView *imageViewTwo = [self initalImageView:CGPointMake(CGRectGetMaxX(imageViewOne.frame) + 20.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicTwo imageViewTag:1];
                [self.third_bg_view addSubview:imageViewTwo];
            }
            else
            {
                BXTFaultPicInfo *faultPicOne = self.assignViewModel.orderDetail.fault_pic[0];
                BXTFaultPicInfo *faultPicTwo = self.assignViewModel.orderDetail.fault_pic[1];
                BXTFaultPicInfo *faultPicThree = self.assignViewModel.orderDetail.fault_pic[2];
                
                imageViewOne = [self initalImageView:CGPointMake(15.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicOne imageViewTag:0];
                [self.third_bg_view addSubview:imageViewOne];
                
                UIImageView *imageViewTwo = [self initalImageView:CGPointMake(CGRectGetMaxX(imageViewOne.frame) + 20.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicTwo imageViewTag:1];
                [self.third_bg_view addSubview:imageViewTwo];
                
                UIImageView *imageViewThree = [self initalImageView:CGPointMake(CGRectGetMaxX(imageViewTwo.frame) + 20.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicThree imageViewTag:2];
                [self.third_bg_view addSubview:imageViewThree];
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
        [self.view layoutIfNeeded];
        
        if (CGRectGetMaxY(self.third_bg_view.frame) > SCREEN_HEIGHT - KNAVIVIEWHEIGHT - DispatchBackViewHeight - BottomButtonHeight)
        {
            self.content_height.constant = CGRectGetMaxY(self.third_bg_view.frame);
        }
        else
        {
            self.content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - DispatchBackViewHeight - BottomButtonHeight;
        }
        [self.contentView layoutIfNeeded];
    }];
}

- (IBAction)rejectOrder:(id)sender
{
    [self.assignViewModel.rejectOrderCommand execute:self.navigationController];
}

- (IBAction)reaciveOrder:(id)sender
{
    @weakify(self);
    [[self.assignViewModel.acceptOrderCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *dic = x;
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReaciveOrderSuccess" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadListData" object:nil];
            [BXTGlobal showText:@"接单成功！" view:window completionBlock:^{
                [self navigationLeftButton];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"041"])
        {
            [BXTGlobal showText:@"工单已被抢！" view:window completionBlock:^{
                [self navigationLeftButton];
            }];
        }
        else
        {
            [BXTGlobal showText:@"抢单失败，工单已取消！" view:window completionBlock:^{
                [self navigationLeftButton];
            }];
        }
    }];
}

- (UIImageView *)initalImageView:(CGPoint)point faultPicInfo:(BXTFaultPicInfo *)picInfo imageViewTag:(NSInteger)tag
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, FaultImageWidth, FaultImageWidth)];
    imageView.tag = tag;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:picInfo.photo_thumb_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    [self addTapToImageView:imageView];
    
    return imageView;
}

- (void)addTapToImageView:(UIImageView *)imageView
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    [imageView addGestureRecognizer:tapGR];
    @weakify(self);
    [[tapGR rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        self.mwPhotosArray = [self containAllPhotos:self.assignViewModel.orderDetail.fault_pic];
        [self loadMWPhotoBrowser:imageView.tag];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
