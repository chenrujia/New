//
//  BXTHistogramFooterView.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTHistogramFooterView.h"

@implementation BXTHistogramFooterView

+ (instancetype)viewForHistogramFooterView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BXTHistogramFooterView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.roundView0.layer.cornerRadius = 5;
    self.roundView01.layer.cornerRadius = 5;
    self.roundView02.layer.cornerRadius = 5;
    self.roundView1.layer.cornerRadius = 5;
    self.roundView2.layer.cornerRadius = 5;
    self.roundView3.layer.cornerRadius = 5;
    self.roundView4.layer.cornerRadius = 5;
    self.roundView5.layer.cornerRadius = 5;
    
    self.checkDetailBtn.layer.borderWidth = 1;
    self.checkDetailBtn.layer.borderColor = [colorWithHexString(@"#95CAF7") CGColor];
    self.checkDetailBtn.layer.cornerRadius = 5;
}

@end
