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
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 13.f, KImageWidth, KImageHeight)];
        [self addSubview:_headImgView];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImgView.frame) + 15.f, CGRectGetMinY(_headImgView.frame) + 13.f, 180.f, 20)];
        _userName.textColor = colorWithHexString(@"000000");
        _userName.numberOfLines = 0;
        _userName.lineBreakMode = NSLineBreakByWordWrapping;
        _userName.font = [UIFont boldSystemFontOfSize:17.f];
        [self addSubview:_userName];
        
        _detailName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImgView.frame) + 15.f, CGRectGetMinY(_headImgView.frame) + 42.f, 180.f, 20)];
        _detailName.textColor = colorWithHexString(@"909497");
        _detailName.numberOfLines = 0;
        _detailName.lineBreakMode = NSLineBreakByWordWrapping;
        _detailName.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_detailName];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        _addBtn.layer.borderWidth = 1.f;
        _addBtn.layer.cornerRadius = 4.f;
        [_addBtn setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 30.f, 83.f, 40.f)];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        [self addSubview:_addBtn];
        
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
