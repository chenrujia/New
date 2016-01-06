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
#import "CYLTabBarController.h"
#import "AppDelegate.h"
#import "BXTOrderDetailViewController.h"

@interface BXTCurrentOrderView () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) DOPDropDownMenu *DDMenu;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation BXTCurrentOrderView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    self.titleArray = @[@"基本信息", @"厂家信息", @"设备参数", @"设备负责人"];
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self showLoadingMBP:@"数据加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request device_repair_listWithDeviceID:@"1"];
    });
    
    // 添加下拉菜单
    self.DDMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    self.DDMenu.delegate = self;
    self.DDMenu.dataSource = self;
    self.DDMenu.layer.borderWidth = 0.5;
    self.DDMenu.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    [self addSubview:self.DDMenu];
    [self.DDMenu selectDefalutIndexPath];
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, self.frame.size.height-44-60) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    
    // 新建工单
    UIView *downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-66, SCREEN_WIDTH, 66)];
    downBgView.backgroundColor = colorWithHexString(@"#DFE0E1");
    [self addSubview:downBgView];
    
    UIButton *newOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 13, SCREEN_WIDTH-80, 40)];
    
    newOrderBtn.backgroundColor = [UIColor whiteColor];
    newOrderBtn.layer.cornerRadius = 5;
    [[newOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BXTRepairWordOrderViewController *workOderVC = [[BXTRepairWordOrderViewController alloc] init];
        [[self navigation] pushViewController:workOderVC animated:YES];
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
    NSLog(@"------ %ld", indexPath.row);
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
        NSLog(@"%@", cell.orderList.orderid);
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
    repairDetailVC.isRejectVC = YES;
    [repairDetailVC dataWithRepairID:[NSString stringWithFormat:@"%@", odModel.dataIdentifier]];
    [[self navigation] pushViewController:repairDetailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
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
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

#pragma mark -
#pragma mark - 方法
- (UINavigationController *)navigation
{
    id rootVC = [AppDelegate appdelegete].window.rootViewController;
    UINavigationController *nav = nil;
    if ([rootVC isKindOfClass:[CYLTabBarController class]])
    {
        CYLTabBarController *tempVC = rootVC;
        nav = [tempVC.viewControllers objectAtIndex:tempVC.selectedIndex];
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        nav = rootVC;
    }
    
    return nav;
}

@end
