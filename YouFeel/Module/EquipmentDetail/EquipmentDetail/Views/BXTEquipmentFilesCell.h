//
//  BXTEquipmentFilesCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTMaintenceInfo.h"

@interface BXTEquipmentFilesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderIDView;
@property (weak, nonatomic) IBOutlet UILabel *typeView;

@property (weak, nonatomic) IBOutlet UILabel *projectView;
@property (weak, nonatomic) IBOutlet UILabel *planView;
@property (weak, nonatomic) IBOutlet UILabel *repairManView;

@property (weak, nonatomic) IBOutlet UILabel *endTimeView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BXTMaintenceInfo *inspectionList;

@end
