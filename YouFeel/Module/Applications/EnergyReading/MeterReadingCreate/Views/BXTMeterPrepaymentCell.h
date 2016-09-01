//
//  BXTMeterPrepaymentCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/8/31.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMeterPrepaymentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
