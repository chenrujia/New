//
//  BXTManagerOMTableViewCell.h
//  YouFeel
//
//  Created by Jason on 15/11/26.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTRepairInfo.h"

@interface BXTManagerOMTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel *orderNumber;
@property (nonatomic ,strong) UILabel *place;
@property (nonatomic ,strong) UILabel *faultType;
@property (nonatomic ,strong) UILabel *cause;
@property (nonatomic ,strong) UIView  *line;
@property (nonatomic ,strong) UILabel *groupName;
@property (nonatomic ,strong) UILabel *orderType;
@property (nonatomic ,strong) UILabel *repairTime;

- (void)refreshSubViewsFrame:(BXTRepairInfo *)repairInfo;

@end
