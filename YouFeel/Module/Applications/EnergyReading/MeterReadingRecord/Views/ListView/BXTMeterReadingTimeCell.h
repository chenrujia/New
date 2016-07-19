//
//  BXTMeterReadingTimeCell.h
//  HHHHHH
//
//  Created by 满孝意 on 16/7/4.
//  Copyright © 2016年 满孝意. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@property (weak, nonatomic) IBOutlet UILabel *temperatureView;
@property (weak, nonatomic) IBOutlet UILabel *humidityView;
@property (weak, nonatomic) IBOutlet UILabel *windForceView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end