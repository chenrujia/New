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

@property (weak, nonatomic) IBOutlet UILabel *firstView;
@property (weak, nonatomic) IBOutlet UILabel *secondView;
@property (weak, nonatomic) IBOutlet UILabel *thirdView;
@property (weak, nonatomic) IBOutlet UILabel *forthView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
