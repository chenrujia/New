//
//  BXTAddOtherManTableViewCell.m
//  BXT
//
//  Created by Jason on 15/9/22.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTAddOtherManTableViewCell.h"
#import "BXTPublicSetting.h"
#import "BXTGlobal.h"

#define KImageWidth 73.3f
#define KImageHeight 73.3f

@implementation BXTAddOtherManTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.headImgView = ({
        
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 13.f, KImageWidth, KImageHeight)];
            [self addSubview:imgView];
            imgView;
        
        });
        
        self.userName = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImgView.frame) + 15.f, CGRectGetMinY(_headImgView.frame) + 13.f, 180.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.font = [UIFont systemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.detailName = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImgView.frame) + 15.f, CGRectGetMinY(_headImgView.frame) + 42.f, 180.f, 20)];
            label.textColor = colorWithHexString(@"909497");
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.font = [UIFont systemFontOfSize:14.f];
            [self addSubview:label];
            label;
        
        });
        
        self.addBtn = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
            button.layer.borderWidth = 1.f;
            button.layer.cornerRadius = 4.f;
            [button setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 30.f, 83.f, 40.f)];
            [button setTitle:@"添加" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            [self addSubview:button];
            button;
            
        });
                
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99.5f, SCREEN_WIDTH, 0.5f)];
        lineView.backgroundColor = colorWithHexString(@"e2e6e8");
        [self addSubview:lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
