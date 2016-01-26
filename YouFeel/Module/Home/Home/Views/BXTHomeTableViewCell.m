//
//  BXTHomeTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/12/24.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTHomeTableViewCell.h"
#import "BXTGlobal.h"

@implementation BXTHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"ffffff");

        self.logoImgView = ({
        
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 15.f, 30.f, 30.f)];
            [self addSubview:imageView];
            imageView;
        
        });
        
        self.titleLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_logoImgView.frame) + 20.f, 0, 100.f, 20)];
            label.center = CGPointMake(label.center.x, _logoImgView.center.y);
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:17.f];
            [self addSubview:label];
            label;
            
        });
        
        self.numberLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 20.f, 20)];
            label.center = CGPointMake(label.center.x, _logoImgView.center.y);
            label.textColor = colorWithHexString(@"ffffff");
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor redColor];
            label.font = [UIFont systemFontOfSize:11];
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            [self addSubview:label];
            label;
            
        });
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
