//
//  BXTPhotosView.m
//  YouFeel
//
//  Created by Jason on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotosView.h"
#import "BXTGlobal.h"
#import "BXTRepairDetailInfo.h"
#import "UIImageView+WebCache.h"

@implementation BXTPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialSubviews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialSubviews];
    }
    return self;
}

- (void)initialSubviews
{
    self.imgViewOne = ({
        
        BXTCustomImageView *imageView = [[BXTCustomImageView alloc] init];
        [imageView setFrame:CGRectMake(20, 0, GImageHeight, GImageHeight)];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 0;
        [self addSubview:imageView];
        imageView;
        
    });
    
    self.imgViewTwo = ({
        
        BXTCustomImageView *imageView = [[BXTCustomImageView alloc] init];
        [imageView setFrame:CGRectMake(20, 0, GImageHeight, GImageHeight)];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 1;
        [self addSubview:imageView];
        imageView;
        
    });
    
    self.imgViewThree = ({
        
        BXTCustomImageView *imageView = [[BXTCustomImageView alloc] init];
        [imageView setFrame:CGRectMake(20, 0, GImageHeight, GImageHeight)];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 2;
        [self addSubview:imageView];
        imageView;
        
    });
    
    self.addBtn = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(20, 0, GImageHeight, GImageHeight)];
        [button setImage:[UIImage imageNamed:@"wo_photo"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"wo_photo_select"] forState:UIControlStateHighlighted];
        [self addSubview:button];
        button;
        
    });
}

- (void)handleImagesFrame:(NSArray *)array
{
    CGFloat x = CGRectGetMaxX(self.addBtn.frame);
    CGFloat y = CGRectGetMinY(self.addBtn.frame);
    if (array.count == 1)
    {
        BXTFaultPicInfo *picDic = array[0];
        [self.imgViewOne sd_setImageWithURL:[NSURL URLWithString:picDic.photo_thumb_file]];
        [self.imgViewOne setFrame:CGRectMake(x + 10.f, y, GImageHeight, GImageHeight)];
    }
    else if (array.count == 2)
    {
        [self.imgViewOne setFrame:CGRectMake(x + 10.f, y, GImageHeight, GImageHeight)];
        BXTFaultPicInfo *picDic = array[0];
        [self.imgViewOne sd_setImageWithURL:[NSURL URLWithString:picDic.photo_thumb_file]];
        [self.imgViewTwo setFrame:CGRectMake(CGRectGetMaxX(self.imgViewOne.frame) + 10.f, y, GImageHeight, GImageHeight)];
        
        BXTFaultPicInfo *picDicTwo = array[1];
        [self.imgViewTwo sd_setImageWithURL:[NSURL URLWithString:picDicTwo.photo_thumb_file]];
        [self.imgViewTwo setFrame:CGRectMake(CGRectGetMaxX(self.imgViewOne.frame) + 10.f, y, GImageHeight, GImageHeight)];
    }
    else if (array.count == 3)
    {
        [self.imgViewOne setFrame:CGRectMake(x + 10.f, y, GImageHeight, GImageHeight)];
        BXTFaultPicInfo *picDic = array[0];
        [self.imgViewOne sd_setImageWithURL:[NSURL URLWithString:picDic.photo_thumb_file]];
        [self.imgViewTwo setFrame:CGRectMake(CGRectGetMaxX(self.imgViewOne.frame) + 10.f, y, GImageHeight, GImageHeight)];
        
        BXTFaultPicInfo *picDicTwo = array[1];
        [self.imgViewTwo sd_setImageWithURL:[NSURL URLWithString:picDicTwo.photo_thumb_file]];
        [self.imgViewThree setFrame:CGRectMake(CGRectGetMaxX(self.imgViewTwo.frame) + 10.f, y, GImageHeight, GImageHeight)];
        
        BXTFaultPicInfo *picDicThree = array[2];
        [self.imgViewThree sd_setImageWithURL:[NSURL URLWithString:picDicThree.photo_thumb_file]];
        [self.imgViewThree setFrame:CGRectMake(CGRectGetMaxX(self.imgViewTwo.frame) + 10.f, y, GImageHeight, GImageHeight)];
    }
}

@end
