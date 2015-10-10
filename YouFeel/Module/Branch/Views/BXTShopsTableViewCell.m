//
//  BXTShopsTableViewCell.m
//  BXT
//
//  Created by Jason on 15/8/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTShopsTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTShopsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"ffffff");
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., 200.f, 30)];
        _titleLabel.textColor = colorWithHexString(@"000000");
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.];
        [self addSubview:_titleLabel];
        
        _checkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 13.f - 20.f, 20, 13, 10)];
        _checkImgView.image = [UIImage imageNamed:@"checktransparent"];
        [self addSubview:_checkImgView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5f)];
        lineView.backgroundColor = colorWithHexString(@"e2e6e8");
        [self addSubview:lineView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
