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

@interface BXTMeterReadingListView ()

@property (nonatomic, strong) UITableView *currentTable;
@property (nonatomic, strong) NSArray *listArray;

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

@end
