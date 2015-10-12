//
//  RGCollectionViewCell.m
//  RGCardViewLayout
//
//  Created by ROBERA GELETA on 1/23/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import "RGCollectionViewCell.h"
#import "BXTHeaderFile.h"

@implementation RGCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor orangeColor];
        self.layer.cornerRadius = 10.f;

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH - 60.f, 160.3f)];
        [self.contentView addSubview:_imageView];
    }
    return self;
}


@end