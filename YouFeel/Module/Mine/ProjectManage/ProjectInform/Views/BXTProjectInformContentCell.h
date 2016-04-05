//
//  BXTProjectInformContentCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTProjectInformContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stateView;
@property (weak, nonatomic) IBOutlet UILabel *typeView;
@property (weak, nonatomic) IBOutlet UILabel *apartmentView;
@property (weak, nonatomic) IBOutlet UILabel *professionView;
@property (weak, nonatomic) IBOutlet UILabel *skillView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
