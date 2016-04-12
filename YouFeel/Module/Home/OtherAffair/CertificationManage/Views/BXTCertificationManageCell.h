//
//  BXTCertificationManageCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTProjectInfo.h"

@interface BXTCertificationManageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *phoneView;

@property (strong, nonatomic) BXTProjectInfo *projectInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
