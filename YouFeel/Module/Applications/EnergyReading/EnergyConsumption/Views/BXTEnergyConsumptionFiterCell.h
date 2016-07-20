//
//  BXTEnergyConsumptionFiterCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/6/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTEnergyConsumptionInfo.h"

@interface BXTEnergyConsumptionFiterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@property (weak, nonatomic) IBOutlet UILabel *sumValueView;
@property (weak, nonatomic) IBOutlet UILabel *peakValueView;
@property (weak, nonatomic) IBOutlet UILabel *apexValueView;
@property (weak, nonatomic) IBOutlet UILabel *levelValueView;
@property (weak, nonatomic) IBOutlet UILabel *valleyValueView;

@property (nonatomic, strong) BXTEnergyConsumptionInfo *consumpInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
