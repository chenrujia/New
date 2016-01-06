//
//  BXTOrderDetailViewController.m
//  BXT
//
//  Created by Jason on 15/9/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTOrderDetailViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTRepairDetailInfo.h"
#import "UIImageView+WebCache.h"
#import "BXTDrawView.h"
#import "BXTSelectBoxView.h"
#import "BXTMaintenanceProcessViewController.h"
#import "BXTAddOtherManViewController.h"
#import "BXTRejectOrderViewController.h"

#define ImageWidth 73.3f
#define ImageHeight 73.3f
#define RepairHeight 95.f
#define StateViewHeight 90.f

@interface BXTOrderDetailViewController ()<BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate,UITabBarDelegate>
{
    UIImageView         *headImgView;
    UILabel             *repairerName;
    UILabel             *repairerDetail;
    UILabel             *repairID;
    UILabel             *groupName;
    UILabel             *orderType;
    UILabel             *time;
    UILabel             *mobile;
    UILabel             *place;
    UILabel             *faultType;
    UILabel             *cause;
    UILabel             *level;
    UILabel             *notes;
    UILabel             *arrangeTime;
    UILabel             *mmProcess;
    UILabel             *workTime;
    UIButton            *reaciveOrder;
    UIScrollView        *scrollView;
    UIView              *lineView;
    UILabel             *maintenanceMan;
    UIScrollView        *imagesScrollView;
    
    NSDate              *originDate;
    CGFloat             contentHeight;
}

@property (nonatomic ,strong) BXTSelectBoxView    *boxView;
@property (nonatomic ,strong) NSString            *repair_id;
@property (nonatomic ,strong) NSMutableArray      *manIDArray;
@property (nonatomic ,strong) UIView              *manBgView;
@property (nonatomic ,strong) NSArray             *comeTimeArray;
@property (nonatomic ,strong) UIDatePicker        *datePicker;
@property (nonatomic ,strong) UIView              *bgView;
@property (nonatomic ,assign) NSTimeInterval      timeInterval2;
@property (nonatomic ,strong) BXTRepairDetailInfo *repairDetail;

@end

@implementation BXTOrderDetailViewController

