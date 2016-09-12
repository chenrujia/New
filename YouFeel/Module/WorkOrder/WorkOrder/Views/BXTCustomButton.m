//
//  BXTCustomButton.m
//  AttributeViewDemo
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 tangjp. All rights reserved.
//

#import "BXTCustomButton.h"
#import "BXTPublicSetting.h"

@implementation BXTCustomButton

- (instancetype)initWithType:(CustomButtonType)btnType
{
    self = [super init];
    if (self)
    {
        self.customBtnType = btnType;
    }
    return self;
}

//第一种方式
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 8;
    CGFloat titleY = 0;
    CGFloat titleW;
    CGFloat titleH;
    if (_customBtnType == FaultTypeType)
    {
        titleW = contentRect.size.width;
        titleH = contentRect.size.height - titleY;
    }
    else if (_customBtnType == SelectBtnType)
    {
        titleW = SCREEN_WIDTH - 40 - 30 - 10 - 8;
        titleH = contentRect.size.height - titleY;
    }
    else if (_customBtnType == GroupBtnType)
    {
        titleX = 0.f;
        titleW = SCREEN_WIDTH - 40 - 30 - 10 - 8;
        titleH = contentRect.size.height - titleY;
    }
    else if (_customBtnType == EnergyBtnType)
    {
        titleX = 0.f;
        titleW = (SCREEN_WIDTH - 20.f)/4.f - 5.f;
        titleH = contentRect.size.height - titleY;
    }
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX;
    CGFloat imageY;
    CGFloat imageW;
    CGFloat imageH;
    
    if (_customBtnType == FaultTypeType)
    {
        imageX = 5;
        imageY = 6;
        imageW = 17.f;
        imageH = 17.f;
    }
    else if (_customBtnType == SelectBtnType)
    {
        imageX = SCREEN_WIDTH - 40 - 30;
        imageY = 18;
        imageW = 15.f;
        imageH = 9.f;
    }
    else if (_customBtnType == GroupBtnType)
    {
        imageX = SCREEN_WIDTH - 58;
        imageY = 18;
        imageW = 15.f;
        imageH = 9.f;
    }
    else if (_customBtnType == EnergyBtnType)
    {
        if (self.tag == 3)
        {
            if (IS_IPHONE6P)
            {
                imageX = (SCREEN_WIDTH - 20.f)/4.f - 21.f;
            }
            else
            {
                imageX = (SCREEN_WIDTH - 20.f)/4.f - 16.f;
            }
            imageY = 17;
            imageW = 13.5f;
            imageH = 10.f;
        }
        else
        {
            if (IS_IPHONE6P)
            {
                imageX = (SCREEN_WIDTH - 20.f)/4.f - 18.f;
            }
            else
            {
                imageX = (SCREEN_WIDTH - 20.f)/4.f - 10.f;
            }
            imageY = 19;
            imageW = 10.f;
            imageH = 6.f;
        }
    }
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

//第二种方式
//- (void)layoutSubviews
//{    [super layoutSubviews];
//    CGRect imageRect = self.imageView.frame;
//    imageRect.size = CGSizeMake(30, 30);
//    imageRect.origin.x = (self.frame.size.width - 30) ;
//    imageRect.origin.y = (self.frame.size.height  - 30)/2.0f;
//    CGRect titleRect = self.titleLabel.frame;
//    titleRect.origin.x = (self.frame.size.width - imageRect.size.width- titleRect.size.width);
//    titleRect.origin.y = (self.frame.size.height - titleRect.size.height)/2.0f;
//    self.imageView.frame = imageRect;    self.titleLabel.frame = titleRect;
//    
//}

@end
