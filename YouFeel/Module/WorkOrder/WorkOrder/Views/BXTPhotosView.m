//
//  BXTPhotosView.m
//  YouFeel
//
//  Created by Jason on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotosView.h"
#import "BXTGlobal.h"
#import "UIImageView+WebCache.h"

@implementation BXTPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgViewOne = ({
            
            BXTCustomImageView *imageView = [[BXTCustomImageView alloc] init];
            [imageView setFrame:CGRectMake(20, 0, GImageHeight, GImageHeight)];
            imageView.userInteractionEnabled = YES;
            imageView.layer.masksToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.tag = 0;
            [self addSubview:imageView];
            imageView;
            
        });
        
        self.imgViewTwo = ({
        
            BXTCustomImageView *imageView = [[BXTCustomImageView alloc] init];
            [imageView setFrame:CGRectMake(20, 0, GImageHeight, GImageHeight)];
            imageView.userInteractionEnabled = YES;
            imageView.layer.masksToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.tag = 1;
            [self addSubview:imageView];
            imageView;
        
        });
        
        self.imgViewThree = ({
            
            BXTCustomImageView *imageView = [[BXTCustomImageView alloc] init];
            [imageView setFrame:CGRectMake(20, 0, GImageHeight, GImageHeight)];
            imageView.userInteractionEnabled = YES;
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
    return self;
}

- (void)handleImagesFrame:(NSArray *)array
{
    CGFloat x = 10 + GImageHeight;
    CGFloat y = 170.f - GImageHeight - 10.f;
    if (array.count == 1)
    {
        NSDictionary *picDic = array[0];
        [self.imgViewOne sd_setImageWithURL:[NSURL URLWithString:[picDic objectForKey:@"photo_thumb_file"]]];
        [self.imgViewOne setFrame:CGRectMake(x + 10.f, y, GImageHeight, GImageHeight)];
    }
    else if (array.count == 2)
    {
        [self.imgViewOne setFrame:CGRectMake(x + 10.f, y, GImageHeight, GImageHeight)];
        NSDictionary *picDic = array[0];
        [self.imgViewOne sd_setImageWithURL:[NSURL URLWithString:[picDic objectForKey:@"photo_thumb_file"]]];
        [self.imgViewTwo setFrame:CGRectMake(CGRectGetMaxX(self.imgViewOne.frame) + 10.f, y, GImageHeight, GImageHeight)];
        NSDictionary *picDicTwo = array[1];
        [self.imgViewTwo sd_setImageWithURL:[NSURL URLWithString:[picDicTwo objectForKey:@"photo_thumb_file"]]];
    }
    else if (array.count == 3)
    {
        [self.imgViewOne setFrame:CGRectMake(x + 10.f, y, GImageHeight, GImageHeight)];
        NSDictionary *picDic = array[0];
        [self.imgViewOne sd_setImageWithURL:[NSURL URLWithString:[picDic objectForKey:@"photo_thumb_file"]]];
        [self.imgViewTwo setFrame:CGRectMake(CGRectGetMaxX(self.imgViewOne.frame) + 10.f, y, GImageHeight, GImageHeight)];
        NSDictionary *picDicTwo = array[1];
        [self.imgViewTwo sd_setImageWithURL:[NSURL URLWithString:[picDicTwo objectForKey:@"photo_thumb_file"]]];
        [self.imgViewThree setFrame:CGRectMake(CGRectGetMaxX(self.imgViewTwo.frame) + 10.f, y, GImageHeight, GImageHeight)];
        NSDictionary *picDicThree = array[2];
        [self.imgViewThree sd_setImageWithURL:[NSURL URLWithString:[picDicThree objectForKey:@"photo_thumb_file"]]];
    }
}

@end
