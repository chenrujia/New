//
//  CALayer+Additions.m
//  YouFeel
//
//  Created by Jason on 16/8/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
