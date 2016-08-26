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

#define ImageWidth 73.3f
#define ImageHeight 73.3f

@interface BXTNewOrderViewController ()<BXTDataResponseDelegate>
{
    AVAudioPlayer       *player;
}

@property (nonatomic, strong) UIImageView    *headImgView;
@property (nonatomic, strong) UILabel        *repairerName;
@property (nonatomic, strong) UILabel        *detailName;
@property (nonatomic, strong) UILabel        *identifyName;
@property (nonatomic, strong) UILabel        *orderType;
@property (nonatomic, strong) UILabel        *repairID;
@property (nonatomic, strong) UILabel        *timeLabel;
@property (nonatomic, strong) UILabel        *placeLabel;
@property (nonatomic, strong) UILabel        *faultType;
@property (nonatomic, strong) UILabel        *cause;
@property (nonatomic ,strong) NSString       *currentOrderID;
@property (nonatomic ,strong) NSMutableArray *manIDArray;
@property (nonatomic, assign) BOOL           isVoice;

@end

@implementation BXTNewOrderViewController

- (instancetype)initWithIsVoice:(BOOL)isVoice
{
    self = [super init];
    if (self)
    {
        self.isVoice = isVoice;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"新工单" andRightTitle:@"" andRightImage:nil];

    self.manIDArray = [NSMutableArray array];
    if (self.isVoice)
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"]] error:nil];
        player.volume = 0.8f;
        player.numberOfLoops = -1;
        [self afterTime];
    }
    [self createSubviews];
    
    /**获取详情**/
    [self showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    ++[BXTGlobal shareGlobal].assignNumber;
    NSInteger index = [BXTGlobal shareGlobal].assignNumber;
    self.currentOrderID = [[BXTGlobal shareGlobal].assignOrderIDs objectAtIndex:index - 1];
    [request repairDetail:[NSString stringWithFormat:@"%@",self.currentOrderID]];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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
#pragma mark 初始化视图
- (void)createSubviews
{
    //头像
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, KNAVIVIEWHEIGHT + 12.f, ImageWidth, ImageHeight)];
    self.headImgView.image = [UIImage imageNamed:@"polaroid"];
    [self.view addSubview:self.headImgView];
    
    //报修人姓名
    self.repairerName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 10.f, CGRectGetMinY(self.headImgView.frame) + 5.f, 160.f, 20)];
    self.repairerName.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:self.repairerName];
    
    //维修员分组
    self.detailName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.repairerName.frame), CGRectGetMinY(self.headImgView.frame) + 28.f, 160.f, 20)];
    self.detailName.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.detailName];
    
    //身份
    self.identifyName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.detailName.frame), CGRectGetMinY(self.headImgView.frame) + 50.f, 160.f, 20)];
    self.identifyName.font = [UIFont systemFontOfSize:15.f];
    self.identifyName.userInteractionEnabled = YES;
    [self.view addSubview:self.identifyName];
    
    UIButton *connetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connetBtn.frame = CGRectMake(SCREEN_WIDTH - 83.3f - 15.f, KNAVIVIEWHEIGHT + 30.f, 83.3f, 40.f);
    [connetBtn setTitle:@"联系Ta" forState:UIControlStateNormal];
    connetBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [connetBtn setTitleColor:colorWithHexString(@"3bafff") forState:UIControlStateNormal];
    connetBtn.layer.borderColor = colorWithHexString(@"3bafff").CGColor;
    connetBtn.layer.borderWidth = 1.f;
    connetBtn.layer.cornerRadius = 4.f;
    [connetBtn addTarget:self action:@selector(connectTa) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connetBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.headImgView.frame) + 12.f, SCREEN_WIDTH - 30.f, 1.f)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [self.view addSubview:line];
    
    //工单编号
    self.repairID = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(line.frame) + 15.f, SCREEN_WIDTH - 30.f, 20)];
    self.repairID.textColor = colorWithHexString(@"000000");
    self.repairID.font = [UIFont systemFontOfSize:17.f];
    self.repairID.text = @"工单号:";
    [self.view addSubview:self.repairID];
    
    //工单所属部门
    self.orderType = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50.f - 15.f, CGRectGetMaxY(line.frame) + 12.f, 40.f, 20.f)];
    self.orderType.textColor = colorWithHexString(@"ffffff");
    self.orderType.backgroundColor = colorWithHexString(@"AFB3BB");
    self.orderType.layer.cornerRadius = 2.f;
    self.orderType.layer.masksToBounds = YES;
    self.orderType.font = [UIFont systemFontOfSize:16.f];
    self.orderType.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.orderType];
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.repairID.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    self.timeLabel.textColor = colorWithHexString(@"000000");
    self.timeLabel.font = [UIFont systemFontOfSize:17.f];
    self.timeLabel.text = @"报修时间:";
    [self.view addSubview:self.timeLabel];
    
    //报修位置
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.timeLabel.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    self.placeLabel.textColor = colorWithHexString(@"000000");
    self.placeLabel.font = [UIFont systemFontOfSize:17.f];
    self.placeLabel.text = @"位置:";
    self.placeLabel.numberOfLines = 0;
    self.placeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.placeLabel];
    
    //故障类型
    self.faultType = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.placeLabel.frame) + 10.f, CGRectGetWidth(self.faultType.frame), 20)];
    self.faultType.textColor = colorWithHexString(@"000000");
    self.faultType.font = [UIFont systemFontOfSize:17.f];
    self.faultType.text = @"故障类型:";
    self.faultType.numberOfLines = 0;
    self.faultType.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.faultType];
    
    //报修内容
    self.cause = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(self.faultType.frame) + 10.f, CGRectGetWidth(self.faultType.frame), 20)];
    self.cause.textColor = colorWithHexString(@"000000");
    self.cause.font = [UIFont systemFontOfSize:17.f];
    self.cause.text = @"故障描述:";
    self.cause.numberOfLines = 0;
    self.cause.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.cause];
    
    CGFloat bv_height = IS_IPHONE6 ? 80.f : 70.f;
    CGFloat grab_height = IS_IPHONE6 ? 50.f : 40.f;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bv_height, SCREEN_WIDTH, bv_height)];
    backView.backgroundColor = colorWithHexString(@"ffffff");
    
    UIButton *rejectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rejectBtn setFrame:CGRectMake(20.f, 15.f, (SCREEN_WIDTH - 60.f)/2.f, grab_height)];
    [rejectBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
    [rejectBtn setBackgroundColor:colorWithHexString(@"ffffff")];
    rejectBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    rejectBtn.layer.borderWidth = 1.f;
    rejectBtn.layer.cornerRadius = 4.f;
    [rejectBtn setTitle:@"我不接" forState:UIControlStateNormal];
    @weakify(self);
    [[rejectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:self.currentOrderID viewControllerType:AssignVCType];
        [self.navigationController pushViewController:rejectVC animated:YES];
    }];
    [backView addSubview:rejectBtn];
    
    UIButton *grabOrderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [grabOrderBtn setFrame:CGRectMake(CGRectGetMaxX(rejectBtn.frame) + 20.f, 15.f, (SCREEN_WIDTH - 60.f)/2.f, grab_height)];
    [grabOrderBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    [grabOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [grabOrderBtn setTitle:@"我要接" forState:UIControlStateNormal];
    grabOrderBtn.layer.cornerRadius = 4.f;
    [[grabOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request reaciveDispatchedOrderID:self.repairDetail.orderID];
    }];
    [backView addSubview:grabOrderBtn];
    
    [self.view addSubview:backView];
}

