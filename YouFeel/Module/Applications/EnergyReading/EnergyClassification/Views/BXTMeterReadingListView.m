//
//  BXTMeterReadingListView.m
//  YouFeel
//
//  Created by Jason on 16/7/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingListView.h"
#import "BXTHeaderFile.h"
#import "BXTEnergyMeterListInfo.h"
#import "BXTEnergyReadingFilterInfo.h"
#import "BXTEnergyRecordTableViewCell.h"
#import "BXTMeterReadingRecordViewController.h"
#import "UIView+Nav.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "BXTDataRequest.h"

@interface BXTMeterReadingListView () <BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *currentTable;
@property (nonatomic, copy) NSString *introInfo;

@end

@implementation BXTMeterReadingListView

- (instancetype)initWithFrame:(CGRect)frame
                   energyType:(NSString *)energy_type
                    checkType:(NSString *)check_type
                    priceType:(NSString *)price_type
              filterCondition:(NSString *)filter_condition
                   searchName:(NSString *)search_name
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.energyType = energy_type;
        self.checkType = check_type;
        self.priceType = price_type;
        self.filterCondition = filter_condition;
        self.searchName = search_name;
        self.placeID = @"";
        self.datasource = [NSMutableArray array];
        
        self.currentTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.currentTable.rowHeight = 106.f;
        self.currentTable.delegate = self;
        self.currentTable.dataSource = self;
        [self addSubview:self.currentTable];
        
        self.currentPage = 1;
        __weak __typeof(self) weakSelf = self;
        self.currentTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf requestDatasource];
        }];
        self.currentTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage++;
            [weakSelf requestDatasource];
        }];
        
        [self requestDatasource];
        
        //获取筛选条件
        BXTDataRequest *filterRequest = [[BXTDataRequest alloc] initWithDelegate:self];
        [filterRequest energyMeasuremenLevelListsWithType:self.energyType];
    }
    return self;
}

- (void)changeCheckType:(NSString *)checkType
{
    self.checkType = checkType;
    [self requestDatasource];
}

- (void)changePriceType:(NSString *)priceType
{
    self.priceType = priceType;
    [self requestDatasource];
}

- (void)changePlaceID:(NSString *)placeID
{
    self.placeID = placeID;
    [self requestDatasource];
}

- (void)changeFilterCondition:(NSString *)filterCondition
{
    self.filterCondition = filterCondition;
    [self requestDatasource];
}

- (void)requestDatasource
{
    [BXTGlobal showLoadingMBP:@"加载中..."];
    
    //获取能源列表数据
    BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
    [dataRequest energyMeterListsWithType:self.energyType checkType:self.checkType priceType:self.priceType placeID:self.placeID measurementPath:self.filterCondition searchName:self.searchName page:self.currentPage];
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTEnergyRecordTableViewCell *cell = [BXTEnergyRecordTableViewCell cellWithTableView:tableView];
    
    cell.listInfo = self.datasource[indexPath.row];
    @weakify(self);
    [[cell.starView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 收藏按钮设置
        self.introInfo = [cell.listInfo.is_collect integerValue] == 1 ? @"取消收藏成功" : @"收藏成功";
        
        [BXTGlobal showLoadingMBP:@"加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterFavoriteAddWithAboutID:cell.listInfo.energyMeterID delIDs:@""];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BXTMeterReadingRecordViewController *mrrvc = [[BXTMeterReadingRecordViewController alloc] init];
    BXTEnergyMeterListInfo *listInfo = self.datasource[indexPath.row];
    mrrvc.transID = listInfo.energyMeterID;
    [[self navigation] pushViewController:mrrvc animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    [self.currentTable.mj_header endRefreshing];
    [self.currentTable.mj_footer endRefreshing];
    NSDictionary *dic = (NSDictionary *)response;
    if (type == EnergyMeterLists)
    {
        NSArray *data = dic[@"data"];
        if (self.currentPage == 1 && self.datasource.count > 0)
        {
            [self.datasource removeAllObjects];
        }
        NSMutableArray *listArray = [[NSMutableArray alloc] init];
        [BXTEnergyMeterListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"energyMeterID":@"id"};
        }];
        [listArray addObjectsFromArray:[BXTEnergyMeterListInfo mj_objectArrayWithKeyValuesArray:data]];
        [self.datasource addObjectsFromArray:listArray];
        [self.currentTable reloadData];
    }
    else if (type == EnergyMeasuremenLevelLists)
    {
        NSArray *data = dic[@"data"];
        NSMutableArray *filterDataArray = [[NSMutableArray alloc] init];
        [BXTEnergyReadingFilterInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"filterID":@"id"};
        }];
        [filterDataArray addObjectsFromArray:[BXTEnergyReadingFilterInfo mj_objectArrayWithKeyValuesArray:data]];
        self.energyFilterArray = filterDataArray;
    }
    else if (type == MeterFavoriteAdd && [dic[@"returncode"] integerValue] == 0)
    {
        @weakify(self);
        [BXTGlobal showText:self.introInfo completionBlock:^{
            @strongify(self);
            [self requestDatasource];
        }];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    [self.currentTable.mj_header endRefreshing];
    [self.currentTable.mj_footer endRefreshing];
}

@end
