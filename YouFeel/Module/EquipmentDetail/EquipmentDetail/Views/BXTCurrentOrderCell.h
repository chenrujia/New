//
//  BXTCurrentOrderCell.h
//  YouFeel
//
//  Created by 满孝意 on 15/12/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTHeaderFile.h"
#import "DataModels.h"

@interface BXTCurrentOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderIDView;
@property (weak, nonatomic) IBOutlet UILabel *groupView;


@property (weak, nonatomic) IBOutlet UILabel *locationView;
@property (weak, nonatomic) IBOutlet UILabel *repairPersonView;
@property (weak, nonatomic) IBOutlet UILabel *typeView;
@property (weak, nonatomic) IBOutlet UILabel *describeView;

@property (weak, nonatomic) IBOutlet UILabel *endTimeView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UIButton *receiveOrderView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BXTCurrentOrderData *orderList;

@end
