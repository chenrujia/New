//
//  BXTEnergyStatisticFilterView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyStatisticFilterView.h"
#import "BXTGlobal.h"

@implementation BXTEnergyStatisticFilterView

+ (instancetype)viewForEnergyStatisticFilterView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BXTEnergyStatisticFilterView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.layer.borderWidth = 0.5;
    
    self.lastTimeBtn.layer.borderWidth = 1;
    self.lastTimeBtn.layer.borderColor = [colorWithHexString(@"#95CAF7") CGColor];
    self.lastTimeBtn.layer.cornerRadius = 5;
    
    self.nextTimeBtn.layer.borderWidth = 1;
    self.nextTimeBtn.layer.borderColor = [colorWithHexString(@"#95CAF7") CGColor];
    self.nextTimeBtn.layer.cornerRadius = 5;
    
    [self.thisTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.thisTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 95, 0, -95)];
    
    self.nextTimeBtn.enabled = NO;
    self.nextTimeBtn.alpha = 0.4;
}


@end
