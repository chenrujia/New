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
#import "BXTEvaluationViewController.h"
#import "UIImageView+WebCache.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "BXTDrawView.h"
#import "BXTSelectBoxView.h"
#import "BXTMaintenanceProcessViewController.h"
#import "BXTAddOtherManViewController.h"

#define ImageWidth 73.3f
#define ImageHeight 73.3f
#define RepairHeight 95.f
#define StateViewHeight 90.f

@interface BXTOrderDetailViewController ()<BXTDataResponseDelegate,MWPhotoBrowserDelegate,BXTBoxSelectedTitleDelegate,UITabBarDelegate>
{
    UIImageView *headImgView;
    UILabel *repairerName;
    UILabel *repairerDetail;
    UILabel *repairID;
    UILabel *groupName;
    UILabel *orderType;
    UILabel *time;
    UILabel *mobile;
    UILabel *place;
    UILabel *faultType;
    UILabel *cause;
    UILabel *level;
    UILabel *notes;
    UILabel *arrangeTime;
    UILabel *mmProcess;
    UILabel *workTime;
    UIButton *reaciveOrder;
    BXTRepairDetailInfo *repairDetail;
    UIScrollView *scrollView;
    BXTSelectBoxView *boxView;
    NSArray *comeTimeArray;
    UIView *lineView;
    UILabel *maintenanceMan;
    UIScrollView *imagesScrollView;
    
    UIView *bgView;
    UIDatePicker *datePicker;
    NSDate *originDate;
    NSTimeInterval timeInterval2;
    CGFloat contentHeight;
}

@property (nonatomic ,strong) NSString *repair_id;
@property (nonatomic ,strong) NSMutableArray *mwPhotosArray;

@end

@implementation BXTOrderDetailViewController

- (instancetype)initWithRepairID:(NSString *)reID
{
    self = [super init];
    if (self)
    {
        [BXTGlobal shareGlobal].maxPics = 3;
        self.repair_id = reID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    contentHeight = 300.f;
    
    [self navigationSetting:@"工单详情" andRightTitle:nil andRightImage:nil];
    [self createSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDetail) name:@"RequestDetail" object:nil];
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"])
    {
        [timeArray addObject:[NSString stringWithFormat:@"%@分钟内", timeStr]];
    }
    [timeArray addObject:@"自定义"];
    comeTimeArray = timeArray;
    [self requestDetail];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    self.navigationController.navigationBar.hidden = YES;
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
    UITapGestureRecognizer *moblieTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mobileClick)];
    [mobile addGestureRecognizer:moblieTap];
    
    UIButton *connetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connetBtn.frame = CGRectMake(SCREEN_WIDTH - 83.3f - 15.f, 30.f, 83.3f, 40.f);
    [connetBtn setTitle:@"联系Ta" forState:UIControlStateNormal];
    [connetBtn setTitleColor:colorWithHexString(@"3bafff") forState:UIControlStateNormal];
    connetBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
    connetBtn.layer.borderWidth = 1.f;
    connetBtn.layer.cornerRadius = 6.f;
    [connetBtn addTarget:self action:@selector(connectTa) forControlEvents:UIControlEventTouchUpInside];
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
    
    reaciveOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    reaciveOrder.frame = CGRectMake(20, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
    [reaciveOrder setTitle:@"接单" forState:UIControlStateNormal];
    [reaciveOrder setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [reaciveOrder setBackgroundColor:colorWithHexString(@"3cafff")];
    reaciveOrder.layer.masksToBounds = YES;
    reaciveOrder.layer.cornerRadius = 6.f;
    [reaciveOrder addTarget:self action:@selector(reaciveOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:reaciveOrder];
}

- (void)createDatePicker
{
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 101;
    [self.view addSubview:bgView];
    
    originDate = [NSDate date];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-40, SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = colorWithHexString(@"ffffff");
    titleLabel.text = @"请选择到达时间";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)-1, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [bgView addSubview:line];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    datePicker.backgroundColor = colorWithHexString(@"ffffff");
    datePicker.minimumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:datePicker];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"ffffff");
    [bgView addSubview:toolView];
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = 10001;
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
    // cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.tag = 10002;
    [toolView addSubview:cancelBtn];
}

- (void)dateChange:(UIDatePicker *)picker
{
    // 获取分钟数
    //timeInterval = [picker.date timeIntervalSinceDate:originDate];
    timeInterval2 = [picker.date timeIntervalSince1970];
}