- (void)dataWithRepairID:(NSString *)repair_ID
{
    [BXTGlobal shareGlobal].maxPics = 3;
    self.repair_id = repair_ID;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contentHeight = 300.f;
    if (self.isRejectVC)
    {
        [self navigationSetting:@"工单详情" andRightTitle:@"关闭工单" andRightImage:nil];
    }
    else
    {
        [self navigationSetting:@"工单详情" andRightTitle:nil andRightImage:nil];
    }
    [self createSubViews];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RequestDetail" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self requestDetail];
    }];
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"])
    {
        [timeArray addObject:[NSString stringWithFormat:@"%@分钟内", timeStr]];
    }
    [timeArray addObject:@"自定义"];
    self.comeTimeArray = timeArray;
    [self requestDetail];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)navigationRightButton
{
    BXTRejectOrderViewController *rejectVC = [[BXTRejectOrderViewController alloc] initWithOrderID:[NSString stringWithFormat:@"%@",self.repair_id] andIsAssign:YES];
    [self.navigationController pushViewController:rejectVC animated:YES];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createSubViews
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight);
    scrollView.backgroundColor = colorWithHexString(@"ffffff");
    [self.view addSubview:scrollView];
    
    headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 12.f, ImageWidth, ImageHeight)];
    headImgView.image = [UIImage imageNamed:@"polaroid"];
    [scrollView addSubview:headImgView];
    
    repairerName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImgView.frame) + 10.f, CGRectGetMinY(headImgView.frame) + 5.f, 160.f, 20)];
    repairerName.textColor = colorWithHexString(@"000000");
    repairerName.font = [UIFont boldSystemFontOfSize:16.f];
    [scrollView addSubview:repairerName];
    
    repairerDetail = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(repairerName.frame), CGRectGetMinY(headImgView.frame) + 28.f, 160.f, 20)];
    repairerDetail.textColor = colorWithHexString(@"909497");
    repairerDetail.font = [UIFont systemFontOfSize:15.f];
    [scrollView addSubview:repairerDetail];
    
    mobile = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(repairerDetail.frame), CGRectGetMinY(headImgView.frame) + 50.f, 160.f, 20)];
    mobile.textColor = colorWithHexString(@"000000");
    mobile.font = [UIFont systemFontOfSize:15.f];
    mobile.userInteractionEnabled = YES;
    [scrollView addSubview:mobile];
    UITapGestureRecognizer *moblieTap = [[UITapGestureRecognizer alloc] init];
    [mobile addGestureRecognizer:moblieTap];
    @weakify(self);
    [[moblieTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.repairDetail.visitmobile];
        UIWebView *callWeb = [[UIWebView alloc] init];
        [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
        [self.view addSubview:callWeb];
    }];
    
    UIButton *connetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connetBtn.frame = CGRectMake(SCREEN_WIDTH - 83.3f - 15.f, 30.f, 83.3f, 40.f);
    [connetBtn setTitle:@"联系Ta" forState:UIControlStateNormal];
    [connetBtn setTitleColor:colorWithHexString(@"3bafff") forState:UIControlStateNormal];
    connetBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
    connetBtn.layer.borderWidth = 1.f;
    connetBtn.layer.cornerRadius = 6.f;
    [[connetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *repaier_fault_dic = self.repairDetail.repair_fault_arr[0];
        [self handleUserInfo:repaier_fault_dic];
    }];
    [scrollView addSubview:connetBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(headImgView.frame) + 12.f, SCREEN_WIDTH - 30.f, 1.f)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [scrollView addSubview:line];
    
    repairID = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(line.frame) + 15.f, SCREEN_WIDTH - 30.f, 20)];
    repairID.textColor = colorWithHexString(@"000000");
    repairID.font = [UIFont boldSystemFontOfSize:17.f];
    repairID.text = @"工单号:";
    [scrollView addSubview:repairID];
    
    groupName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50.f - 15.f, CGRectGetMaxY(line.frame) + 12.f, 50.f, 26.3f)];
    groupName.textColor = colorWithHexString(@"00a2ff");
    groupName.layer.borderColor = colorWithHexString(@"00a2ff").CGColor;
    groupName.layer.borderWidth = 1.f;
    groupName.layer.cornerRadius = 4.f;
    groupName.font = [UIFont systemFontOfSize:16.f];
    groupName.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:groupName];
    
    UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(repairID.frame) + 12.f, SCREEN_WIDTH - 30.f, 1.f)];
    lineTwo.backgroundColor = colorWithHexString(@"e2e6e8");
    [scrollView addSubview:lineTwo];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineTwo.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    time.textColor = colorWithHexString(@"000000");
    time.font = [UIFont boldSystemFontOfSize:17.f];
    time.text = @"报修时间:";
    [scrollView addSubview:time];
    
    orderType = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80.f - 15.f, CGRectGetMaxY(lineTwo.frame) + 10.f, 80.f, 20)];
    orderType.textColor = colorWithHexString(@"cc0202");
    orderType.textAlignment = NSTextAlignmentRight;
    orderType.font = [UIFont boldSystemFontOfSize:16.f];
    [scrollView addSubview:orderType];
    
    UIView *lineThree = [[UIView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(time.frame) + 12.f, SCREEN_WIDTH - 30.f, 1.f)];
    lineThree.backgroundColor = colorWithHexString(@"e2e6e8");
    [scrollView addSubview:lineThree];
    
    place = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineThree.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    place.textColor = colorWithHexString(@"000000");
    place.numberOfLines = 0;
    place.font = [UIFont boldSystemFontOfSize:17.f];
    place.text = @"位置:";
    [scrollView addSubview:place];
    
    faultType = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(place.frame) + 10.f, CGRectGetWidth(place.frame), 20)];
    faultType.textColor = colorWithHexString(@"000000");
    faultType.font = [UIFont boldSystemFontOfSize:17.f];
    faultType.text = @"故障类型:";
    [scrollView addSubview:faultType];
    
    cause = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(faultType.frame) + 10.f, CGRectGetWidth(faultType.frame), 20)];
    cause.textColor = colorWithHexString(@"000000");
    cause.font = [UIFont boldSystemFontOfSize:17.f];
    cause.text = @"故障描述:";
    [scrollView addSubview:cause];
    
    level = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(cause.frame) + 10.f, CGRectGetWidth(cause.frame), 20)];
    level.textColor = colorWithHexString(@"000000");
    level.font = [UIFont boldSystemFontOfSize:17.f];
    NSString *str = @"等级:紧急";
    NSRange range = [str rangeOfString:@"紧急"];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
    level.attributedText = attributeStr;
    [scrollView addSubview:level];
    
    notes = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(level.frame) + 8.f, CGRectGetWidth(level.frame), 20)];
    notes.textColor = colorWithHexString(@"000000");
    notes.numberOfLines = 0;
    notes.lineBreakMode = NSLineBreakByWordWrapping;
    notes.font = [UIFont boldSystemFontOfSize:17.f];
    [scrollView addSubview:notes];
    
    arrangeTime = [[UILabel alloc] init];
    arrangeTime.textColor = colorWithHexString(@"000000");
    arrangeTime.font = [UIFont boldSystemFontOfSize:17.f];
    [scrollView addSubview:arrangeTime];
    
    mmProcess = [[UILabel alloc] init];
    mmProcess.numberOfLines = 0;
    mmProcess.lineBreakMode = NSLineBreakByWordWrapping;
    mmProcess.textColor = colorWithHexString(@"000000");
    mmProcess.font = [UIFont boldSystemFontOfSize:17.f];
    [scrollView addSubview:mmProcess];
    
    workTime = [[UILabel alloc] init];
    workTime.textColor = colorWithHexString(@"000000");
    workTime.font = [UIFont boldSystemFontOfSize:17.f];
    [scrollView addSubview:workTime];
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorWithHexString(@"e2e6e8");
    [scrollView addSubview:lineView];
    
    maintenanceMan = [[UILabel alloc] init];
    maintenanceMan.textColor = colorWithHexString(@"000000");
    maintenanceMan.font = [UIFont boldSystemFontOfSize:17.f];
    maintenanceMan.text = @"维修人员:";
    [scrollView addSubview:maintenanceMan];
    
    if ([BXTGlobal shareGlobal].isRepair && !_isAllOrderType)
    {
        reaciveOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        reaciveOrder.frame = CGRectMake(20, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
        [reaciveOrder setTitle:@"接单" forState:UIControlStateNormal];
        [reaciveOrder setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [reaciveOrder setBackgroundColor:colorWithHexString(@"3cafff")];
        reaciveOrder.layer.masksToBounds = YES;
        reaciveOrder.layer.cornerRadius = 6.f;
        [[reaciveOrder rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
            backView.backgroundColor = [UIColor blackColor];
            backView.alpha = 0.6f;
            backView.tag = 101;
            [self.view addSubview:backView];
            
            if (self.boxView)
            {
                [self.boxView boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:self.comeTimeArray];
                [self.view bringSubviewToFront:self.boxView];
            }
            else
            {
                self.boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:self.comeTimeArray markID:nil actionDelegate:self];
                [self.view addSubview:self.boxView];
            }
            
            [UIView animateWithDuration:0.3f animations:^{
                [self.boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
            }];
        }];
        [scrollView addSubview:reaciveOrder];
    }
}

- (void)createDatePicker
{
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    self.bgView.tag = 101;
    [self.view addSubview:self.bgView];
    
    originDate = [NSDate date];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-40, SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = colorWithHexString(@"ffffff");
    titleLabel.text = @"请选择到达时间";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)-1, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [self.bgView addSubview:line];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    self.datePicker.backgroundColor = colorWithHexString(@"ffffff");
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    @weakify(self);
    [[self.datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        // 获取分钟数
        self.timeInterval2 = [self.datePicker.date timeIntervalSince1970];
    }];
    [self.bgView addSubview:self.datePicker];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"ffffff");
    [self.bgView addSubview:toolView];
    
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)self.timeInterval2];
        [self showLoadingMBP:@"请稍候..."];
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
#pragma mark 事件处理
- (void)requestDetail
{
    /**获取详情**/
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairDetail:[NSString stringWithFormat:@"%@",_repair_id]];
}

