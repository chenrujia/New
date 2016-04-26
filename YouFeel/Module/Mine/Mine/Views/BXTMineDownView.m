//
//  BXTMineDownView.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMineDownView.h"

@implementation BXTMineDownView

- (void)setMineInfo:(BXTMineInfo *)mineInfo
{
    _mineInfo = mineInfo;
    
    NSString *imageStr1 = mineInfo.binding_weixin == 2 ? @"mine_star" : @"mine_stars";
    self.firstStarView.image = [UIImage imageNamed:imageStr1];
    
    NSString *imageStr2 = mineInfo.binding_shop == 2 ? @"mine_star" : @"mine_stars";
    self.thirdStarView.image = [UIImage imageNamed:imageStr2];
}

- (void)awakeFromNib {
    // Initialization code
    
}

@end