#pragma mark -
#pragma mark 事件处理
- (void)requestDetail
{
    /**获取详情**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairDetail:[NSString stringWithFormat:@"%@",_repair_id]];
}

- (void)evaluate
{
    BXTEvaluationViewController *evaluationVC = [[BXTEvaluationViewController alloc] initWithRepairID:[NSString stringWithFormat:@"%ld",(long)repairDetail.repairID]];
    [self.navigationController pushViewController:evaluationVC animated:YES];
}

//联系报修者
- (void)connectTa
{
    NSDictionary *repaier_fault_dic = repairDetail.repair_fault_arr[0];
    [self handleUserInfo:repaier_fault_dic];
}

//联系其他维修者
- (void)contactRepairer:(UIButton *)btn
{
    NSDictionary *userDic = repairDetail.repair_user_arr[btn.tag];
    [self handleUserInfo:userDic];
}

//开始维修
- (void)startRepairAction
{
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request startRepair:[NSString stringWithFormat:@"%ld",(long)repairDetail.repairID]];
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
    conversationVC.userName = userInfo.name;
    conversationVC.title = userInfo.name;
    [self.navigationController pushViewController:conversationVC animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)reaciveOrderBtn
{
    /**接单**/
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

- (void)tapGesture:(UITapGestureRecognizer *)tapGR
{
    UIView *tapView = [tapGR view];
    [self loadMWPhotoBrowser:tapView.tag];
}

- (void)mobileClick
{
    NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", repairDetail.visitmobile];
    UIWebView *callWeb = [[UIWebView alloc] init];
    [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
    [self.view addSubview:callWeb];
}

- (NSMutableArray *)containAllPhotosForMWPhotoBrowser
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in repairDetail.fault_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    
    for (NSDictionary *dictionary in repairDetail.fixed_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    
    for (NSDictionary *dictionary in repairDetail.evaluation_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

- (void)loadMWPhotoBrowser:(NSInteger)index
{
    self.mwPhotosArray = [self containAllPhotosForMWPhotoBrowser];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    
    browser.titlePreNumStr = [NSString stringWithFormat:@"%d%d%d", (int)repairDetail.fault_pic.count, (int)repairDetail.fixed_pic.count, (int)repairDetail.evaluation_pic.count];
    
    [self.navigationController pushViewController:browser animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (datePicker)
        {
            [datePicker removeFromSuperview];
            datePicker = nil;
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

- (void)datePickerBtnClick:(UIButton *)button
{
    if (button.tag == 10001)
    {
        //NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)timeInterval2/60+1];
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)timeInterval2];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request reaciveOrderID:[NSString stringWithFormat:@"%ld",(long)repairDetail.repairID]
                    arrivalTime:timeStr
                      andIsGrad:NO];
    }
    datePicker = nil;
    [bgView removeFromSuperview];
}

#pragma mark -
#pragma mark 代理
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
        
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request reaciveOrderID:[NSString stringWithFormat:@"%ld",(long)repairDetail.repairID]
                    arrivalTime:timeStr
                      andIsGrad:NO];
    }
}

- (NSMutableArray *)containAllArray
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in repairDetail.fault_pic)
    {
        [photos addObject:dictionary];
    }
    
    for (NSDictionary *dictionary in repairDetail.fixed_pic)
    {
        [photos addObject:dictionary];
    }
    
    for (NSDictionary *dictionary in repairDetail.evaluation_pic)
    {
        [photos addObject:dictionary];
    }
    
    return photos;
}

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    LogRed(@"........%@", dic);
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairDetail && data.count > 0)
    {
        NSDictionary *dictionary = data[0];
        
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        DCObjectMapping *map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"repairID" onClass:[BXTRepairDetailInfo class]];
        [config addObjectMapping:map];
        
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTRepairDetailInfo class] andConfiguration:config];
        repairDetail = [parser parseDictionary:dictionary];
        
        NSDictionary *repaier_fault_dic = repairDetail.repair_fault_arr[0];
        NSString *headURL = [repaier_fault_dic objectForKey:@"head_pic"];
        [headImgView sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        repairerName.text = [repaier_fault_dic objectForKey:@"name"];
        repairerDetail.text = [repaier_fault_dic objectForKey:@"role"];
        
        repairID.text = [NSString stringWithFormat:@"工单号:%@",repairDetail.orderid];
        
        NSTimeInterval timeInterval = [repairDetail.repair_time doubleValue];
        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        time.text = [NSString stringWithFormat:@"报修时间:%@",currentDateStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:repairDetail.visitmobile];
        [attributedString addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:NSMakeRange(0, 11)];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 11)];
        mobile.attributedText = attributedString;
        
        CGSize group_size = MB_MULTILINE_TEXTSIZE(repairDetail.subgroup_name, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH, 40.f), NSLineBreakByWordWrapping);
        group_size.width += 10.f;
        group_size.height = CGRectGetHeight(groupName.frame);
        groupName.frame = CGRectMake(SCREEN_WIDTH - group_size.width - 15.f, CGRectGetMinY(groupName.frame), group_size.width, group_size.height);
        groupName.text = repairDetail.subgroup_name;
        if (repairDetail.order_type == 1)
        {
            orderType.text = @"";
        }
        else if (repairDetail.order_type == 2)
        {
            orderType.text = @"协作工单";
        }
        else if (repairDetail.order_type == 3)
        {
            orderType.text = @"特殊工单";
        }
        else if (repairDetail.order_type == 4)
        {
            orderType.text = @"超时工单";
        }

        place.text = [NSString stringWithFormat:@"位置:%@-%@",repairDetail.place_name,repairDetail.stores_name];
        faultType.text = [NSString stringWithFormat:@"故障类型:%@",repairDetail.faulttype_name];
        cause.text = [NSString stringWithFormat:@"故障描述:%@",repairDetail.cause];
        
        NSString *str;
        NSRange range;
        if (repairDetail.urgent == 1)
        {
            str = @"等级:紧急";
            range = [str rangeOfString:@"紧急"];
        }
        else
        {
            str = @"等级:一般";
            range = [str rangeOfString:@"一般"];
        }
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
        level.attributedText = attributeStr;
        
        NSString *contents = [NSString stringWithFormat:@"报修内容:%@",repairDetail.notes];
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
                    imgView.tag = i;
                    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
                    [imgView addGestureRecognizer:tapGR];
                    [imagesScrollView addSubview:imgView];
                    i++;
                }
            }
            [scrollView addSubview:imagesScrollView];
            lineView.frame = CGRectMake(15.f, CGRectGetMaxY(notes.frame) + ImageHeight + 20.f + 20.f, SCREEN_WIDTH - 30.f, 1.f);
            
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(notes.frame) + ImageHeight + 20.f + 20.f, SCREEN_WIDTH, StateViewHeight) withRepairState:repairDetail.repairstate withIsRespairing:repairDetail.isRepairing];
            [scrollView addSubview:drawView];
            arrangeTime.frame = CGRectMake(20.f, CGRectGetMaxY(drawView.frame) + 15.f, SCREEN_WIDTH - 40.f, 20.f);

            if (repairDetail.man_hours.length)
            {
                NSString *mm_content = [NSString stringWithFormat:@"维修备注:%@",repairDetail.workprocess];
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
            
            if (repairDetail.repair_user_arr.count > 0)
            {
                [self loadingUsers];
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + ImageHeight + 40.f + StateViewHeight + 40.f + RepairHeight * repairDetail.repair_user_arr.count + 100.f + 200.f/3.f);
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
            
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH, StateViewHeight) withRepairState:repairDetail.repairstate withIsRespairing:repairDetail.isRepairing];
            [scrollView addSubview:drawView];
            arrangeTime.frame = CGRectMake(20.f, CGRectGetMaxY(drawView.frame) + 15.f, SCREEN_WIDTH - 40.f, 20.f);

            if (repairDetail.man_hours.length)
            {
                NSString *mm_content = [NSString stringWithFormat:@"维修备注:%@",repairDetail.workprocess];
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
            
            if (repairDetail.repair_user_arr.count > 0)
            {
                [self loadingUsers];
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + StateViewHeight + 40.f + RepairHeight * repairDetail.repair_user_arr.count + 100.f + 200.f/3.f);
            }
            else
            {
                reaciveOrder.frame = CGRectMake(20, CGRectGetMaxY(drawView.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(reaciveOrder.frame));
            }
        }
        
        if (repairDetail.repairstate == 2 && repairDetail.isRepairing == 2)
        {
            UITabBar *tabbar = [[UITabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50.f, SCREEN_WIDTH, 50.f)];
            tabbar.delegate = self;
            UITabBarItem *leftItem = [[UITabBarItem alloc] initWithTitle:@"增加人员" image:[UIImage imageNamed:@"users"] selectedImage:[UIImage imageNamed:@"users_selected"]];
            leftItem.tag = 101;
            UITabBarItem *rightItem = [[UITabBarItem alloc] initWithTitle:@"维修过程" image:[UIImage imageNamed:@"pen"] selectedImage:[UIImage imageNamed:@"pen_selected"]];
            rightItem.tag = 102;
            [tabbar setItems:@[leftItem,rightItem]];
            [self.view addSubview:tabbar];
        }
        
        if (repairDetail.repairstate != 1)
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
    
}

