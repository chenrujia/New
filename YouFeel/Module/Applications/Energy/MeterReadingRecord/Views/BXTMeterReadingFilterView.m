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
    
    self.layer.cornerRadius = 10;
    
    self.timeBtn.layer.borderColor = [colorWithHexString(@"#5DAFF9") CGColor];
    self.timeBtn.layer.borderWidth = 1;
    self.timeBtn.layer.cornerRadius = 5;
    
    self.filterBtn.layer.cornerRadius = 5;
    
    self.resetBtn.layer.cornerRadius = 5;
}

@end
