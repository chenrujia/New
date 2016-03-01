//
//  BXTEPSystemRateCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTEPSystemRate.h"

@interface BXTEPSystemRateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sumView;
@property (weak, nonatomic) IBOutlet UILabel *normalView;
@property (weak, nonatomic) IBOutlet UILabel *unableView;

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIView *roundView2;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BXTEPSystemRate *epList;

@end
