//
//  BXTRepairDetailViewController.m
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairDetailViewController.h"
#import "BXTDrawView.h"
#import "BXTRepairDetailInfo.h"
#import "BXTHeaderForVC.h"
#import "UIImageView+WebCache.h"
#import "BXTEvaluationViewController.h"

#define ImageWidth      73.3f
#define ImageHeight     73.3f
#define StateViewHeight 90.f
#define RepairHeight    95.f

@interface BXTRepairDetailViewController ()<BXTDataResponseDelegate>
{
    UILabel      *repairID;
    UILabel      *time;
    UILabel      *place;
    UILabel      *name;
    UILabel      *mobile;
    UILabel      *faultType;
    UILabel      *cause;
    UILabel      *level;
    UILabel      *notes;
    UIButton     *cancelRepair;
    UILabel      *arrangeTime;
    UILabel      *mmProcess;
    UILabel      *workTime;
    UIView       *lineView;
    UILabel      *maintenanceMan;
    CGFloat      contentHeight;
    UIScrollView *scrollView;
}

@property (nonatomic ,strong) UIButton            *evaluationBtn;
@property (nonatomic ,strong) UIView              *evaBackView;
@property (nonatomic ,strong) BXTRepairInfo       *repairInfo;
@property (nonatomic ,strong) BXTRepairDetailInfo *repairDetail;

@end

@implementation BXTRepairDetailViewController

- (instancetype)initWithRepair:(BXTRepairInfo *)repair
{
    self = [super init];
    if (self)
    {
        self.repairInfo = repair;
    }
    return self;
}

- (void)dealloc
{
    LogBlue(@"工单详情被释放了。。。");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    contentHeight = 300;
    [self navigationSetting:@"工单详情" andRightTitle:nil andRightImage:nil];
    [self createSubViews];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HiddenEvaluationBtn" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.evaBackView removeFromSuperview];
        self.evaBackView = nil;
        [self.evaluationBtn removeFromSuperview];
        self.evaluationBtn = nil;
    }];
    
    /**获取报修列表**/
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairDetail:[NSString stringWithFormat:@"%ld",(long)_repairInfo.repairID]];
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
    
    repairID = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, SCREEN_WIDTH - 30.f, 20)];
    repairID.textColor = colorWithHexString(@"000000");
    repairID.font = [UIFont boldSystemFontOfSize:17.f];
    repairID.text = [NSString stringWithFormat:@"工单号:%@",_repairInfo.orderid];
    [scrollView addSubview:repairID];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(repairID.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    time.textColor = colorWithHexString(@"000000");
    time.font = [UIFont boldSystemFontOfSize:17.f];
    time.text = [NSString stringWithFormat:@"报修时间:%@",_repairInfo.repair_time];
    [scrollView addSubview:time];
    
    place = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(time.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    place.textColor = colorWithHexString(@"000000");
    place.font = [UIFont boldSystemFontOfSize:17.f];
    place.text = [NSString stringWithFormat:@"位置:%@",_repairInfo.area];
    [scrollView addSubview:place];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(place.frame) + 10.f, CGRectGetWidth(place.frame), 20)];
    name.textColor = colorWithHexString(@"000000");
    name.font = [UIFont boldSystemFontOfSize:17.f];
    name.text = [NSString stringWithFormat:@"报修人:%@",_repairInfo.fault];
    [scrollView addSubview:name];
    
    mobile = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(name.frame) + 10.f, CGRectGetWidth(name.frame), 20)];
    mobile.textColor = colorWithHexString(@"000000");
    mobile.font = [UIFont boldSystemFontOfSize:17.f];
    mobile.text = [NSString stringWithFormat:@"手机号:%@",_repairInfo.visitmobile];
    [scrollView addSubview:mobile];
    
    faultType = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(mobile.frame) + 10.f, CGRectGetWidth(mobile.frame), 20)];
    faultType.textColor = colorWithHexString(@"000000");
    faultType.font = [UIFont boldSystemFontOfSize:17.f];
    faultType.text = [NSString stringWithFormat:@"故障类型:%ld",(long)_repairInfo.faulttype];
    [scrollView addSubview:faultType];
    
    cause = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(faultType.frame) + 10.f, CGRectGetWidth(faultType.frame), 20)];
    cause.textColor = colorWithHexString(@"000000");
    cause.font = [UIFont boldSystemFontOfSize:17.f];
    cause.text = [NSString stringWithFormat:@"故障描述:%@",_repairInfo.cause];
    [scrollView addSubview:cause];
    
    level = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(cause.frame) + 10.f, CGRectGetWidth(cause.frame), 20)];
    level.textColor = colorWithHexString(@"000000");
    level.font = [UIFont boldSystemFontOfSize:17.f];
    if (_repairInfo.urgent == 2)
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
    maintenanceMan.text = @"维修员:";
    [scrollView addSubview:maintenanceMan];
    
    cancelRepair = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
    [cancelRepair setTitle:@"取消报修" forState:UIControlStateNormal];
    [cancelRepair setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [cancelRepair setBackgroundColor:colorWithHexString(@"3cafff")];
    cancelRepair.layer.masksToBounds = YES;
    cancelRepair.layer.cornerRadius = 6.f;
    @weakify(self);
    [[cancelRepair rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        /**删除工单**/
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request deleteRepair:[NSString stringWithFormat:@"%ld",(long)self.repairDetail.repairID]];
    }];
    [scrollView addSubview:cancelRepair];
}

