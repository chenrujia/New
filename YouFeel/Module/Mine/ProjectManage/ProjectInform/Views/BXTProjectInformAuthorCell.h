//
//  BXTProjectInformAuthorCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTProjectInformAuthorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *apartmentView;
@property (weak, nonatomic) IBOutlet UILabel *positionView;

@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