#pragma mark -
#pragma mark 事件
- (void)connectTa
{
    BXTRepairPersonInfo *repairPerson = self.repairDetail.fault_user_arr[0];
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = repairPerson.out_userid;
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID]) return;
    
    userInfo.name = repairPerson.name;
    userInfo.portraitUri = repairPerson.head_pic;
    
    NSMutableArray *usersArray = [BXTGlobal getUserProperty:U_USERSARRAY];
    if (usersArray)
    {
        NSArray *arrResult = [usersArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.userId = %@",userInfo.userId]];
        if (arrResult.count)
        {
            RCUserInfo *temp_userInfo = arrResult[0];
            NSInteger index = [usersArray indexOfObject:temp_userInfo];
            [usersArray replaceObjectAtIndex:index withObject:temp_userInfo];
        }
        else
        {
            [usersArray addObject:userInfo];
        }
    }
    else
    {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:userInfo];
        [BXTGlobal setUserProperty:array withKey:U_USERSARRAY];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveConnact" object:nil];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:NO];
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = userInfo.userId;
    conversationVC.title = userInfo.name;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:conversationVC animated:YES];
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

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
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
        [BXTFaultPicInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"picID":@"id"};
        }];
        self.repairDetail = [BXTRepairDetailInfo mj_objectWithKeyValues:dictionary];
        
        BXTRepairPersonInfo *repairPerson = self.repairDetail.fault_user_arr[0];
        NSString *headURL = repairPerson.head_pic;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        self.repairerName.text = repairPerson.name;
        self.detailName.text = repairPerson.department_name;
        self.identifyName.text = repairPerson.duty_name;
        self.repairID.text = [NSString stringWithFormat:@"工单号:%@",self.repairDetail.orderid];
        self.timeLabel.text = [NSString stringWithFormat:@"报修时间:%@",self.repairDetail.fault_time_name];
       
        self.orderType.text = [self.repairDetail.task_type intValue] == 1 ? @"日常" : @"维保";
        self.orderType.backgroundColor = [self.repairDetail.task_type intValue] == 1 ? colorWithHexString(@"#F0B660") : colorWithHexString(@"#7EC86E");
        
        //根据位置的长度动态调整placeLabel的高度
        NSString *place_str = [NSString stringWithFormat:@"位置:%@",self.repairDetail.place_name];
        CGSize place_size = MB_MULTILINE_TEXTSIZE(place_str, [UIFont systemFontOfSize:17.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
        self.placeLabel.frame = CGRectMake(15.f, CGRectGetMaxY(self.timeLabel.frame) + 10.f, SCREEN_WIDTH - 30.f, place_size.height);
        self.placeLabel.text = place_str;

        //根据故障类型的长度动态调整faultType的高度
        NSString *faultType_str = [NSString stringWithFormat:@"故障类型:%@",self.repairDetail.faulttype_name];
        CGSize faultType_size = MB_MULTILINE_TEXTSIZE(faultType_str, [UIFont systemFontOfSize:17.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
        self.faultType.frame = CGRectMake(15.f, CGRectGetMaxY(self.placeLabel.frame) + 10.f, CGRectGetWidth(self.placeLabel.frame), faultType_size.height);
        self.faultType.text = faultType_str;
        
        //根据报修内容的长度动态调整cause的高度
        NSString *cause_str = [NSString stringWithFormat:@"报修内容:%@",self.repairDetail.cause];
        CGSize cause_size = MB_MULTILINE_TEXTSIZE(cause_str, [UIFont systemFontOfSize:17.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
        self.cause.frame = CGRectMake(15.f, CGRectGetMaxY(self.faultType.frame) + 10.f, CGRectGetWidth(self.faultType.frame), cause_size.height);
        self.cause.text = cause_str;
        
        NSArray *imgArray = [self containAllArray];
        if (imgArray.count > 0)
        {
            NSInteger i = 0;
            UIScrollView *imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cause.frame) + 20.f, SCREEN_WIDTH, ImageHeight)];
            imagesScrollView.contentSize = CGSizeMake((ImageWidth + 25) * imgArray.count + 25.f, ImageHeight);
            [imagesScrollView setShowsHorizontalScrollIndicator:NO];
            for (BXTFaultPicInfo *picInfo in imgArray)
            {
                if (picInfo.photo_file)
                {
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25.f * (i + 1) + ImageWidth * i, 0, ImageWidth, ImageHeight)];
                    imgView.userInteractionEnabled = YES;
                    imgView.layer.masksToBounds = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    [imgView sd_setImageWithURL:[NSURL URLWithString:picInfo.photo_file]];
                    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
                    @weakify(self);
                    [[tapGR rac_gestureSignal] subscribeNext:^(id x) {
                        @strongify(self);
                        self.mwPhotosArray = [self containAllPhotosForMWPhotoBrowser];
                        [self loadMWPhotoBrowserForDetail:i withFaultPicCount:self.repairDetail.fault_pic.count withFixedPicCount:self.repairDetail.fixed_pic.count withEvaluationPicCount:self.repairDetail.evaluation_pic.count];
                    }];
                    [imgView addGestureRecognizer:tapGR];
                    [imagesScrollView addSubview:imgView];
                    i++;
                }
            }
            [self.view addSubview:imagesScrollView];
        }
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
