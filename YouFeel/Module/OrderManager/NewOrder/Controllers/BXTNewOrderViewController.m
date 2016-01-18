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
#import "BXTSelectBoxView.h"
#import "BXTAddOtherManViewController.h"
#import "BXTRejectOrderViewController.h"

#define ImageWidth 73.3f
#define ImageHeight 73.3f

@interface BXTNewOrderViewController ()<BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate>
{
    UIImageView         *headImgView;
    UILabel             *repairerName;
    UILabel             *repairerDetail;
    UILabel             *repairID;
    UILabel             *groupName;
    UILabel             *orderType;
    UILabel             *time;
    UILabel             *mobile;
    UIView              *lineThree;
    UILabel             *place;
    UILabel             *faultType;
    UILabel             *cause;
    UILabel             *level;
    UILabel             *notes;
    NSArray             *comeTimeArray;
    BXTSelectBoxView    *boxView;
    NSDate              *originDate;
    BOOL                isAssign;//判断是派工界面还是新工单界面
    AVAudioPlayer       *player;
}

@property (nonatomic ,strong) BXTRepairDetailInfo *repairDetail;
@property (nonatomic ,strong) NSString            *currentOrderID;
@property (nonatomic ,strong) NSMutableArray      *manIDArray;
@property (nonatomic ,assign) NSTimeInterval      timeInterval2;
@property (nonatomic ,strong) UIDatePicker        *datePicker;
@property (nonatomic ,strong) UIView              *bgView;

@end

@implementation BXTNewOrderViewController

- (void)dealloc
{
    LogBlue(@"工单详情被释放了。。。。。。");
}

