//
//  BXTRankingCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTRankingData.h"

@interface BXTRankingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankingView;
@property (weak, nonatomic) IBOutlet UILabel *integralView;

+ (instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) BXTRankingData *ranking;

@end
