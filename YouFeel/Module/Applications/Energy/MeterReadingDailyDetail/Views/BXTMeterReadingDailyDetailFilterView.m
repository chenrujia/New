//
//  BXTMeterReadingDailyDetailFilterView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingDailyDetailFilterView.h"
#import "BXTGlobal.h"

@implementation BXTMeterReadingDailyDetailFilterView

+ (instancetype)viewForBXTMeterReadingDailyDetailFilterView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingDailyDetailFilterView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 10;
    
    self.lastMonthBtn.layer.borderWidth = 1;
    self.lastMonthBtn.layer.borderColor = [colorWithHexString(@"#95CAF7") CGColor];
    self.lastMonthBtn.layer.cornerRadius = 5;
    
    self.nextMonthBtn.layer.borderWidth = 1;
    self.nextMonthBtn.layer.borderColor = [colorWithHexString(@"#95CAF7") CGColor];
    self.nextMonthBtn.layer.cornerRadius = 5;
}


@end
