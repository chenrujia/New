//
//  BXTMyIntegralThirdCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMyIntegralThirdCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *orderView;
@property (weak, nonatomic) IBOutlet UILabel *percentView;
@property (weak, nonatomic) IBOutlet UILabel *rankingView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
