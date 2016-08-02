//
//  BXTEnergySurveyViewCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTEnergySurveyInfo.h"
#import "BXTEnergyDistributionInfo.h"

@interface BXTEnergySurveyViewCell : UITableViewCell

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

#pragma mark -
#pragma mark - 能效概况
/** ---- 总数据 ---- */
@property (nonatomic, strong) BXTEySyTotalInfo *totalInfo;
/** ---- 电 ---- */
@property (nonatomic, strong) BXTEySyEleInfo *eleInfo;
/** ---- 水 ---- */
@property (nonatomic, strong) BXTEySyWatInfo *watInfo;
/** ---- 燃气 ---- */
@property (nonatomic, strong) BXTEySyTheInfo *theInfo;
/** ---- 热能 ---- */
@property (nonatomic, strong) BXTEySyGasInfo *gasInfo;

#pragma mark -
#pragma mark - 能效分布
/** ---- 能效 ---- */
@property (nonatomic, strong) BXTEYDTListsInfo *energyListInfo;
@property (nonatomic, copy) NSString *unit;
/** ---- 费用 ---- */
@property (nonatomic, strong) BXTEYDTListsInfo *moneyListInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
