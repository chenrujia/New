//
//  BXTResignTableViewCell.m
//  BXT
//
//  Created by Jason on 15/8/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTResignTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTResignTableViewCell

- (void)awakeFromNib
{
    _codeButton.layer.masksToBounds = YES;
    _codeButton.layer.cornerRadius = 6.f;
    _codeButton.layer.borderWidth = 1.f;
    _codeButton.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
