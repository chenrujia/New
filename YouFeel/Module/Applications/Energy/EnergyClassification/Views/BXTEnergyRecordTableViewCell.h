//
//  BXTEnergyRecordTableViewCell.h
//  YouFeel
//
//  Created by Jason on 16/7/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTEnergyRecordTableViewCell : UITableViewCell

//大图
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//编号
@property (weak, nonatomic) IBOutlet UILabel *energyNumber;
//子表名
@property (weak, nonatomic) IBOutlet UILabel *energySubName;
//能源节点
@property (weak, nonatomic) IBOutlet UILabel *energyNode;
//安装位置
@property (weak, nonatomic) IBOutlet UILabel *energyPlace;

@end
