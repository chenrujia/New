//
//  BXTMeterReadingListView.m
//  YouFeel
//
//  Created by Jason on 16/7/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingListView.h"
#import "BXTHeaderFile.h"
#import "BXTEnergyRecordTableViewCell.h"
#import "BXTMeterReadingRecordViewController.h"
#import "UIView+Nav.h"
#import "BXTDataRequest.h"

@interface BXTMeterReadingListView () <BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *currentTable;
@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, copy) NSString *introInfo;

@end

@implementation BXTMeterReadingListView

- (instancetype)initWithFrame:(CGRect)frame datasource:(NSArray *)datasource
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.datasource = datasource;
        
        self.currentTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.currentTable.rowHeight = 106.f;
        self.currentTable.delegate = self;
        self.currentTable.dataSource = self;
        [self addSubview:self.currentTable];

    }
    return self;
}

- (void)setDatasource:(NSArray *)datasource
{
    self.listArray = datasource;
    [self.currentTable reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTEnergyRecordTableViewCell *cell = [BXTEnergyRecordTableViewCell cellWithTableView:tableView];
    
    cell.listInfo = self.listArray[indexPath.row];
    @weakify(self);
    [[cell.starView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 收藏按钮设置
        self.introInfo = [cell.listInfo.is_collect integerValue] == 1 ? @"取消收藏成功" : @"收藏成功";
        
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request energyMeterFavoriteAddWithAboutID:cell.listInfo.energyMeterID delIDs:@""];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMeterReadingRecordViewController *mrrvc = [[BXTMeterReadingRecordViewController alloc] init];
    BXTEnergyMeterListInfo *listInfo = self.listArray[indexPath.row];
    mrrvc.transID = listInfo.energyMeterID;
    [[self navigation] pushViewController:mrrvc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    if (type == MeterFavoriteAdd && [dic[@"returncode"] integerValue] == 0)
    {
        [BXTGlobal showText:self.introInfo view:self completionBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHTABLEVIEWOFLIST object:nil];
        }];
    }
}
- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

@end
