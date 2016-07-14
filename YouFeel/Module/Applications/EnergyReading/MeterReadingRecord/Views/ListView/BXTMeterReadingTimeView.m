//
//  BXTMeterReadingTimeView.m
//  HHHHHH
//
//  Created by 满孝意 on 16/7/4.
//  Copyright © 2016年 满孝意. All rights reserved.
//

#import "BXTMeterReadingTimeView.h"

@implementation BXTMeterReadingTimeView

+ (instancetype)viewForMeterReadingTime
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingTimeView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.roundView.layer.cornerRadius = self.roundView.frame.size.width / 2;
}

@end
