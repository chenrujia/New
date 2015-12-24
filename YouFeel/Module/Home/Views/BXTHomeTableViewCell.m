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
        
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(RealValue(26.f), RealValue(15.f), RealValue(30.f), RealValue(30.f))];
            [self addSubview:imageView];
            imageView;
        
        });
        
        self.titleLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_logoImgView.frame) + RealValue(26.f), 0, 100.f, 20)];
            label.center = CGPointMake(label.center.x, _logoImgView.center.y);
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:RealValue(17.f)];
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
