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

@interface BXTOrderDetailViewController ()<BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate,UITabBarDelegate>

@property (nonatomic ,strong) BXTSelectBoxView    *boxView;
@property (nonatomic ,strong) NSString            *repair_id;
@property (nonatomic ,strong) NSMutableArray      *manIDArray;
@property (nonatomic ,strong) NSArray             *comeTimeArray;
@property (nonatomic ,strong) UIDatePicker        *datePicker;
@property (nonatomic ,strong) UIView              *bgView;
@property (nonatomic ,assign) NSTimeInterval      timeInterval;

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
    if (self.isRejectVC)
    {
        [self navigationSetting:@"工单详情" andRightTitle:@"关闭工单" andRightImage:nil];
    }
    else
    {
        [self navigationSetting:@"工单详情" andRightTitle:nil andRightImage:nil];
    }
    _connectTa.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
    _connectTa.layer.borderWidth = 1.f;
    _connectTa.layer.cornerRadius = 6.f;
    _groupName.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    _groupName.layer.borderWidth = 1.f;
    _groupName.layer.cornerRadius = 4.f;
    _reaciveOrder.layer.masksToBounds = YES;
    _reaciveOrder.layer.cornerRadius = 6.f;
    
    self.manIDArray = [[NSMutableArray alloc] init];
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

- (void)createDatePicker
{
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    self.bgView.tag = 101;
    [self.view addSubview:self.bgView];
    
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
        self.timeInterval = [self.datePicker.date timeIntervalSince1970];
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
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)self.timeInterval];
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
- (IBAction)reaciveBtn:(id)sender
{
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
}

- (void)requestDetail
{
    /**获取详情**/
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairDetail:[NSString stringWithFormat:@"%@",_repair_id]];
}

