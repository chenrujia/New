//
//  BXTHomeCollectionViewCell.m
//  BXT
//
//  Created by Jason on 15/8/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTHomeCollectionViewCell.h"
#import "BXTGlobal.h"

@implementation BXTHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView.layer.borderWidth = 0.5f;
        self.contentView.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        _iconImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImgView];
        
        _namelabel = [[UILabel alloc] init];
        _namelabel.textColor = colorWithHexString(@"000000");
        _namelabel.textAlignment = NSTextAlignmentCenter;
        _namelabel.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:_namelabel];
    }
    return self;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    _iconImgView.frame = CGRectMake(0, 0, _iconImage.size.width, _iconImage.size.height);
    _iconImgView.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.f - _iconImage.size.height/2.f);
    _iconImgView.image = _iconImage;
    
    _namelabel.frame = CGRectMake(0, 0, 100.f, 20.f);
    _namelabel.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.f + 16.f);
}

@end
