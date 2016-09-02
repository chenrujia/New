//
//  BXTMeterReadingTimeCell.h
//  HHHHHH
//
//  Created by 满孝意 on 16/7/4.
//  Copyright © 2016年 满孝意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTMeterReadingRecordListInfo.h"

@interface BXTMeterReadingTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *footerView;

/** ---- 尖峰 ---- */
@property (weak, nonatomic) IBOutlet UILabel *peakValueView;
@property (weak, nonatomic) IBOutlet UILabel *peakNumView;
/** ---- 峰段 ---- */
@property (weak, nonatomic) IBOutlet UILabel *apexValueView;
@property (weak, nonatomic) IBOutlet UILabel *apexNumView;
/** ---- 平段 ---- */
@property (weak, nonatomic) IBOutlet UILabel *levelValueView;
@property (weak, nonatomic) IBOutlet UILabel *levelNumView;
/** ---- 谷段 ---- */
@property (weak, nonatomic) IBOutlet UILabel *valleyValueView;
@property (weak, nonatomic) IBOutlet UILabel *valleyNumView;

/** ---- 预付费 ---- */
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *surplusSumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusMoneyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *temperatureView;
@property (weak, nonatomic) IBOutlet UILabel *humidityView;
@property (weak, nonatomic) IBOutlet UILabel *windForceView;

@property (nonatomic, copy) BXTMeterReadingRecordListInfo *info;
;
@property (nonatomic, strong) BXTRecordListsInfo *lists;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
