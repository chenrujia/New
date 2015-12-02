//
//  BXTMMLogTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/12/2.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTMMLogTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTMMLogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., 80.f, 30)];
        _titleLabel.textColor = colorWithHexString(@"000000");
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        [self addSubview:_titleLabel];
        
        _remarkTV = [[UITextView alloc] initWithFrame:CGRectMake(110.f, 10.f, SCREEN_WIDTH - 110.f - 10.f, 150.f)];
        _remarkTV.font = [UIFont boldSystemFontOfSize:16.];
        _remarkTV.textColor = colorWithHexString(@"909497");
        _remarkTV.text = @"请输入维修日志";
        [self addSubview:_remarkTV];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