- (void)loadingUsers
{
    NSTimeInterval repairTime = [repairDetail.dispatching_time doubleValue];
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
        mmProcess.text = [NSString stringWithFormat:@"维修过程:%@",repairDetail.workprocess];
        workTime.text = [NSString stringWithFormat:@"维修工时:%@小时",repairDetail.man_hours];
        lineView.frame = CGRectMake(15.f, CGRectGetMaxY(workTime.frame) + 15.f, SCREEN_WIDTH - 30.f, 1.f);
    }
    maintenanceMan.frame = CGRectMake(20.f, CGRectGetMaxY(lineView.frame) + 10.f, SCREEN_WIDTH - 40.f, 40.f);
    
    for (NSInteger i = 0; i < repairDetail.repair_user_arr.count; i++)
    {
        NSDictionary *userDic = repairDetail.repair_user_arr[i];
        
        UIView *userBack = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(maintenanceMan.frame) + i * 95.f, SCREEN_WIDTH, 95.f)];
        UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 73.3f, 73.3f)];
        [userImgView sd_setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"head_pic"]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        [userBack addSubview:userImgView];

        UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 15.f, CGRectGetWidth(level.frame), 20)];
        userName.textColor = colorWithHexString(@"000000");
        userName.numberOfLines = 0;
        userName.lineBreakMode = NSLineBreakByWordWrapping;
        userName.font = [UIFont boldSystemFontOfSize:16.f];
        userName.text = [userDic objectForKey:@"name"];
        [userBack addSubview:userName];
        
        UILabel *role = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 40.f, CGRectGetWidth(level.frame), 20)];
        role.textColor = colorWithHexString(@"909497");
        role.numberOfLines = 0;
        role.lineBreakMode = NSLineBreakByWordWrapping;
        role.font = [UIFont boldSystemFontOfSize:14.f];
        role.text = [NSString stringWithFormat:@"%@-%@",[userDic objectForKey:@"department"],[userDic objectForKey:@"role"]];
        [userBack addSubview:role];

        if ([[userDic objectForKey:@"id"] isEqualToString:[BXTGlobal getUserProperty:U_BRANCHUSERID]] &&
            repairDetail.repairstate == 2 &&
            repairDetail.isRepairing == 1)
        {
            UIButton *repairNow = [UIButton buttonWithType:UIButtonTypeCustom];
            repairNow.layer.cornerRadius = 4.f;
            repairNow.backgroundColor = colorWithHexString(@"3cafff");
            [repairNow setFrame:CGRectMake(SCREEN_WIDTH - 150.f - 15.f, 22.5f + 10.f, 150.f, 40.f)];
            [repairNow setTitle:@"开始维修" forState:UIControlStateNormal];
            [repairNow setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
            [repairNow addTarget:self action:@selector(startRepairAction) forControlEvents:UIControlEventTouchUpInside];
            [userBack addSubview:repairNow];
        }
        else
        {
            UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
            contact.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            contact.layer.borderWidth = 1.f;
            contact.layer.cornerRadius = 6.f;
            contact.tag = i;
            [contact setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 22.5f + 10.f, 83.f, 40.f)];
            [contact setTitle:@"联系Ta" forState:UIControlStateNormal];
            [contact setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            [contact addTarget:self action:@selector(contactRepairer:) forControlEvents:UIControlEventTouchUpInside];
            [userBack addSubview:contact];
        }
        
        if (i != repairDetail.repair_user_arr.count -1)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, userBack.bounds.size.height - 1.f, SCREEN_WIDTH - 30.f, 1.f)];
            line.backgroundColor = colorWithHexString(@"e2e6e8");
            [userBack addSubview:line];
        }
        
        [scrollView addSubview:userBack];
    }
    
    reaciveOrder.frame = CGRectMake(20, CGRectGetMaxY(maintenanceMan.frame) + repairDetail.repair_user_arr.count * 95.f + 20.f, SCREEN_WIDTH - 40, 50.f);
}

/**
 *  MWPhotoBrowserDelegate
 */
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.mwPhotosArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = self.mwPhotosArray[index];
    return photo;
}

/**
 *  UITabBarDelegate
 */
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 101)
    {
        BXTAddOtherManViewController *addOtherVC = [[BXTAddOtherManViewController alloc] initWithRepairID:[_repair_id integerValue] andWithVCType:DetailType];
        [self.navigationController pushViewController:addOtherVC animated:YES];
    }
    else if (item.tag == 102)
    {
        BXTMaintenanceProcessViewController *maintenanceProcossVC = [[BXTMaintenanceProcessViewController alloc] initWithCause:repairDetail.faulttype_name andCurrentFaultID:repairDetail.faulttype andRepairID:repairDetail.repairID andReaciveTime:repairDetail.start_time];
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
