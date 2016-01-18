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
        
        self.iconImgView = ({
        
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.contentView addSubview:imageView];
            imageView;
        
        });
        
        self.redLabel = ({
            
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = colorWithHexString(@"fd453e");
            label.layer.borderColor = [UIColor whiteColor].CGColor;
            label.layer.borderWidth = 2.f;
            [self.contentView addSubview:label];
            label;
            
        });
        
        self.namelabel = ({
        
            UILabel *label = [[UILabel alloc] init];
            label.textColor = colorWithHexString(@"000000");
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15.f];
            [self.contentView addSubview:label];
            label;
            
        });
        
    }
    return self;
}

- (void)newsRedNumber:(NSInteger)number
{
    if (number == 0)
    {
        [_redLabel setFrame:CGRectZero];
        return;
    }
    NSString *numberStr = [NSString stringWithFormat:@"%ld",(long)number];
    NSInteger length = numberStr.length;
    [_redLabel setFrame:CGRectMake(0, 0, 10 + 10 * length, 20.f)];
    [_redLabel setCenter:CGPointMake(CGRectGetMaxX(_iconImgView.frame)+10, CGRectGetMinY(_iconImgView.frame))];
    _redLabel.layer.cornerRadius = 10.f;
    _redLabel.layer.masksToBounds = YES;
    _redLabel.text = numberStr;
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
