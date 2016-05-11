//
//  BXTGrabOrderViewController.m
//  YFBX
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTGrabOrderViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTSelectBoxView.h"
#import "BXTDataRequest.h"
#import "BXTRepairDetailInfo.h"
#import "UIImageView+WebCache.h"

@interface BXTGrabOrderViewController ()<BXTDataResponseDelegate>
{
    AVAudioPlayer *player;
    CGFloat       width;
}

@property (nonatomic, strong) NSString    *orderID;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *repairID;
@property (nonatomic, strong) UILabel     *location;
@property (nonatomic, strong) UILabel     *faultType;
@property (nonatomic, strong) UILabel     *cause;
@property (nonatomic, strong) UILabel     *group;

@end

@implementation BXTGrabOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"实时抢单" andRightTitle:nil andRightImage:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    ++[BXTGlobal shareGlobal].numOfPresented;
    [self initialSubviews];
    
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

#pragma mark -
#pragma mark 初始化视图
- (void)initialSubviews
{
    CGFloat space = IS_IPHONE6 ? 15.f : 10.f;
    width = SCREEN_WIDTH - space * 2.f;
    CGFloat height = IS_IPHONE6 ? 263.f : 175;
    
    self.imageView = ({
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(space, KNAVIVIEWHEIGHT + space, width, height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        [self.view addSubview:imgView];
        imgView;
        
    });
    
    self.repairID = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.imageView.frame) + 15.f, CGRectGetWidth(self.imageView.frame), 20)];
        label.textColor = colorWithHexString(@"000000");
        label.font = [UIFont systemFontOfSize:17.f];
        [self.view addSubview:label];
        label;
        
    });
    
    self.location = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.repairID.frame) + 10.f, CGRectGetWidth(self.repairID.frame), 20)];
        label.textColor = colorWithHexString(@"000000");
        label.font = [UIFont systemFontOfSize:17.f];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view addSubview:label];
        label;
        
    });
    
    self.faultType = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.location.frame) + 10.f, CGRectGetWidth(self.location.frame), 20)];
        label.textColor = colorWithHexString(@"000000");
        label.font = [UIFont systemFontOfSize:17.f];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view addSubview:label];
        label;
        
    });
    
    self.cause = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.faultType.frame) + 10.f, CGRectGetWidth(self.faultType.frame), 20)];
        label.textColor = colorWithHexString(@"000000");
        label.font = [UIFont systemFontOfSize:17.f];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view addSubview:label];
        label;
        
    });
    
    CGFloat grab_buttonH = SCREEN_WIDTH/4.57;
    UIButton *grab_button = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-grab_buttonH, SCREEN_WIDTH, grab_buttonH)];
    [grab_button setBackgroundImage:[UIImage imageNamed:@"Grab_btn"] forState:UIControlStateNormal];
    [grab_button addTarget:self action:@selector(reaciveOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grab_button];
    
    self.group = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, grab_buttonH-28, SCREEN_WIDTH-40, 25)];
        label.textColor = colorWithHexString(@"ffffff");
        label.font = [UIFont systemFontOfSize:16.f];
        label.textAlignment = NSTextAlignmentCenter;
        [grab_button addSubview:label];
        label;
        
    });
    
}

#pragma mark -
#pragma mark 事件
- (void)reaciveOrder
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
    if (type == RepairDetail)
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
        
        NSArray *imgArray = repairDetail.fault_pic;
        UIImage *placeImage = [UIImage imageNamed:@"grabIphone"];
       
        if (imgArray.count > 0)
        {
            BXTFaultPicInfo *picInfo = imgArray[0];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:picInfo.photo_file] placeholderImage:placeImage];
        }
        else
        {
            [self.imageView setImage:placeImage];
        }
        
        self.repairID.text = [NSString stringWithFormat:@"工单号:%@",repairDetail.orderid];
        
        //位置
        NSString *place_str = [NSString stringWithFormat:@"位置:%@",repairDetail.place_name];
        CGSize place_size = MB_MULTILINE_TEXTSIZE(place_str, [UIFont systemFontOfSize:17.f], CGSizeMake(width, 100), NSLineBreakByWordWrapping);
        CGRect place_rect = self.location.frame;
        place_rect.size = place_size;
        self.location.frame = place_rect;
        self.location.text = place_str;
        
        //故障类型
        NSString *fault_str = [NSString stringWithFormat:@"故障类型:%@",repairDetail.faulttype_name];
        CGSize fault_size = MB_MULTILINE_TEXTSIZE(fault_str, [UIFont systemFontOfSize:17.f], CGSizeMake(width, 100), NSLineBreakByWordWrapping);
        CGRect fault_rect = self.faultType.frame;
        fault_rect.size = fault_size;
        self.faultType.frame = fault_rect;
        self.faultType.text = fault_str;
        
        //故障描述
        NSString *cause_str = [NSString stringWithFormat:@"报修内容:%@",repairDetail.cause];
        CGSize cause_size = MB_MULTILINE_TEXTSIZE(cause_str, [UIFont systemFontOfSize:17.f], CGSizeMake(width, 100), NSLineBreakByWordWrapping);
        CGRect cause_rect = self.cause.frame;
        cause_rect.size = cause_size;
        self.cause.frame = cause_rect;
        self.cause.text = cause_str;
        
        self.group.text = [NSString stringWithFormat:@"%@", repairDetail.faulttype_name];
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