- (instancetype)initWithIsAssign:(BOOL)assign
                  andWithOrderID:(NSString *)orderID
{
    self = [super init];
    if (self)
    {
        isAssign = assign;
        self.currentOrderID = orderID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"新工单" andRightTitle:nil andRightImage:nil];
    self.manIDArray = [NSMutableArray array];
    
    if (!isAssign)
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"]] error:nil];
        player.volume = 0.8f;
        player.numberOfLoops = -1;
        [self afterTime];
    }
    
    [self createSubviews];
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"])
    {
        [timeArray addObject:[NSString stringWithFormat:@"%@分钟内", timeStr]];
    }
    [timeArray addObject:@"自定义"];
    comeTimeArray = timeArray;
    
    /**获取详情**/
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    if (!isAssign)
    {
        ++[BXTGlobal shareGlobal].assignNumber;
        NSInteger index = [BXTGlobal shareGlobal].assignNumber;
        self.currentOrderID = [[BXTGlobal shareGlobal].assignOrderIDs objectAtIndex:index - 1];
    }
    [request repairDetail:[NSString stringWithFormat:@"%@",_currentOrderID]];
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
    headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, KNAVIVIEWHEIGHT + 12.f, ImageWidth, ImageHeight)];
    headImgView.image = [UIImage imageNamed:@"polaroid"];
    [self.view addSubview:headImgView];
    
    repairerName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImgView.frame) + 10.f, CGRectGetMinY(headImgView.frame) + 5.f, 160.f, 20)];
    repairerName.textColor = colorWithHexString(@"000000");
    repairerName.font = [UIFont boldSystemFontOfSize:16.f];
    [self.view addSubview:repairerName];
    
    repairerDetail = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(repairerName.frame), CGRectGetMinY(headImgView.frame) + 28.f, 160.f, 20)];
    repairerDetail.textColor = colorWithHexString(@"909497");
    repairerDetail.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:repairerDetail];
    
    mobile = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(repairerDetail.frame), CGRectGetMinY(headImgView.frame) + 50.f, 160.f, 20)];
    mobile.textColor = colorWithHexString(@"000000");
    mobile.font = [UIFont systemFontOfSize:15.f];
    mobile.userInteractionEnabled = YES;
    [self.view addSubview:mobile];
    UITapGestureRecognizer *moblieTap = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [[moblieTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.repairDetail.visitmobile];
        UIWebView *callWeb = [[UIWebView alloc] init];
        [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
        [self.view addSubview:callWeb];
    }];
    [mobile addGestureRecognizer:moblieTap];
    
    UIButton *connetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connetBtn.frame = CGRectMake(SCREEN_WIDTH - 83.3f - 15.f, KNAVIVIEWHEIGHT + 30.f, 83.3f, 40.f);
    [connetBtn setTitle:@"联系Ta" forState:UIControlStateNormal];
    [connetBtn setTitleColor:colorWithHexString(@"3bafff") forState:UIControlStateNormal];
    connetBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
    connetBtn.layer.borderWidth = 1.f;
    connetBtn.layer.cornerRadius = 4.f;
    [connetBtn addTarget:self action:@selector(connectTa) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connetBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(headImgView.frame) + 12.f, SCREEN_WIDTH - 30.f, 1.f)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [self.view addSubview:line];
    
    repairID = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(line.frame) + 15.f, SCREEN_WIDTH - 30.f, 20)];
    repairID.textColor = colorWithHexString(@"000000");
    repairID.font = [UIFont boldSystemFontOfSize:17.f];
    repairID.text = @"工单号:";
    [self.view addSubview:repairID];
    
    groupName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50.f - 15.f, CGRectGetMaxY(line.frame) + 12.f, 50.f, 26.3f)];
    groupName.textColor = colorWithHexString(@"00a2ff");
    groupName.layer.borderColor = colorWithHexString(@"00a2ff").CGColor;
    groupName.layer.borderWidth = 1.f;
    groupName.layer.cornerRadius = 4.f;
    groupName.font = [UIFont systemFontOfSize:16.f];
    groupName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:groupName];
    
    UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(repairID.frame) + 12.f, SCREEN_WIDTH - 30.f, 1.f)];
    lineTwo.backgroundColor = colorWithHexString(@"e2e6e8");
    [self.view addSubview:lineTwo];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineTwo.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    time.textColor = colorWithHexString(@"000000");
    time.font = [UIFont boldSystemFontOfSize:17.f];
    time.text = @"报修时间:";
    [self.view addSubview:time];
    
    orderType = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80.f - 15.f, CGRectGetMaxY(lineTwo.frame) + 10.f, 80.f, 20)];
    orderType.textColor = colorWithHexString(@"cc0202");
    orderType.textAlignment = NSTextAlignmentRight;
    orderType.font = [UIFont boldSystemFontOfSize:16.f];
    [self.view addSubview:orderType];
    
    lineThree = [[UIView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(time.frame) + 12.f, SCREEN_WIDTH - 30.f, 1.f)];
    lineThree.backgroundColor = colorWithHexString(@"e2e6e8");
    [self.view addSubview:lineThree];
    
    place = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineThree.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    place.textColor = colorWithHexString(@"000000");
    place.font = [UIFont boldSystemFontOfSize:17.f];
    place.text = @"位置:";
    place.numberOfLines = 0;
    [self.view addSubview:place];
    
    faultType = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(place.frame) + 10.f, CGRectGetWidth(place.frame), 20)];
    faultType.textColor = colorWithHexString(@"000000");
    faultType.font = [UIFont boldSystemFontOfSize:17.f];
    faultType.text = @"故障类型:";
    [self.view addSubview:faultType];
    
    cause = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(faultType.frame) + 10.f, CGRectGetWidth(faultType.frame), 20)];
    cause.textColor = colorWithHexString(@"000000");
    cause.font = [UIFont boldSystemFontOfSize:17.f];
    cause.text = @"故障描述:";
    [self.view addSubview:cause];
    
    level = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(cause.frame) + 10.f, CGRectGetWidth(cause.frame), 20)];
    level.textColor = colorWithHexString(@"000000");
    level.font = [UIFont boldSystemFontOfSize:17.f];
    NSString *str = @"等级:紧急";
    NSRange range = [str rangeOfString:@"紧急"];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
    level.attributedText = attributeStr;
    [self.view addSubview:level];
    
    notes = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(level.frame) + 8.f, CGRectGetWidth(level.frame), 20)];
    notes.textColor = colorWithHexString(@"000000");
    notes.numberOfLines = 0;
    notes.lineBreakMode = NSLineBreakByWordWrapping;
    notes.font = [UIFont boldSystemFontOfSize:17.f];
    [self.view addSubview:notes];
    
    CGFloat bv_height = IS_IPHONE6 ? 80.f : 70.f;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bv_height, SCREEN_WIDTH, bv_height)];
    if (isAssign)
    {
        backView.backgroundColor = colorWithHexString(@"eff3f6");
        
        if ([BXTGlobal shareGlobal].isRepair)
        {
            CGFloat grab_height = IS_IPHONE6 ? 50.f : 40.f;
            UIButton *reaciveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [reaciveBtn setFrame:CGRectMake(20.f, 15.f, (SCREEN_WIDTH - 60.f)/2.f, grab_height)];
            [reaciveBtn setBackgroundColor:colorWithHexString(@"3cafff")];
            [reaciveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [reaciveBtn setTitle:@"我来修" forState:UIControlStateNormal];
            reaciveBtn.layer.cornerRadius = 4.f;
            [reaciveBtn addTarget:self action:@selector(grabBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:reaciveBtn];
            
            UIButton *assignBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [assignBtn setFrame:CGRectMake(CGRectGetMaxX(reaciveBtn.frame) + 20.f, 15.f, (SCREEN_WIDTH - 60.f)/2.f, grab_height)];
            [assignBtn setBackgroundColor:colorWithHexString(@"ffffff")];
            [assignBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            [assignBtn setTitle:@"指派" forState:UIControlStateNormal];
            assignBtn.layer.cornerRadius = 4.f;
            [assignBtn addTarget:self action:@selector(assignBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:assignBtn];
        }
        else
        {
            CGFloat grab_height = IS_IPHONE6 ? 50.f : 40.f;
            UIButton *assignBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [assignBtn setFrame:CGRectMake(20.f, 15.f, SCREEN_WIDTH - 40.f, grab_height)];
            [assignBtn setBackgroundColor:colorWithHexString(@"ffffff")];
            [assignBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            [assignBtn setTitle:@"指派" forState:UIControlStateNormal];
            assignBtn.layer.cornerRadius = 4.f;
            [assignBtn addTarget:self action:@selector(assignBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:assignBtn];
        }
    }
    else
    {
        backView.backgroundColor = colorWithHexString(@"febc2d");
        
        CGFloat grab_height = IS_IPHONE6 ? 50.f : 40.f;
        UIButton *grabOrderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [grabOrderBtn setFrame:CGRectMake(20.f, 15.f, (SCREEN_WIDTH - 60.f)/2.f, grab_height)];
        [grabOrderBtn setBackgroundColor:colorWithHexString(@"f0640f")];
        [grabOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [grabOrderBtn setTitle:@"我要接" forState:UIControlStateNormal];
        grabOrderBtn.layer.cornerRadius = 4.f;
        [grabOrderBtn addTarget:self action:@selector(grabBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:grabOrderBtn];
        
        UIButton *rejectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [rejectBtn setFrame:CGRectMake(CGRectGetMaxX(grabOrderBtn.frame) + 20.f, 15.f, (SCREEN_WIDTH - 60.f)/2.f, grab_height)];
        [rejectBtn setBackgroundColor:colorWithHexString(@"ffffff")];
        [rejectBtn setTitleColor:colorWithHexString(@"f0640f") forState:UIControlStateNormal];
        [rejectBtn setTitle:@"我不接" forState:UIControlStateNormal];
        rejectBtn.layer.cornerRadius = 4.f;
        @weakify(self);
        [[rejectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:self.currentOrderID andIsAssign:NO];
            [self.navigationController pushViewController:rejectVC animated:YES];
        }];
        [backView addSubview:rejectBtn];
    }
    
    [self.view addSubview:backView];
}

#pragma mark -
#pragma mark UIDatePicker
- (void)createDatePicker
{
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    _bgView.tag = 101;
    [self.view addSubview:_bgView];
    
    originDate = [NSDate date];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-40, SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = colorWithHexString(@"ffffff");
    titleLabel.text = @"请选择到达时间";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)-1, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [_bgView addSubview:line];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    _datePicker.backgroundColor = colorWithHexString(@"ffffff");
    _datePicker.minimumDate = [NSDate date];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    @weakify(self);
    [[_datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        // 获取分钟数
        self.timeInterval2 = [self.datePicker.date timeIntervalSince1970];
    }];
    [_bgView addSubview:_datePicker];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"ffffff");
    [_bgView addSubview:toolView];
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showLoadingMBP:@"请稍候..."];
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)self.timeInterval2];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        NSString *userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
        NSArray *users = @[userID];
        [request reaciveOrderID:[NSString stringWithFormat:@"%ld",(long)self.repairDetail.repairID]
                    arrivalTime:timeStr
                      andUserID:userID
                       andUsers:users
                      andIsGrad:NO];
        self.datePicker = nil;
        [self.bgView removeFromSuperview];
    }];
    [toolView addSubview:sureBtn];
    
    // cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    cancelBtn.layer.borderWidth = 0.5;
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.datePicker = nil;
        [self.bgView removeFromSuperview];
    }];
    [toolView addSubview:cancelBtn];
}