- (void)loadingUsers
{
    NSString *repairDateStr = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.dispatching_time];
    _arrangeTime.text = [NSString stringWithFormat:@"派工时间:%@",repairDateStr];
    //是否填写过维修过程
    if (!_workTime.hidden)
    {
        _mmProcess.text = [NSString stringWithFormat:@"维修备注:%@",self.repairDetail.workprocess];
        [_mmProcess layoutIfNeeded];
        _workTime.text = [NSString stringWithFormat:@"维修工时:%@小时",self.repairDetail.man_hours];
        NSString *time_str = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.end_time];
        _completeTime.text = [NSString stringWithFormat:@"完成时间:%@",time_str];
    }
    else
    {
        _line_two_top.constant = 10.f;
        [_contentView layoutIfNeeded];
    }
    
    NSInteger count = self.repairDetail.repair_user_arr.count;
    if (count == 0)
    {
        _lineTwo.hidden = YES;
        _maintenanceMan.hidden = YES;
        if (CGRectGetMaxY(_arrangeTime.frame) + 20.f + 100.f < SCREEN_HEIGHT - KNAVIVIEWHEIGHT)
        {
            _sco_content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT;
        }
        [_contentView layoutIfNeeded];
        return;
    }
    //根据count的个数动态调整sco_content_height
    _sco_content_height.constant = CGRectGetMaxY(_maintenanceMan.frame) + RepairHeight * count + 60.f;
    [_contentView layoutIfNeeded];
    for (NSInteger i = 0; i < self.repairDetail.repair_user_arr.count; i++)
    {
        NSDictionary *userDic = self.repairDetail.repair_user_arr[i];
        
        [self.manIDArray addObject:userDic[@"id"]];
        
        UIView *userBack = [self viewForUser:i andMaintenanceMaxY:CGRectGetMaxY(_maintenanceMan.frame) andLevelWidth:CGRectGetWidth(_level.frame)];
        [_contentView addSubview:userBack];
    }
    //如果此时sco_content_height不如屏幕大
    if (CGRectGetMaxY(_maintenanceMan.frame) + RepairHeight * count < SCREEN_HEIGHT - KNAVIVIEWHEIGHT)
    {
        _sco_content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT;
    }
    [_contentView layoutIfNeeded];
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
        BXTMaintenanceProcessViewController *maintenanceProcossVC = [[BXTMaintenanceProcessViewController alloc] initWithCause:self.repairDetail.faulttype_name andCurrentFaultID:self.repairDetail.faulttype andRepairID:self.repairDetail.repairID andReaciveTime:self.repairDetail.start_time];
        __weak BXTOrderDetailViewController *weakSelf = self;
        maintenanceProcossVC.BlockRefresh = ^() {
            [weakSelf requestDetail];
        };
        [self.navigationController pushViewController:maintenanceProcossVC animated:YES];
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
        [request reaciveOrderID:[NSString stringWithFormat:@"%ld",(long)self.repairDetail.repairID]
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
    LogRed(@"dic.....%@",dic);
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairDetail && data.count > 0)
    {
        NSDictionary *dictionary = data[0];
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        DCObjectMapping *map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"repairID" onClass:[BXTRepairDetailInfo class]];
        [config addObjectMapping:map];
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTRepairDetailInfo class] andConfiguration:config];
        self.repairDetail = [parser parseDictionary:dictionary];
        
        //各种赋值
        NSDictionary *repaier_fault_dic = self.repairDetail.repair_fault_arr[0];
        NSString *headURL = [repaier_fault_dic objectForKey:@"head_pic"];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        _repairerName.text = [repaier_fault_dic objectForKey:@"name"];
        _repairerDetail.text = [repaier_fault_dic objectForKey:@"role"];
        _repairID.text = [NSString stringWithFormat:@"工单号:%@",self.repairDetail.orderid];
        NSString *currentDateStr = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.repair_time];
        _time.text = [NSString stringWithFormat:@"报修时间:%@",currentDateStr];
        if (self.repairDetail.visitmobile.length == 0)
        {
            _mobile.text = @"暂无";
        }
        else
        {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.repairDetail.visitmobile];
            [attributedString addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:NSMakeRange(0, 11)];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 11)];
            _mobile.attributedText = attributedString;
        }
        
        
        //动态计算groupName宽度
        NSString *group_name = self.repairDetail.subgroup_name.length > 0 ? self.repairDetail.subgroup_name : @"其他";
        CGSize group_size = MB_MULTILINE_TEXTSIZE(group_name, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH, 40.f), NSLineBreakByWordWrapping);
        _group_name_width.constant = group_size.width + 10;
        _groupName.text = group_name;
        [_groupName layoutIfNeeded];
        if (self.repairDetail.order_type == 1)
        {
            _orderType.text = @"";
        }
        else if (self.repairDetail.order_type == 2)
        {
            _orderType.text = @"协作工单";
        }
        else if (self.repairDetail.order_type == 3)
        {
            _orderType.text = @"特殊工单";
        }
        else if (self.repairDetail.order_type == 4)
        {
            _orderType.text = @"超时工单";
        }
        if (self.repairDetail.stores_name.length)
        {
            _place.text = [NSString stringWithFormat:@"位置:%@-%@-%@",self.repairDetail.area_name,self.repairDetail.place_name,self.repairDetail.stores_name];
        }
        else
        {
            _place.text = [NSString stringWithFormat:@"位置:%@-%@",self.repairDetail.area_name,self.repairDetail.place_name];
        }
        _faultType.text = [NSString stringWithFormat:@"故障类型:%@",self.repairDetail.faulttype_name];
        _cause.text = [NSString stringWithFormat:@"故障描述:%@",self.repairDetail.cause];
        if (self.repairDetail.urgent == 2)
        {
            _level.text = @"等级:一般";
        }
        else
        {
            NSString *str = @"等级:紧急";
            NSRange range = [str rangeOfString:@"紧急"];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
            _level.attributedText = attributeStr;
        }
        _notes.text = [NSString stringWithFormat:@"报修内容:%@",self.repairDetail.notes];
        [_notes layoutIfNeeded];
        
        NSArray *imgArray = [self containAllArray];
        if (imgArray.count > 0)
        {
            NSInteger i = 0;
            _images_scrollview.contentSize = CGSizeMake((ImageWidth + 25) * imgArray.count + 25.f, ImageHeight);
            for (NSDictionary *dictionary in imgArray)
            {
                if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
                {
                    UIImageView *imgView = [self imageViewWith:i andDictionary:dictionary];
                    [_images_scrollview addSubview:imgView];
                    i++;
                }
            }
            [_contentView layoutIfNeeded];
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineOne.frame) + 10, SCREEN_WIDTH, StateViewHeight) withRepairState:self.repairDetail.repairstate withIsRespairing:self.repairDetail.isRepairing];
            [_contentView addSubview:drawView];
            
            if (!self.repairDetail.man_hours.length)
            {
                _mmProcess.hidden = YES;
                _workTime.hidden = YES;
                _completeTime.hidden = YES;
            }
            [self loadingUsers];
        }
        else
        {
            _line_one_top.constant = 10.f;
            [_contentView layoutIfNeeded];
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineOne.frame) + 10, SCREEN_WIDTH, StateViewHeight) withRepairState:self.repairDetail.repairstate withIsRespairing:self.repairDetail.isRepairing];
            [_contentView addSubview:drawView];
            
            if (!self.repairDetail.man_hours.length)
            {
                _mmProcess.hidden = YES;
                _workTime.hidden = YES;
                _completeTime.hidden = YES;
            }
            [self loadingUsers];
        }
        if (self.repairDetail.repairstate == 2 && self.repairDetail.isRepairing == 2 && self.repairDetail.order_type != 3)
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
            }
        }
        
        if (self.repairDetail.repairstate != 1)
        {
            _reaciveOrder.hidden = YES;
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
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
