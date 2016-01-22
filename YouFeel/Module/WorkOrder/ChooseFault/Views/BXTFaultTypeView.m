//
//  BXTFaultTypeView.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTFaultTypeView.h"
#import "BXTHeaderForVC.h"

@implementation BXTFaultTypeView

- (void)awakeFromNib {
    // Initialization code
    
    self.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.layer.borderWidth = 0.5;
}

@end