#pragma mark -
#pragma mark 事件
- (void)navigationLeftButton
{
    if (isAssign)
    {
        [super navigationLeftButton];
    }
    else
    {
        BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:self.currentOrderID andIsAssign:NO];
        [self.navigationController pushViewController:rejectVC animated:YES];
    }
}

- (void)grabBtnClick
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    if (boxView)
    {
        [boxView boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray];
        [self.view bringSubviewToFront:boxView];
    }
    else
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray markID:nil actionDelegate:self];
        [self.view addSubview:boxView];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
    }];
}

- (void)assignBtnClick
{
    NSArray *roleArray = [BXTGlobal getUserProperty:U_ROLEARRAY];
    if (![roleArray containsObject:@"117"])
    {
        [BXTGlobal showText:@"抱歉，您无指派权限" view:self.view completionBlock:nil];
        return;
    }
    BXTAddOtherManViewController *addOtherVC = [[BXTAddOtherManViewController alloc] initWithRepairID:[self.currentOrderID integerValue] andWithVCType:AssignType];
    [self.manIDArray addObject:[NSString stringWithFormat:@"%@", [BXTGlobal getUserProperty:U_BRANCHUSERID]]];
    addOtherVC.manIDArray = self.manIDArray;
    [self.navigationController pushViewController:addOtherVC animated:YES];
}