- (void)handleUserInfo:(NSDictionary *)dictionary
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [dictionary objectForKey:@"out_userid"];
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID]) return;
    
    userInfo.name = [dictionary objectForKey:@"name"];
    userInfo.portraitUri = [dictionary objectForKey:@"head_pic"];
    
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

- (NSMutableArray *)containAllPhotosForMWPhotoBrowser
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in self.repairDetail.fault_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    
    for (NSDictionary *dictionary in self.repairDetail.fixed_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    
    for (NSDictionary *dictionary in self.repairDetail.evaluation_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

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

- (void)loadingUsers
{
    NSTimeInterval repairTime = [_repairDetail.dispatching_time doubleValue];
    NSDate *repairDate = [NSDate dateWithTimeIntervalSince1970:repairTime];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *repairDateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [repairDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *repairDateStr = [repairDateFormatter stringFromDate:repairDate];
    arrangeTime.text = [NSString stringWithFormat:@"派工时间:%@",repairDateStr];
    if (workTime.hidden)
    {
        lineView.frame = CGRectMake(15.f, CGRectGetMaxY(arrangeTime.frame) + 15.f, SCREEN_WIDTH - 30.f, 1.f);
    }
    else
    {
        mmProcess.text = [NSString stringWithFormat:@"维修过程:%@",_repairDetail.workprocess];
        workTime.text = [NSString stringWithFormat:@"维修工时:%@小时",_repairDetail.man_hours];
        lineView.frame = CGRectMake(15.f, CGRectGetMaxY(workTime.frame) + 15.f, SCREEN_WIDTH - 30.f, 1.f);
    }
    maintenanceMan.frame = CGRectMake(20.f, CGRectGetMaxY(lineView.frame) + 10.f, SCREEN_WIDTH - 40.f, 40.f);
    
    self.manIDArray = [[NSMutableArray alloc] init];
    
    // 添加维修者列表背景
    [self.manBgView removeFromSuperview];
    self.manBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(maintenanceMan.frame), SCREEN_WIDTH,  _repairDetail.repair_user_arr.count * 95.f)];
    [scrollView addSubview:self.manBgView];
    
    for (NSInteger i = 0; i < _repairDetail.repair_user_arr.count; i++)
    {
        NSDictionary *userDic = _repairDetail.repair_user_arr[i];
        
        [self.manIDArray addObject:userDic[@"id"]];
        
        UIView *userBack = [[UIView alloc] initWithFrame:CGRectMake(0.f,  i * 95.f, SCREEN_WIDTH, 95.f)];
        UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 73.3f, 73.3f)];
        [userImgView sd_setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"head_pic"]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        [userBack addSubview:userImgView];
        
        UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 8.f, CGRectGetWidth(level.frame), 20)];
        userName.textColor = colorWithHexString(@"000000");
        userName.numberOfLines = 0;
        userName.lineBreakMode = NSLineBreakByWordWrapping;
        userName.font = [UIFont boldSystemFontOfSize:16.f];
        userName.text = [userDic objectForKey:@"name"];
        [userBack addSubview:userName];
        
        UILabel *role = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 28.f, CGRectGetWidth(level.frame), 20)];
        role.textColor = colorWithHexString(@"909497");
        role.numberOfLines = 0;
        role.lineBreakMode = NSLineBreakByWordWrapping;
        role.font = [UIFont boldSystemFontOfSize:14.f];
        role.text = [NSString stringWithFormat:@"%@-%@",[userDic objectForKey:@"department"],[userDic objectForKey:@"role"]];
        [userBack addSubview:role];
        
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 50.f, CGRectGetWidth(level.frame), 20)];
        phone.textColor = colorWithHexString(@"909497");
        phone.numberOfLines = 0;
        phone.lineBreakMode = NSLineBreakByWordWrapping;
        phone.userInteractionEnabled = YES;
        phone.font = [UIFont boldSystemFontOfSize:14.f];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[userDic objectForKey:@"mobile"]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:NSMakeRange(0, 11)];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 11)];
        phone.attributedText = attributedString;
        UITapGestureRecognizer *moblieTap = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [[moblieTap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            NSDictionary *userDic = self.repairDetail.repair_user_arr[i];
            NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", [userDic objectForKey:@"mobile"]];
            UIWebView *callWeb = [[UIWebView alloc] init];
            [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
            [self.view addSubview:callWeb];
        }];
        [phone addGestureRecognizer:moblieTap];
        [userBack addSubview:phone];
        
        if ([[userDic objectForKey:@"id"] isEqualToString:[BXTGlobal getUserProperty:U_BRANCHUSERID]] &&
            _repairDetail.repairstate == 2 &&
            _repairDetail.isRepairing == 1)
        {
            UIButton *repairNow = [UIButton buttonWithType:UIButtonTypeCustom];
            repairNow.layer.cornerRadius = 4.f;
            repairNow.backgroundColor = colorWithHexString(@"3cafff");
            [repairNow setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 22.5f + 10.f, 83.f, 40.f)];
            [repairNow setTitle:@"开始维修" forState:UIControlStateNormal];
            [repairNow setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
            repairNow.titleLabel.font = [UIFont systemFontOfSize:15];
            [[repairNow rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self showLoadingMBP:@"请稍候..."];
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request startRepair:[NSString stringWithFormat:@"%ld",(long)self.repairDetail.repairID]];
            }];
            [userBack addSubview:repairNow];
        }
        else
        {
            UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
            contact.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            contact.layer.borderWidth = 1.f;
            contact.layer.cornerRadius = 6.f;
            [contact setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 22.5f + 10.f, 83.f, 40.f)];
            [contact setTitle:@"联系Ta" forState:UIControlStateNormal];
            [contact setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            @weakify(self);
            [[contact rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                NSDictionary *userDic = self.repairDetail.repair_user_arr[i];
                [self handleUserInfo:userDic];
            }];
            [userBack addSubview:contact];
        }
        
        if (i != _repairDetail.repair_user_arr.count -1)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, userBack.bounds.size.height - 1.f, SCREEN_WIDTH - 30.f, 1.f)];
            line.backgroundColor = colorWithHexString(@"e2e6e8");
            [userBack addSubview:line];
        }
        
        [self.manBgView addSubview:userBack];
    }
    
    reaciveOrder.frame = CGRectMake(20, CGRectGetMaxY(maintenanceMan.frame) + _repairDetail.repair_user_arr.count * 95.f + 20.f, SCREEN_WIDTH - 40, 50.f);
}

