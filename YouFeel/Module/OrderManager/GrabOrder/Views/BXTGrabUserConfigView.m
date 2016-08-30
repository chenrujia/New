//
//  BXTGrabUserConfigView.m
//  YouFeel
//
//  Created by Jason on 16/8/27.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTGrabUserConfigView.h"
#import "BXTGlobal.h"

@implementation BXTGrabUserConfigView

- (instancetype)initWithFrame:(CGRect)frame imageSize:(CGSize)size imageName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.iconImgView = ({
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
            imgView.center = CGPointMake(CGRectGetWidth(self.frame)/2.f - 30.f, CGRectGetHeight(self.frame)/2.f);
            imgView.image = [UIImage imageNamed:name];
            [self addSubview:imgView];
            imgView;
            
        });
        
        self.contentLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImgView.frame) + 10.f, 13.5f, CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.iconImgView.frame) - 10.f - 10.f, 20)];
            label.textColor = colorWithHexString(@"4a4a4a");
            label.font = [UIFont systemFontOfSize:17.f];
            [self addSubview:label];
            label;
            
        });
    }
    return self;
}

@end