- (void)connectTa
{
    NSDictionary *repaier_fault_dic = _repairDetail.repair_fault_arr[0];
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [repaier_fault_dic objectForKey:@"out_userid"];
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID]) return;
    
    userInfo.name = [repaier_fault_dic objectForKey:@"name"];
    userInfo.portraitUri = [repaier_fault_dic objectForKey:@"head_pic"];
    
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
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = userInfo.userId;
    conversationVC.title = userInfo.name;
    // 删除位置功能
    //[conversationVC.pluginBoardView removeItemAtIndex:2];
    [self.navigationController pushViewController:conversationVC animated:YES];
    self.navigationController.navigationBar.hidden = NO;
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
        
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        DCObjectMapping *map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"repairID" onClass:[BXTRepairDetailInfo class]];
        [config addObjectMapping:map];
        
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTRepairDetailInfo class] andConfiguration:config];
        self.repairDetail = [parser parseDictionary:dictionary];
        
        NSDictionary *repaier_fault_dic = _repairDetail.repair_fault_arr[0];
        NSString *headURL = [repaier_fault_dic objectForKey:@"head_pic"];
        [headImgView sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        repairerName.text = [repaier_fault_dic objectForKey:@"name"];
        repairerDetail.text = [repaier_fault_dic objectForKey:@"role"];
        
        repairID.text = [NSString stringWithFormat:@"工单号:%@",_repairDetail.orderid];
        
        NSTimeInterval timeInterval = [_repairDetail.repair_time doubleValue];
        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        time.text = [NSString stringWithFormat:@"报修时间:%@",currentDateStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_repairDetail.visitmobile];
        [attributedString addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:NSMakeRange(0, 11)];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 11)];
        mobile.attributedText = attributedString;
        
        NSString *group_name = _repairDetail.subgroup_name.length > 0 ? _repairDetail.subgroup_name : @"其他";
        CGSize group_size = MB_MULTILINE_TEXTSIZE(group_name, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH, 40.f), NSLineBreakByWordWrapping);
        group_size.width += 10.f;
        group_size.height = CGRectGetHeight(groupName.frame);
        groupName.frame = CGRectMake(SCREEN_WIDTH - group_size.width - 15.f, CGRectGetMinY(groupName.frame), group_size.width, group_size.height);
        groupName.text = group_name;
        
        if (_repairDetail.order_type == 1)
        {
            orderType.text = @"";
        }
        else if (_repairDetail.order_type == 2)
        {
            orderType.text = @"协作工单";
        }
        else if (_repairDetail.order_type == 3)
        {
            orderType.text = @"特殊工单";
        }
        else if (_repairDetail.order_type == 4)
        {
            orderType.text = @"超时工单";
        }
        
        
        place.text = [NSString stringWithFormat:@"位置:%@-%@",_repairDetail.area_name,_repairDetail.place_name];
        
        CGSize cause_size = MB_MULTILINE_TEXTSIZE(place.text, [UIFont boldSystemFontOfSize:17.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
        // 更新所有控件位置 1
        place.frame = CGRectMake(15.f, CGRectGetMaxY(lineThree.frame) + 10.f, SCREEN_WIDTH - 30.f, cause_size.height);
        faultType.frame = CGRectMake(15.f, CGRectGetMaxY(place.frame) + 10.f, CGRectGetWidth(place.frame), 20);
        cause.frame = CGRectMake(15.f, CGRectGetMaxY(faultType.frame) + 10.f, CGRectGetWidth(faultType.frame), 20);
        level.frame = CGRectMake(15.f, CGRectGetMaxY(cause.frame) + 10.f, CGRectGetWidth(cause.frame), 20);
        
        
        faultType.text = [NSString stringWithFormat:@"故障类型:%@",_repairDetail.faulttype_name];
        cause.text = [NSString stringWithFormat:@"故障描述:%@",_repairDetail.cause];
        
        if (_repairDetail.urgent == 2)
        {
            level.text = @"等级:一般";
        }
        else
        {
            NSString *str = @"等级:紧急";
            NSRange range = [str rangeOfString:@"紧急"];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
            level.attributedText = attributeStr;
        }
        
        notes.text = [NSString stringWithFormat:@"报修内容:%@",_repairDetail.notes];
        UIFont *font = [UIFont boldSystemFontOfSize:17.f];
        CGSize size = MB_MULTILINE_TEXTSIZE(notes.text, font, CGSizeMake(SCREEN_WIDTH - 30.f, 1000.f), NSLineBreakByWordWrapping);
        notes.frame = CGRectMake(15.f, CGRectGetMaxY(level.frame) + 8.f, CGRectGetWidth(level.frame), size.height);
        
        NSArray *imgArray = [self containAllArray];
        if (imgArray.count > 0)
        {
            NSInteger i = 0;
            UIScrollView *imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH, ImageHeight)];
            imagesScrollView.contentSize = CGSizeMake((ImageWidth + 25) * imgArray.count + 25.f, ImageHeight);
            [imagesScrollView setShowsHorizontalScrollIndicator:NO];
            for (NSDictionary *dictionary in imgArray)
            {
                if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
                {
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25.f * (i + 1) + ImageWidth * i, 0, ImageWidth, ImageHeight)];
                    imgView.userInteractionEnabled = YES;
                    imgView.layer.masksToBounds = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
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
            }];
        }
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

