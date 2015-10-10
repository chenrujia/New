//
//  BXTMaintenanceManTableViewCell.h
//  BXT
//
//  Created by Jason on 15/9/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMaintenanceManTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel *repairID;
@property (nonatomic ,strong) UILabel *time;
@property (nonatomic ,strong) UILabel *place;
@property (nonatomic ,strong) UILabel *cause;
@property (nonatomic ,strong) UILabel *level;
@property (nonatomic ,strong) UIButton *maintenanceProcess;

@end
