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
    [super awakeFromNib];
    
    _codeButton.layer.masksToBounds = YES;
    _codeButton.layer.cornerRadius = 4.f;
    _codeButton.layer.borderWidth = 1.f;
    _codeButton.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
    
    _boyBtn.layer.masksToBounds = YES;
    _boyBtn.layer.cornerRadius = 4.f;
    _boyBtn.layer.borderWidth = 1.f;
    _boyBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    
    _girlBtn.layer.masksToBounds = YES;
    _girlBtn.layer.cornerRadius = 4.f;
    _girlBtn.layer.borderWidth = 1.f;
    _girlBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
