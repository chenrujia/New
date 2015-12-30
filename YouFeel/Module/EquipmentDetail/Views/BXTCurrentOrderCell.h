//
//  BXTCurrentOrderCell.h
//  YouFeel
//
//  Created by 满孝意 on 15/12/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTHeaderFile.h"

@interface BXTCurrentOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationView;
@property (weak, nonatomic) IBOutlet UILabel *typeView;
@property (weak, nonatomic) IBOutlet UILabel *describeView;
@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
