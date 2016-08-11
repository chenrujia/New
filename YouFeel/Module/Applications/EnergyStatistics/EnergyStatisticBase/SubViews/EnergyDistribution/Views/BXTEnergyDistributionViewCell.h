//
//  BXTEnergyDistributionViewCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/8/10.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTEnergyDistributionInfo.h"

@interface BXTEnergyDistributionViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UILabel *typeView;
@property (weak, nonatomic) IBOutlet UILabel *moneyView;
@property (weak, nonatomic) IBOutlet UILabel *rateView;

@property (weak, nonatomic) IBOutlet UILabel *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UILabel *circleNumView;

@property (weak, nonatomic) IBOutlet UILabel *similarView;
@property (weak, nonatomic) IBOutlet UIImageView *similarImageView;
@property (weak, nonatomic) IBOutlet UILabel *similarNumView;

/** ---- 能效 ---- */
@property (nonatomic, strong) BXTEYDTListsInfo *energyListInfo;
@property (nonatomic, copy) NSString *unit;
/** ---- 费用 ---- */
@property (nonatomic, strong) BXTEYDTListsInfo *moneyListInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
