//
//  BXTRepairTableViewCell.h
//  BXT
//
//  Created by Jason on 15/9/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTRepairTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel  *repairID;
@property (nonatomic ,strong) UILabel  *time;
@property (nonatomic ,strong) UILabel  *place;
@property (nonatomic ,strong) UILabel  *faultType;
@property (nonatomic ,strong) UILabel  *cause;
@property (nonatomic ,strong) UILabel  *level;
@property (nonatomic ,strong) UILabel  *state;
@property (nonatomic ,strong) UILabel  *repairState;
@property (nonatomic ,strong) UIButton *evaButton;
@property (nonatomic ,strong) UIButton *cancelRepair;

@end
