//
//  BXTMeterReadingFilterView.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingFilterView.h"
#import "BXTGlobal.h"

@implementation BXTMeterReadingFilterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lastMonthBtn.layer.borderWidth = 1;
    self.lastMonthBtn.layer.borderColor = [colorWithHexString(@"#95CAF7") CGColor];
    self.lastMonthBtn.layer.cornerRadius = 5;
    
    self.nextMonthBtn.layer.borderWidth = 1;
    self.nextMonthBtn.layer.borderColor = [colorWithHexString(@"#95CAF7") CGColor];
    self.nextMonthBtn.layer.cornerRadius = 5;
    
    [self.thisMonthBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.thisMonthBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, -45)];
    
    self.nextMonthBtn.enabled = NO;
    self.nextMonthBtn.alpha = 0.4;
}

@end
