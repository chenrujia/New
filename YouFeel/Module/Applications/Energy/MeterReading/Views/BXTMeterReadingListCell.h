//
//  BXTMeterReadingListCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMeterReadingListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UITextField *NumTextField;

@property (weak, nonatomic) IBOutlet UILabel *lastValueView;
@property (weak, nonatomic) IBOutlet UILabel *lastNumView;
@property (weak, nonatomic) IBOutlet UILabel *thisValueView;
@property (weak, nonatomic) IBOutlet UILabel *thisNumView;

@property (weak, nonatomic) IBOutlet UIButton *addImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
