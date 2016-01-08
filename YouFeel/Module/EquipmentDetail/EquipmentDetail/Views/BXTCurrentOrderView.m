//
//  BXTCurrentOrderView.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTCurrentOrderView.h"
#import "BXTCurrentOrderCell.h"
#import "BXTHeaderForVC.h"
#import "BXTEquipmentInformCell.h"
#import "DataModels.h"
#import "BXTRepairWordOrderViewController.h"
#import "BXTOrderDetailViewController.h"
#import "BXTTimeFilterViewController.h"
#import "BXTSelectBoxView.h"
#import <MJRefresh.h>

typedef NS_ENUM(NSInteger, OrderType) {
    OrderType_Normal = 5,
    OrderType_Maintenance = 6,
    OrderType_Undown = 7
};

#define Window [UIApplication sharedApplication].keyWindow

@interface BXTCurrentOrderView () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate, BXTBoxSelectedTitleDelegate>
{
    BXTSelectBoxView *boxView;
    NSArray *comeTimeArray;
    NSDate *originDate;
    NSArray *ChooseTimeArray;
}

@property(nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIButton *bgView;
@property (nonatomic, strong) UIButton *bgView_fit;
@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, strong) UIDatePicker   *datePicker;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSString       *orderID;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) DOPDropDownMenu *DDMenu;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *typeStr;

@end

@implementation BXTCurrentOrderView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"]) {
        [timeArray addObject:[NSString stringWithFormat:@"%@分钟内", timeStr]];
    }
    [timeArray addObject:@"自定义"];
    comeTimeArray = timeArray;
    
    
    self.titleArray = @[@"未接优先", @"日常工单优先", @"维保工单优先", @"自定义排序/筛选"];
    self.dataArray = [[NSMutableArray alloc] init];
    
    // 添加下拉菜单
    self.DDMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    self.DDMenu.delegate = self;
    self.DDMenu.dataSource = self;
    self.DDMenu.layer.borderWidth = 0.5;
    self.DDMenu.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    [self addSubview:self.DDMenu];
    [self.DDMenu selectDefalutIndexPath];
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, self.frame.size.height-44-66) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    
    self.currentPage = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self getResource];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getResource];
    }];
    
    
    // 新建工单
    UIView *downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-66, SCREEN_WIDTH, 66)];
    downBgView.backgroundColor = colorWithHexString(@"#DFE0E1");
    [self addSubview:downBgView];
    
    UIButton *newOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 13, SCREEN_WIDTH-80, 40)];
    
    newOrderBtn.backgroundColor = [UIColor whiteColor];
    newOrderBtn.layer.cornerRadius = 5;
    [[newOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BXTRepairWordOrderViewController *workOderVC = [[BXTRepairWordOrderViewController alloc] init];
        [[self getNavigation] pushViewController:workOderVC animated:YES];
    }];
    [downBgView addSubview:newOrderBtn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21.f, 21.f)];
    imgView.image = [UIImage imageNamed:@"Small_buttons"];
    [imgView setCenter:CGPointMake(newOrderBtn.bounds.size.width/2.f - 24.f, newOrderBtn.bounds.size.height/2.f)];
    [newOrderBtn addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.f, 40.f)];
    titleLabel.text = @"新建工单";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textColor = colorWithHexString(@"3cafff");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(newOrderBtn.bounds.size.width/2.f + 22.f, 20.f);
    [newOrderBtn addSubview:titleLabel];
}

- (void)getResource
{
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request deviceRepairListWithOrder:self.typeStr timestart:@"" timeover:@"" pagesize:@"5" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
}

#pragma mark -
#pragma mark - createBXTSelectBoxView
- (void)createBXTSelectBoxView
{
    self.bgView = [[UIButton alloc] initWithFrame:Window.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.6f;
    self.bgView.tag = 101;
    @weakify(self);
    [[self.bgView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.bgView removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
        }];
    }];
    [Window addSubview:self.bgView];
    
    if (boxView)
    {
        [boxView boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray];
        [Window bringSubviewToFront:boxView];
    }
    else
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray markID:nil actionDelegate:self];
        [Window addSubview:boxView];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
    }];
}

