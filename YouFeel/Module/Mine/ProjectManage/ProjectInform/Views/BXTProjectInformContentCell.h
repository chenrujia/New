//
//  BXTProjectInformContentCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTPersonInform.h"

@interface BXTProjectInformContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stateView;
@property (weak, nonatomic) IBOutlet UILabel *typeView;
@property (weak, nonatomic) IBOutlet UILabel *apartmentView;
@property (weak, nonatomic) IBOutlet UILabel *positionView;
@property (weak, nonatomic) IBOutlet UILabel *professionView;
@property (weak, nonatomic) IBOutlet UILabel *skillView;

@property (weak, nonatomic) IBOutlet UILabel *apartmentTitleView;
@property (weak, nonatomic) IBOutlet UILabel *positionTitleView;
@property (weak, nonatomic) IBOutlet UILabel *professionTitleView;
@property (weak, nonatomic) IBOutlet UILabel *skillTitleView;

@property (strong, nonatomic) BXTPersonInform *projectInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
