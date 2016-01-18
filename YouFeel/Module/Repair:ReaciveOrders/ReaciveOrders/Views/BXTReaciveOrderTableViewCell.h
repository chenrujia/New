//
//  BXTReaciveOrderTableViewCell.h
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTReaciveOrderTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel  *repairID;
@property (nonatomic ,strong) UILabel  *groupName;
@property (nonatomic ,strong) UILabel  *place;
@property (nonatomic ,strong) UILabel  *faultType;
@property (nonatomic ,strong) UILabel  *cause;
@property (nonatomic ,strong) UILabel  *level;
@property (nonatomic ,strong) UILabel  *longTime;
@property (nonatomic ,strong) UILabel  *repairTime;
@property (nonatomic ,strong) UIButton *reaciveBtn;

@end
