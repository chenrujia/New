//
//  StatisticsCell.m
//  YouFeel
//
//  Created by 满孝意 on 15/11/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "StatisticsCell.h"
#import "BXTPublicSetting.h"

@implementation StatisticsCell

- (void)awakeFromNib {
    // Initialization code
    
    self.detailView.text = [NSString stringWithFormat:@"当前有新版本v%@", IOSAPPVERSION];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
