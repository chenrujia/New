//
//  BXTMyIntegralFirstCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMyIntegralFirstCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *lastMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *sameMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextMonthBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
