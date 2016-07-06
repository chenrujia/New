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

@implementation BXTMeterReadingListView

- (instancetype)initWithFrame:(CGRect)frame datasource:(NSArray *)datasource
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.datasource = datasource;
        
        UITableView *currentTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [currentTable registerNib:[UINib nibWithNibName:@"BXTEnergyRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"MeterReadingCell"];
        currentTable.rowHeight = 106.f;
        currentTable.delegate = self;
        currentTable.dataSource = self;
        [self addSubview:currentTable];
    }
    return self;
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTEnergyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeterReadingCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

@end
