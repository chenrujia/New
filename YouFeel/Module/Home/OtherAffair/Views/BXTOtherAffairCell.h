//
//  BXTOtherAffairCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXTOtherAffair;

@interface BXTOtherAffairCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *introView;

@property (strong, nonatomic) BXTOtherAffair *affairModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
