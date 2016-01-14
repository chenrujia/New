//
//  BXTMaintenceNotesTableViewCell.m
//  YouFeel
//
//  Created by Jason on 16/1/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenceNotesTableViewCell.h"
#import "BXTPublicSetting.h"

@implementation BXTMaintenceNotesTableViewCell

- (void)awakeFromNib
{
    CGFloat x = (SCREEN_WIDTH - 73.3 * 3)/4.f;
    _image_one_x.constant = x;
    _image_two_x.constant = x;
    _image_three_x.constant = x;
    
    [_imageOne layoutIfNeeded];
    [_imageTwo layoutIfNeeded];
    [_imageThree layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
