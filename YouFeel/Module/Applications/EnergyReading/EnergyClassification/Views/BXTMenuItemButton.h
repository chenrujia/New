//
//  BXTMenuItemButton.h
//  AllOther
//
//  Created by Jason on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrawContentType) {
    DrawNot = 0,
    DrawLeft = 1,
    DrawMiddle = 2,
    DrawRight = 3
};

@interface BXTMenuItemButton : UIButton

@property (nonatomic, assign) DrawContentType drawType;
@property (nonatomic, strong) UIColor         *drawColor;
@property (nonatomic, strong) UIColor         *backColor;

- (instancetype)initWithFrame:(CGRect)frame drawType:(DrawContentType)type backgroudColor:(UIColor *)backgroudColor;

- (void)changeDrawColor:(UIColor *)color backgroudColor:(UIColor *)backgroudColor drawType:(DrawContentType)type;

@end
