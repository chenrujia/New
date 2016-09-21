//
//  BXTGrabOrderViewController.m
//  YFBX
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTGrabOrderViewController.h"
#import "BXTHeaderForVC.h"
#import "UIImageView+WebCache.h"
#import "BXTGrabOrderViewModel.h"

#define GrabButtonHeight 98.f
#define FaultImageWidth (SCREEN_WIDTH - 15.f - 15.f - 20.f - 20.f)/3.f

@interface BXTGrabOrderViewController ()

@property (nonatomic, strong) BXTGrabOrderViewModel *grabOrderViewModel;

@end

@implementation BXTGrabOrderViewController

- (BXTGrabOrderViewModel *)grabOrderViewModel
{
    if (_grabOrderViewModel == nil)
    {
        _grabOrderViewModel = [[BXTGrabOrderViewModel alloc] init];
    }
    
    return _grabOrderViewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"实时抢单" andRightTitle:nil andRightImage:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self bindingViewModel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.grabOrderViewModel.player)
    {
        [self.grabOrderViewModel.player stop];
    }
}

- (void)bindingViewModel
{
    @weakify(self);
    [[self.grabOrderViewModel.detailRequestCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        // 报修人信息
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.grabOrderViewModel.r_p_headURL]];
        self.repairName.text = self.grabOrderViewModel.r_p_name;
        self.departmantName.text = self.grabOrderViewModel.r_p_departmantName;
        self.job_width.constant = self.grabOrderViewModel.r_p_job_width;
        [self.jobName layoutIfNeeded];
        self.jobName.text = self.grabOrderViewModel.r_p_jobName;
        // 工单号
        self.orderNumberLabel.text = self.grabOrderViewModel.orderDetail.orderid;
        // 是否预约
        self.appointmentImgView.hidden = self.grabOrderViewModel.appointmentHidden;
        // 报单时间
        if (self.grabOrderViewModel.appointmentHidden)
        {
            self.time_right.constant = 20.f;
            [self.repairTimeLabel layoutIfNeeded];
        }
        self.repairTimeLabel.attributedText = self.grabOrderViewModel.r_p_time;
        self.urgentImgView.hidden = [self.grabOrderViewModel.orderDetail.timeout_state integerValue] == 5 ? NO : YES;
        // 位置
        self.placeLabel.text = self.grabOrderViewModel.orderDetail.place_name;
        [self.view layoutIfNeeded];
        self.second_view_height.constant = CGRectGetMaxY(self.placeLabel.frame) + 15.f;
        [self.second_bg_view layoutIfNeeded];
        // 故障类型
        self.faultTypeLabel.text = self.grabOrderViewModel.orderDetail.faulttype_name;
        // 故障描述
        self.repairContentLabel.text = self.grabOrderViewModel.orderDetail.cause;
        [self.view layoutIfNeeded];
        // 故障图片
        NSArray *imgArray = self.grabOrderViewModel.orderDetail.fault_pic;
        if (imgArray.count)
        {
            UIImageView *imageViewOne = nil;
            if (imgArray.count == 1)
            {
                BXTFaultPicInfo *faultPic = self.grabOrderViewModel.orderDetail.fault_pic[0];
                
                imageViewOne = [self initalImageView:CGPointMake(15.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPic imageViewTag:0];
                [self.third_bg_view addSubview:imageViewOne];
            }
            else if (imgArray.count == 2)
            {
                BXTFaultPicInfo *faultPicOne = self.grabOrderViewModel.orderDetail.fault_pic[0];
                BXTFaultPicInfo *faultPicTwo = self.grabOrderViewModel.orderDetail.fault_pic[1];
                
                imageViewOne = [self initalImageView:CGPointMake(15.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicOne imageViewTag:0];
                [self.third_bg_view addSubview:imageViewOne];
                
                UIImageView *imageViewTwo = [self initalImageView:CGPointMake(CGRectGetMaxX(imageViewOne.frame) + 20.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicTwo imageViewTag:1];
                [self.third_bg_view addSubview:imageViewTwo];
            }
            else
            {
                BXTFaultPicInfo *faultPicOne = self.grabOrderViewModel.orderDetail.fault_pic[0];
                BXTFaultPicInfo *faultPicTwo = self.grabOrderViewModel.orderDetail.fault_pic[1];
                BXTFaultPicInfo *faultPicThree = self.grabOrderViewModel.orderDetail.fault_pic[2];
                
                imageViewOne = [self initalImageView:CGPointMake(15.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicOne imageViewTag:0];
                [self.third_bg_view addSubview:imageViewOne];
                
                UIImageView *imageViewTwo = [self initalImageView:CGPointMake(CGRectGetMaxX(imageViewOne.frame) + 20.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicTwo imageViewTag:1];
                [self.third_bg_view addSubview:imageViewTwo];
                
                UIImageView *imageViewThree = [self initalImageView:CGPointMake(CGRectGetMaxX(imageViewTwo.frame) + 20.f, CGRectGetMaxY(self.lineView.frame) + 15.f) faultPicInfo:faultPicThree imageViewTag:2];
                [self.third_bg_view addSubview:imageViewThree];
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
        [self.view layoutIfNeeded];
        
        if (CGRectGetMaxY(self.third_bg_view.frame) > SCREEN_HEIGHT - KNAVIVIEWHEIGHT - GrabButtonHeight)
        {
            self.content_height.constant = CGRectGetMaxY(self.third_bg_view.frame);
        }
        else
        {
            self.content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT - GrabButtonHeight;
        }
        [self.contentView layoutIfNeeded];
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
        self.mwPhotosArray = [self containAllPhotos:self.grabOrderViewModel.orderDetail.fault_pic];
        [self loadMWPhotoBrowser:imageView.tag];
    }];
}

#pragma mark -
#pragma mark 抢单
- (IBAction)grabOrder:(id)sender
{
    @weakify(self);
    [[self.grabOrderViewModel.grabOrderCommand execute:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *dic = x;
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReaciveOrderSuccess" object:nil];
            [BXTGlobal showText:@"抢单成功！" view:window completionBlock:^{
                [self navigationLeftButton];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"041"])
        {
            [BXTGlobal showText:@"工单已被抢！" view:window completionBlock:^{
                [self navigationLeftButton];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"002"])
        {
            [BXTGlobal showText:@"抢单失败，工单已取消！" view:window completionBlock:^{
                [self navigationLeftButton];
            }];
        }
    }];
}

- (void)navigationLeftButton
{
    [[BXTGlobal shareGlobal].newsOrderIDs removeObject:self.grabOrderViewModel.orderID];
    --[BXTGlobal shareGlobal].numOfPresented;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