#pragma mark -
#pragma mark 事件处理
- (void)contactRepairer:(UIButton *)btn
{
    NSDictionary *userDic = self.repairDetail.repair_user_arr[btn.tag];
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [userDic objectForKey:@"out_userid"];
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID]) return;
    
    userInfo.name = [userDic objectForKey:@"name"];
    userInfo.portraitUri = [userDic objectForKey:@"head_pic"];
    
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
    [repairDateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *repairDateStr = [repairDateFormatter stringFromDate:repairDate];
    arrangeTime.text = [NSString stringWithFormat:@"派工时间:%@",repairDateStr];
    if (workTime.hidden)
    {
        lineView.frame = CGRectMake(15.f, CGRectGetMaxY(arrangeTime.frame) + 15.f, SCREEN_WIDTH - 30.f, 1.f);
    }
    else
    {
        mmProcess.text = [NSString stringWithFormat:@"维修备注:%@",_repairDetail.workprocess];
        workTime.text = [NSString stringWithFormat:@"维修工时:%@小时",_repairDetail.man_hours];
        lineView.frame = CGRectMake(15.f, CGRectGetMaxY(workTime.frame) + 15.f, SCREEN_WIDTH - 30.f, 1.f);
    }
    
    maintenanceMan.frame = CGRectMake(20.f, CGRectGetMaxY(lineView.frame) + 10.f, SCREEN_WIDTH - 40.f, 40.f);
    
    for (NSInteger i = 0; i < _repairDetail.repair_user_arr.count; i++)
    {
        NSDictionary *userDic = _repairDetail.repair_user_arr[i];
        
        UIView *userBack = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(maintenanceMan.frame) + i * 95.f, SCREEN_WIDTH, RepairHeight)];
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
        [phone addGestureRecognizer:moblieTap];
        @weakify(self);
        [[moblieTap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            NSDictionary *userDic = self.repairDetail.repair_user_arr[i];
            NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", [userDic objectForKey:@"mobile"]];
            UIWebView *callWeb = [[UIWebView alloc] init];
            [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
            [self.view addSubview:callWeb];
        }];
        [userBack addSubview:phone];
        
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
        
        if (i != _repairDetail.repair_user_arr.count -1)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, userBack.bounds.size.height - 1.f, SCREEN_WIDTH - 30.f, 1.f)];
            line.backgroundColor = colorWithHexString(@"e2e6e8");
            [userBack addSubview:line];
        }
        
        [scrollView addSubview:userBack];
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
        self.repairDetail = [parser parseDictionary:dictionary];
        
        repairID.text = [NSString stringWithFormat:@"工单号:%@",_repairDetail.orderid];
        
        NSTimeInterval timeInterval = [_repairDetail.repair_time doubleValue];
        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        time.text = [NSString stringWithFormat:@"报修时间:%@",currentDateStr];
        if (_repairDetail.stores_name.length)
        {
            place.text = [NSString stringWithFormat:@"位置:%@-%@-%@",_repairDetail.area_name,_repairDetail.place_name,_repairDetail.stores_name];
        }
        else
        {
            place.text = [NSString stringWithFormat:@"位置:%@-%@",_repairDetail.area_name,_repairDetail.place_name];
        }
        name.text = [NSString stringWithFormat:@"报修人:%@",_repairDetail.fault];
        mobile.text = [NSString stringWithFormat:@"手机号:%@",_repairDetail.visitmobile];
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
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
                    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
                    [imgView addGestureRecognizer:tapGR];
                    @weakify(self);
                    [[tapGR rac_gestureSignal] subscribeNext:^(id x) {
                        @strongify(self);
                        self.mwPhotosArray = [self containAllPhotosForMWPhotoBrowser];
                        [self loadMWPhotoBrowserForDetail:i withFaultPicCount:self.repairDetail.fault_pic.count withFixedPicCount:self.repairDetail.fixed_pic.count withEvaluationPicCount:self.repairDetail.evaluation_pic.count];
                    }];
                    [imagesScrollView addSubview:imgView];
                    i++;
                }
            }
            [scrollView addSubview:imagesScrollView];
            
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
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + ImageHeight + 40.f + StateViewHeight + 40.f + RepairHeight * _repairDetail.repair_user_arr.count + 60.f + 200.f/3.f);
                cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(maintenanceMan.frame) + _repairDetail.repair_user_arr.count * 95.f + 20.f, SCREEN_WIDTH - 40, 50.f);
            }
            else
            {
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + ImageHeight + 40.f + StateViewHeight + 40.f);
                cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(drawView.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
            }
        }
        else
        {
            
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH, 90.f) withRepairState:_repairDetail.repairstate withIsRespairing:_repairDetail.isRepairing];
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
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + StateViewHeight + 40.f + RepairHeight * _repairDetail.repair_user_arr.count + 60.f + 200.f/3.f);
                cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(maintenanceMan.frame) + _repairDetail.repair_user_arr.count * 95.f + 20.f, SCREEN_WIDTH - 40, 50.f);
            }
            else
            {
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + StateViewHeight + 40.f);
                cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(drawView.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
            }
        }
        if (_repairDetail.repairstate != 1)
        {
            cancelRepair.hidden = YES;
        }
        if (_repairDetail.repairstate == 3)
        {
            self.evaBackView = [[UIView alloc] initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 200.f/3.f, SCREEN_WIDTH, 200.f/3.f)];
            _evaBackView.backgroundColor = [UIColor blackColor];
            _evaBackView.alpha = 0.6;
            [self.view addSubview:_evaBackView];
            
            self.evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_evaluationBtn setFrame:CGRectMake(0, 0, 200.f, 40.f)];
            [_evaluationBtn setCenter:CGPointMake(SCREEN_WIDTH/2.f,CGRectGetMinY(_evaBackView.frame) + _evaBackView.bounds.size.height/2.f)];
            [_evaluationBtn setTitle:@"发表评价" forState:UIControlStateNormal];
            [_evaluationBtn setTitleColor:colorWithHexString(@"3bb0ff") forState:UIControlStateNormal];
            [_evaluationBtn setBackgroundColor:[UIColor whiteColor]];
            _evaluationBtn.layer.cornerRadius = 4.f;
            _evaluationBtn.layer.masksToBounds = YES;
            @weakify(self);
            [[_evaluationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                BXTEvaluationViewController *evaluationVC = [[BXTEvaluationViewController alloc] initWithRepairID:[NSString stringWithFormat:@"%ld",(long)self.repairDetail.repairID]];
                [self.navigationController pushViewController:evaluationVC animated:YES];
            }];
            [self.view addSubview:_evaluationBtn];
        }
    }
    else if (type == DeleteRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestRepairList" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