#pragma mark -
#pragma mark TouchBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (self.datePicker)
        {
            [_datePicker removeFromSuperview];
            _datePicker = nil;
        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                [self.boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
            }];
        }
        
        [view removeFromSuperview];
    }
}

#pragma mark -
#pragma mark BXTBoxSelectedTitleDelegate
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    UIView *view = [self.view viewWithTag:101];
    [view removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        [self.boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
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
        [request reaciveOrderID:[NSString stringWithFormat:@"%ld",(long)_repairDetail.repairID]
                    arrivalTime:timeStr
                      andUserID:userID
                       andUsers:users
                      andIsGrad:NO];
    }
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
        _repairDetail = [parser parseDictionary:dictionary];
        
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
        
        if (_repairDetail.stores_name.length)
        {
            place.text = [NSString stringWithFormat:@"位置:%@-%@-%@",_repairDetail.area_name,_repairDetail.place_name,_repairDetail.stores_name];
        }
        else
        {
            place.text = [NSString stringWithFormat:@"位置:%@-%@",_repairDetail.area_name,_repairDetail.place_name];
        }

        // 各类控件高度自适应
        CGSize cause_size = MB_MULTILINE_TEXTSIZE(place.text, [UIFont boldSystemFontOfSize:17.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
        place.frame = CGRectMake(15.f, CGRectGetMaxY(time.frame) + 13+10.f, SCREEN_WIDTH - 30.f, cause_size.height);
        faultType.frame = CGRectMake(15.f, CGRectGetMaxY(place.frame) + 10.f, CGRectGetWidth(place.frame), 20);
        cause.frame = CGRectMake(15.f, CGRectGetMaxY(faultType.frame) + 10.f, CGRectGetWidth(faultType.frame), 20);
        level.frame = CGRectMake(15.f, CGRectGetMaxY(cause.frame) + 10.f, CGRectGetWidth(cause.frame), 20);
        notes.frame = CGRectMake(15.f, CGRectGetMaxY(level.frame) + 8.f, CGRectGetWidth(level.frame), 20);
        
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
        
        NSString *contents = [NSString stringWithFormat:@"报修内容:%@",_repairDetail.notes];
        UIFont *font = [UIFont boldSystemFontOfSize:17.f];
        CGSize size = MB_MULTILINE_TEXTSIZE(contents, font, CGSizeMake(SCREEN_WIDTH - 30.f, 1000.f), NSLineBreakByWordWrapping);
        CGRect rect = notes.frame;
        rect.size = size;
        notes.frame = rect;
        notes.text = contents;
        
        
        NSArray *imgArray = [self containAllArray];
        if (imgArray.count > 0)
        {
            NSInteger i = 0;
            imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH, ImageHeight)];
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
            [scrollView addSubview:imagesScrollView];
            lineView.frame = CGRectMake(15.f, CGRectGetMaxY(notes.frame) + ImageHeight + 20.f + 20.f, SCREEN_WIDTH - 30.f, 1.f);
            
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(notes.frame) + ImageHeight + 20.f + 20.f, SCREEN_WIDTH, StateViewHeight) withRepairState:_repairDetail.repairstate withIsRespairing:_repairDetail.isRepairing];
            [scrollView addSubview:drawView];
            arrangeTime.frame = CGRectMake(20.f, CGRectGetMaxY(drawView.frame) + 15.f, SCREEN_WIDTH - 40.f, 20.f);
            
            if (_repairDetail.man_hours.length)
            {
                NSString *mm_content = [NSString stringWithFormat:@"维修备注:%@",_repairDetail.workprocess];
                CGSize mmProcessSize = MB_MULTILINE_TEXTSIZE(mm_content, font, CGSizeMake(SCREEN_WIDTH - 40.f, 1000.f), NSLineBreakByWordWrapping);
                contentHeight += mmProcessSize.height;
                mmProcess.frame = CGRectMake(20.f, CGRectGetMaxY(arrangeTime.frame) + 15.f, SCREEN_WIDTH - 40.f, mmProcessSize.height);
                workTime.frame = CGRectMake(20.f, CGRectGetMaxY(mmProcess.frame) + 15.f, SCREEN_WIDTH - 40.f, 20.f);
            }
            else
            {
                mmProcess.hidden = YES;
                workTime.hidden = YES;
            }
            
            if (_repairDetail.repair_user_arr.count > 0)
            {
                [self loadingUsers];
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + ImageHeight + 40.f + StateViewHeight + 40.f + RepairHeight * _repairDetail.repair_user_arr.count + 100.f + 200.f/3.f);
            }
            else
            {
                reaciveOrder.frame = CGRectMake(20, CGRectGetMaxY(drawView.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(reaciveOrder.frame));
            }
        }
        else
        {
            lineView.frame = CGRectMake(15.f, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH - 30.f, 1.f);
            
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH, StateViewHeight) withRepairState:_repairDetail.repairstate withIsRespairing:_repairDetail.isRepairing];
            [scrollView addSubview:drawView];
            arrangeTime.frame = CGRectMake(20.f, CGRectGetMaxY(drawView.frame) + 15.f, SCREEN_WIDTH - 40.f, 20.f);
            
            if (_repairDetail.man_hours.length)
            {
                NSString *mm_content = [NSString stringWithFormat:@"维修备注:%@",_repairDetail.workprocess];
                CGSize mmProcessSize = MB_MULTILINE_TEXTSIZE(mm_content, font, CGSizeMake(SCREEN_WIDTH - 40.f, 1000.f), NSLineBreakByWordWrapping);
                contentHeight += mmProcessSize.height;
                mmProcess.frame = CGRectMake(20.f, CGRectGetMaxY(arrangeTime.frame) + 15.f, SCREEN_WIDTH - 40.f, mmProcessSize.height);
                workTime.frame = CGRectMake(20.f, CGRectGetMaxY(mmProcess.frame) + 15.f, SCREEN_WIDTH - 40.f, 20.f);
            }
            else
            {
                mmProcess.hidden = YES;
                workTime.hidden = YES;
            }
            
            if (_repairDetail.repair_user_arr.count > 0)
            {
                [self loadingUsers];
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + StateViewHeight + 40.f + RepairHeight * _repairDetail.repair_user_arr.count + 100.f + 200.f/3.f);
                if (!workTime.hidden)
                {
                    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + StateViewHeight + 40.f + RepairHeight * _repairDetail.repair_user_arr.count + 100.f + 200.f/3.f + 50);
                }
            }
            else
            {
                reaciveOrder.frame = CGRectMake(20, CGRectGetMaxY(drawView.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(reaciveOrder.frame));
            }
        }
        
        if (_repairDetail.repairstate == 2 && _repairDetail.isRepairing == 2 && _repairDetail.order_type != 3)
        {
            if (!self.isRejectVC && [BXTGlobal shareGlobal].isRepair)
            {
                UITabBar *tabbar = [[UITabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50.f, SCREEN_WIDTH, 50.f)];
                tabbar.delegate = self;
                UITabBarItem *leftItem = [[UITabBarItem alloc] initWithTitle:@"增加人员" image:[UIImage imageNamed:@"users"] selectedImage:[UIImage imageNamed:@"users_selected"]];
                leftItem.tag = 101;
                UITabBarItem *rightItem = [[UITabBarItem alloc] initWithTitle:@"维修过程" image:[UIImage imageNamed:@"pen"] selectedImage:[UIImage imageNamed:@"pen_selected"]];
                rightItem.tag = 102;
                [tabbar setItems:@[leftItem,rightItem]];
                [self.view addSubview:tabbar];
                
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(reaciveOrder.frame));
            }
        }
        
        if (_repairDetail.repairstate != 1)
        {
            [reaciveOrder removeFromSuperview];
            reaciveOrder = nil;
        }
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
    else if (type == StartRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
            __weak typeof(self) weakSelf = self;
            [self showMBP:@"已经开始！" withBlock:^(BOOL hidden) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

#pragma mark -
#pragma mark UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 101)
    {
        BXTAddOtherManViewController *addOtherVC = [[BXTAddOtherManViewController alloc] initWithRepairID:[_repair_id integerValue] andWithVCType:DetailType];
        addOtherVC.manIDArray = self.manIDArray;
        [self.navigationController pushViewController:addOtherVC animated:YES];
    }
    else if (item.tag == 102)
    {
        BXTMaintenanceProcessViewController *maintenanceProcossVC = [[BXTMaintenanceProcessViewController alloc] initWithCause:_repairDetail.faulttype_name andCurrentFaultID:_repairDetail.faulttype andRepairID:_repairDetail.repairID andReaciveTime:_repairDetail.start_time];
        __weak BXTOrderDetailViewController *weakSelf = self;
        maintenanceProcossVC.BlockRefresh = ^() {
            // 移除，避免多层显示
            [scrollView removeFromSuperview];
            [weakSelf createSubViews];
            [weakSelf requestDetail];
        };
        [self.navigationController pushViewController:maintenanceProcossVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
