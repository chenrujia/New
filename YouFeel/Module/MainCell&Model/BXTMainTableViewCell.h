//
//  MainTableViewCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/21.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumView;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeView;
@property (weak, nonatomic) IBOutlet UILabel *orderGroupView;
@property (weak, nonatomic) IBOutlet UILabel *orderStateView;

@property (weak, nonatomic) IBOutlet UILabel *orderTitleView;
@property (weak, nonatomic) IBOutlet UILabel *orderPositionView;
@property (weak, nonatomic) IBOutlet UILabel *orderContentView;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
