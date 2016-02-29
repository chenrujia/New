//
//  BXTMTPlanListCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTMTPlanList.h"

@interface BXTMTPlanListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumView;
@property (weak, nonatomic) IBOutlet UILabel *statusView;

@property (weak, nonatomic) IBOutlet UILabel *projectView;
@property (weak, nonatomic) IBOutlet UILabel *planView;
@property (weak, nonatomic) IBOutlet UILabel *repairerView;

@property (weak, nonatomic) IBOutlet UILabel *timeView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BXTMTPlanList *planList;

@end
