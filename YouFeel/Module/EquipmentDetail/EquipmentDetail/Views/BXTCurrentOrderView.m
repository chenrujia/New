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
#import "BXTMaintenanceDetailViewController.h"
#import "BXTTimeFilterViewController.h"
#import "BXTSelectBoxView.h"
#import <MJRefresh.h>
#import "UIView+Nav.h"
#import "BXTNewRepairMtOrderViewController.h"
#import "BXTNewWorkMtOrderViewController.h"

typedef NS_ENUM(NSInteger, OrderType) {
    OrderType_Normal = 5,
    OrderType_Maintenance = 6,
    OrderType_Undown = 7
};

@interface BXTCurrentOrderView () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>
{
    NSArray *comeTimeArray;
    NSDate *originDate;
    
}

@property (nonatomic, assign) NSInteger       currentPage;
@property (nonatomic, strong) UIButton        *bgView;
@property (nonatomic, strong) UIButton        *bgView_fit;
@property (nonatomic, strong) UIView          *pickerBgView;
@property (nonatomic, assign) NSTimeInterval  timeInterval;
@property (nonatomic, strong) NSString        *orderID;
@property (nonatomic, strong) NSArray         *titleArray;
@property (nonatomic, strong) DOPDropDownMenu *DDMenu;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, assign) CGFloat         cellHeight;
@property (nonatomic, copy  ) NSString        *typeStr;
@property (nonatomic, strong) NSArray         *chooseTimeArray;;

@end

@implementation BXTCurrentOrderView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"])
    {
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
    __block __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getResource];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getResource];
    }];
    
    // 新建工单
    UIView *downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-66, SCREEN_WIDTH, 66)];
    downBgView.backgroundColor = colorWithHexString(@"#DFE0E1");
    [self addSubview:downBgView];
    
    UIButton *newOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 13, SCREEN_WIDTH-80, 40)];
    
    newOrderBtn.backgroundColor = [UIColor whiteColor];
    newOrderBtn.layer.cornerRadius = 5;
    @weakify(self);
    [[newOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if ([BXTGlobal shareGlobal].isRepair) {
            BXTNewRepairMtOrderViewController *workOderVC = [[BXTNewRepairMtOrderViewController alloc] init];
            workOderVC.deviceID = self.deviceID;
            workOderVC.delegateSignal = [RACSubject subject];
            [workOderVC.delegateSignal subscribeNext:^(id x) {
                self.currentPage = 1;
                [weakSelf getResource];
            }];
            [[self navigation] pushViewController:workOderVC animated:YES];
        }
        else {
            BXTNewWorkMtOrderViewController *workOderVC = [[BXTNewWorkMtOrderViewController alloc] init];
            workOderVC.deviceID = self.deviceID;
            workOderVC.delegateSignal = [RACSubject subject];
            [workOderVC.delegateSignal subscribeNext:^(id x) {
                self.currentPage = 1;
                [weakSelf getResource];
            }];
            [[self navigation] pushViewController:workOderVC animated:YES];
        }
    }];
    [downBgView addSubview:newOrderBtn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21.f, 21.f)];
    imgView.image = [UIImage imageNamed:@"Small_buttons"];
    [imgView setCenter:CGPointMake(newOrderBtn.bounds.size.width/2.f - 24.f, newOrderBtn.bounds.size.height/2.f)];
    [newOrderBtn addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80.f, 40.f)];
    titleLabel.text = @"新建工单";
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.textColor = colorWithHexString(@"3cafff");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(newOrderBtn.bounds.size.width/2.f + 22.f, 20.f);
    [newOrderBtn addSubview:titleLabel];
}

- (void)getResource
{
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    
    if ([self.typeStr isEqualToString:@""])
    {
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request deviceRepairListWithOrder:@"" deviceID:self.deviceID timestart:self.chooseTimeArray[0] timeover:_chooseTimeArray[1] pagesize:@"5" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
    }
    else
    {
        [request deviceRepairListWithOrder:self.typeStr deviceID:self.deviceID timestart:@"" timeover:@"" pagesize:@"5" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
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
    self.typeStr = [NSString stringWithFormat:@"%ld", (long)type];
    if (indexPath.row == 3) {
        self.typeStr = @"";
    }
    
    self.currentPage = 1;
    
    if (indexPath.row != 3) {
        [self showLoadingMBP:@"数据加载中..."];
        dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(concurrentQueue, ^{
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request deviceRepairListWithOrder:self.typeStr deviceID:self.deviceID timestart:@"" timeover:@"" pagesize:@"5" page:@"1"];
        });
    } else {
        BXTTimeFilterViewController *tfvc = [[BXTTimeFilterViewController alloc] init];
        tfvc.delegateSignal = [RACSubject subject];
        @weakify(self);
        [tfvc.delegateSignal subscribeNext:^(NSArray *timeArray) {
            @strongify(self);
            self.chooseTimeArray = [[NSArray alloc] initWithArray:timeArray];
            [self showLoadingMBP:@"数据加载中..."];
            dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(concurrentQueue, ^{
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request deviceRepairListWithOrder:@"" deviceID:self.deviceID timestart:timeArray[0] timeover:timeArray[1] pagesize:@"5" page:@"1"];
            });
        }];
        [[self navigation] pushViewController:tfvc animated:YES];
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
    @weakify(self);
    [[cell.receiveOrderView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.orderID = cell.orderList.dataIdentifier;
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request reaciveOrderID:self.orderID];
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
    if (section == 0)
    {
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
    BXTMaintenanceDetailViewController *repairDetailVC = (BXTMaintenanceDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
    [repairDetailVC dataWithRepairID:odModel.dataIdentifier sceneType:MyMaintenanceType];
    repairDetailVC.isComingFromDeviceInfo = YES;
    [[self navigation] pushViewController:repairDetailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (self.currentPage == 1)
    {
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
        if (!IS_IOS_8)
        {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.tableView reloadData];
            });
        }
    }
    else if (type == ReaciveOrder)
    {
        [self showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request deviceRepairListWithOrder:self.typeStr deviceID:self.deviceID timestart:@"" timeover:@"" pagesize:@"5" page:@"1"];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
