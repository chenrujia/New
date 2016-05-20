//
//  BXTCertificationManageInfoTableViewCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTProjectInfo.h"

@interface BXTCertificationManageInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *departmentTitleView;
@property (weak, nonatomic) IBOutlet UILabel *positionTitleView;
@property (weak, nonatomic) IBOutlet UILabel *groupTitleView;
@property (weak, nonatomic) IBOutlet UILabel *ProfessionTitleView;

@property (weak, nonatomic) IBOutlet UILabel *typeView;
@property (weak, nonatomic) IBOutlet UILabel *departmentView;
@property (weak, nonatomic) IBOutlet UILabel *positionView;
@property (weak, nonatomic) IBOutlet UILabel *groupView;
@property (weak, nonatomic) IBOutlet UILabel *professionView;

@property (strong, nonatomic) BXTProjectInfo *projectInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
