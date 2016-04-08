//
//  BXTProjectCertificationCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXTMyProject;

@interface BXTProjectCertificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *stateView;

@property (strong, nonatomic) BXTMyProject *myProject;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
