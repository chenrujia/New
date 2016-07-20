//
//  BXTMeterReadingHeaderCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTMeterReadingInfo.h"
#import "BXTEnergyConsumptionInfo.h"

@interface BXTMeterReadingHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *codeView;
@property (weak, nonatomic) IBOutlet UILabel *rateView;
@property (weak, nonatomic) IBOutlet UILabel *stateView;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeView;

@property (weak, nonatomic) IBOutlet UIImageView *NFCImage;
@property (weak, nonatomic) IBOutlet UIImageView *scanImage;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

/** ---- 新建抄表 ---- */
@property (nonatomic, strong) BXTMeterReadingInfo *meterReadingInfo;
/** ---- 能耗计算 ---- */
@property (nonatomic, strong) BXTEnergyConsumptionInfo *energyConsumptionInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
