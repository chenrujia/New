//
//  BXTEPStateCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTHeaderFile.h"
#import "DataModels.h"

@interface BXTEPStateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *personView;
@property (weak, nonatomic) IBOutlet UILabel *phoneView;
@property (weak, nonatomic) IBOutlet UILabel *descView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BXTEquipmentState *stateList;

@end