#pragma mark -
#pragma mark BXTBoxSelectedTitleDelegate
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    UIView *view = [self.view viewWithTag:101];
    [view removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    }];
    
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *tempStr = (NSString *)obj;
        if ([tempStr isEqualToString:@"自定义"])
        {
            [self createDatePicker];
            return;
        }
        NSString *timeStr = [tempStr stringByReplacingOccurrencesOfString:@"分钟内" withString:@""];
        NSTimeInterval timer = [[NSDate date] timeIntervalSince1970] + [timeStr intValue]*60;
        timeStr = [NSString stringWithFormat:@"%.0f", timer];
        
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        NSString *userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
        NSArray *users = @[userID];
        [request reaciveOrderID:[NSString stringWithFormat:@"%ld",(long)self.repairDetail.repairID]
                    arrivalTime:timeStr
                      andUserID:userID
                       andUsers:users
                      andIsGrad:NO];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (_datePicker)
        {
            [_datePicker removeFromSuperview];
            _datePicker = nil;
        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
            }];
        }
        
        [view removeFromSuperview];
    }
}

#pragma mark -
#pragma mark 其他
- (NSMutableArray *)containAllArray
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in _repairDetail.fault_pic)
    {
        [photos addObject:dictionary];
    }
    for (NSDictionary *dictionary in _repairDetail.fixed_pic)
    {
        [photos addObject:dictionary];
    }
    for (NSDictionary *dictionary in _repairDetail.evaluation_pic)
    {
        [photos addObject:dictionary];
    }
    return photos;
}

- (NSMutableArray *)containAllPhotosForMWPhotoBrowser
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in _repairDetail.fault_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    
    for (NSDictionary *dictionary in _repairDetail.fixed_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    
    for (NSDictionary *dictionary in _repairDetail.evaluation_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
