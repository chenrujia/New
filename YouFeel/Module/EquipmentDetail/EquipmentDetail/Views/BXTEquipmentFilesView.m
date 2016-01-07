//
//  BXTEquipmentFilesView.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTEquipmentFilesView.h"
#import "BXTEquipmentFilesCell.h"
#import "BXTDataRequest.h"
#import "DataModels.h"
#import "BXTTimeFilterViewController.h"
#import "BXTStandardViewController.h"
#import <MJRefresh.h>

@interface BXTEquipmentFilesView () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property(nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) DOPDropDownMenu *DDMenu;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger count;

@end

@implementation BXTEquipmentFilesView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    self.titleArray = @[@"全部", @"时间范围"];
    self.dataArray = [[NSMutableArray alloc] init];
    self.count = 0;
    
    [self showLoadingMBP:@"数据加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request inspection_record_listWithPagesize:@"5" page:@"1"];
    });
    
    [self createUI];
}

- (void)createUI
{
    // 设备操作规范
    UIButton *topBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    topBtnView.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[topBtnView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTStandardViewController *sdvc = [[BXTStandardViewController alloc] init];
        [[self getNavigation] pushViewController:sdvc animated:YES];
    }];
    [self addSubview:topBtnView];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 150, 30)];
    titleView.text = @"设备操作规范";
    titleView.textColor = colorWithHexString(@"#333333");
    titleView.font = [UIFont systemFontOfSize:15];
    [topBtnView addSubview:titleView];
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 15, 9, 15)];
    arrowView.image = [UIImage imageNamed:@"Arrow-right"];
    [topBtnView addSubview:arrowView];
    
    // 添加下拉菜单
    self.DDMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 55) andHeight:44];
    self.DDMenu.delegate = self;
    self.DDMenu.dataSource = self;
    self.DDMenu.layer.borderWidth = 0.5;
    self.DDMenu.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    [self addSubview:self.DDMenu];
    [self.DDMenu selectDefalutIndexPath];
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.DDMenu.frame), SCREEN_WIDTH, self.frame.size.height-CGRectGetMaxY(self.DDMenu.frame)-66) style:UITableViewStyleGrouped];
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
    
    UIButton *MaintenanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 13, SCREEN_WIDTH-80, 40)];
    MaintenanceBtn.backgroundColor = [UIColor whiteColor];
    [MaintenanceBtn setTitle:@"维保作业" forState:UIControlStateNormal];
    [MaintenanceBtn setTitleColor:colorWithHexString(@"#3AB0FE") forState:UIControlStateNormal];
    MaintenanceBtn.layer.cornerRadius = 5;
    [[MaintenanceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"维保作业");
    }];
    [downBgView addSubview:MaintenanceBtn];
}

- (void)getResource
{
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request inspection_record_listWithPagesize:@"5" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage]];
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
    self.currentPage = 1;
    
    if (self.count != 0) {
        if (indexPath.row == 0) {
            NSLog(@"全部");
        } else {
            BXTTimeFilterViewController *tfvc = [[BXTTimeFilterViewController alloc] init];
            tfvc.delegateSignal = [RACSubject subject];
            [tfvc.delegateSignal subscribeNext:^(NSArray *timeArray) {
                NSLog(@"%@", timeArray);
            }];
            [[self getNavigation] pushViewController:tfvc animated:YES];
        }
    }
    self.count++;
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
    BXTEquipmentFilesCell *cell = [BXTEquipmentFilesCell cellWithTableView:tableView];
    cell.inspectionList = self.dataArray[indexPath.section];
    
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
    if (type == Inspection_Record_List && data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            BXTInspectionData *model = [BXTInspectionData modelObjectWithDictionary:dataDict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

@end