- (void)createDatePicker
{
    self.bgView_fit = [[UIButton alloc] initWithFrame:Window.bounds];
    self.bgView_fit.backgroundColor = [UIColor blackColor];
    self.bgView_fit.alpha = 0.6f;
    self.bgView_fit.tag = 101;
    @weakify(self);
    [[self.bgView_fit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.bgView_fit removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            [self.pickerBgView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
        }];
    }];
    [Window addSubview:self.bgView_fit];
    
    originDate = [NSDate date];
    
    
    if (self.pickerBgView) {
        [self.pickerBgView setFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-40, SCREEN_WIDTH, 216+50+40)];
        [Window bringSubviewToFront:self.pickerBgView];
    } else {
        self.pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-40, SCREEN_WIDTH, 216+50+40)];
        self.pickerBgView.backgroundColor = [UIColor whiteColor];
        [Window addSubview:self.pickerBgView];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = colorWithHexString(@"ffffff");
    titleLabel.text = @"请选择到达时间";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.pickerBgView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)-1, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [self.pickerBgView addSubview:line];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 216)];
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    _datePicker.backgroundColor = colorWithHexString(@"ffffff");
    _datePicker.minimumDate = [NSDate date];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [[_datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self);
        // 获取分钟数
        self.timeInterval = [self.datePicker.date timeIntervalSince1970];
    }];
    [self.pickerBgView addSubview:_datePicker];
    
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 216+40, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"ffffff");
    [self.pickerBgView addSubview:toolView];
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showLoadingMBP:@"请稍候..."];
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)self.timeInterval];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        NSString *userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
        NSArray *users = @[userID];
        [request reaciveOrderID:self.orderID
                    arrivalTime:timeStr
                      andUserID:userID
                       andUsers:users
                      andIsGrad:NO];
        [self.bgView_fit removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            [self.pickerBgView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
        }];
    }];
    sureBtn.tag = 10001;
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
    // cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.bgView_fit removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            [self.pickerBgView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
        }];
    }];
    cancelBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.tag = 10002;
    [toolView addSubview:cancelBtn];
}

#pragma mark -
#pragma mark BXTBoxSelectedTitleDelegate
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    [self.bgView removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    }];
    
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *tempStr = (NSString *)obj;
        if ([tempStr isEqualToString:@"自定义"]) {
            [self createDatePicker];
            return;
        }
        NSString *timeStr = [tempStr stringByReplacingOccurrencesOfString:@"分钟内" withString:@""];
        NSTimeInterval timer = [[NSDate date] timeIntervalSince1970] + [timeStr intValue]*50;
        timeStr = [NSString stringWithFormat:@"%.0f", timer];
        
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        NSString *userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
        NSArray *users = @[userID];
        [request reaciveOrderID:self.orderID
                    arrivalTime:timeStr
                      andUserID:userID
                       andUsers:users
                      andIsGrad:NO];
    }
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource & DOPDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return self.titleArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return self.titleArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    NSInteger type;
    switch (indexPath.row) {
        case 0: type = OrderType_Undown; break;
        case 1: type = OrderType_Normal; break;
        case 2: type = OrderType_Maintenance; break;
        default: break;
    }
    self.typeStr = [NSString stringWithFormat:@"%ld", type];
    if (indexPath.row == 3) {
        self.typeStr = @"";
    }
    
    self.currentPage = 1;
    
    if (indexPath.row != 3) {
        [self showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request deviceRepairListWithOrder:self.typeStr timestart:@"" timeover:@"" pagesize:@"5" page:@"1"];
    } else {
        BXTTimeFilterViewController *tfvc = [[BXTTimeFilterViewController alloc] init];
        tfvc.delegateSignal = [RACSubject subject];
        @weakify(self);
        [tfvc.delegateSignal subscribeNext:^(NSArray *timeArray) {
            @strongify(self);
            
            ChooseTimeArray = [[NSArray alloc] initWithArray:timeArray];
            
            [self showLoadingMBP:@"数据加载中..."];
            dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(concurrentQueue, ^{
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request device_repair_listWithOrder:@"" timestart:timeArray[0] timeover:timeArray[1] pagesize:@"5" page:@"1"];
            });
        }];
        [[self getNavigation] pushViewController:tfvc animated:YES];
    }
} 

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTCurrentOrderCell *cell = [BXTCurrentOrderCell cellWithTableView:tableView];
    
    cell.orderList = self.dataArray[indexPath.section];
    
    [[cell.receiveOrderView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"%@", cell.orderList.dataIdentifier);
        self.orderID = cell.orderList.dataIdentifier;
        [self createBXTSelectBoxView];
    }];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    self.cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTCurrentOrderData *odModel = self.dataArray[indexPath.section];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTOrderDetailViewController *repairDetailVC = (BXTOrderDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTOrderDetailViewController"];
    [repairDetailVC dataWithRepairID:[NSString stringWithFormat:@"%@", odModel.dataIdentifier]];
    [[self getNavigation] pushViewController:repairDetailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (self.currentPage == 1) {
        [self.dataArray removeAllObjects];
    }
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Device_Repair_List && data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            BXTCurrentOrderData *odModel = [BXTCurrentOrderData modelObjectWithDictionary:dataDict];
            [self.dataArray addObject:odModel];
        }
        [self.tableView reloadData];
    }
    else if (type == ReaciveOrder)
    {
        [self showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request deviceRepairListWithOrder:self.typeStr timestart:@"" timeover:@"" pagesize:@"5" page:@"1"];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
