//
//  BXTMyIntegralSecondCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMyIntegralSecondCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankingView;
@property (weak, nonatomic) IBOutlet UILabel *sumView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
