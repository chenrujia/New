//
//  BXTEnergyTrendHeaderCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/8/2.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTGlobal.h"

@interface BXTEnergyTrendHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *energyBtn;
@property (weak, nonatomic) IBOutlet UIButton *formatBtn;
@property (weak, nonatomic) IBOutlet UIButton *buildingBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *systemBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLevelView;

@property (weak, nonatomic) IBOutlet UIView *hisBgView;

@property (weak, nonatomic) IBOutlet UILabel *timeView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
