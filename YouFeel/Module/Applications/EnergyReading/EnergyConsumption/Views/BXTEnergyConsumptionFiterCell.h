//
//  BXTEnergyConsumptionFiterCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/6/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTEnergyConsumptionFiterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
