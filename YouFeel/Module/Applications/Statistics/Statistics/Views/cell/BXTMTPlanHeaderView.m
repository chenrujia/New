//
//  BXTMTPlanHeaderView.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTPlanHeaderView.h"

@implementation BXTMTPlanHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.image1.layer.cornerRadius = 5;
    self.image2.layer.cornerRadius = 5;
    self.image3.layer.cornerRadius = 5;
    self.image4.layer.cornerRadius = 5;
}

@end
