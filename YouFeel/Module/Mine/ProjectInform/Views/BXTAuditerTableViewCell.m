//
//  BXTAuditerTableViewCell.m
//  BXT
//
//  Created by Jason on 15/9/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTAuditerTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTAuditerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 80.f, 20)];
        _titleLabel.textColor = colorWithHexString(@"000000");
        _titleLabel.text = @"审核人";
        _titleLabel.font = [UIFont systemFontOfSize:17.];
        [self addSubview:_titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5f)];
        lineView.backgroundColor = colorWithHexString(@"e2e6e8");
        [self addSubview:lineView];
        
        _auditNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineView.frame) + 12.f, 70.f, 20)];
        _auditNameLabel.textColor = colorWithHexString(@"000000");
        _auditNameLabel.font = [UIFont systemFontOfSize:17.];
        [self addSubview:_auditNameLabel];
        
        _phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(lineView.frame)+ 8.f, 100, 30)];
        _phoneBtn.titleLabel.textColor = colorWithHexString(@"#00B1FF");
        _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_phoneBtn];
        
        _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_auditNameLabel.frame) + 12.f, 80.f, 20)];
        _positionLabel.textColor = colorWithHexString(@"909497");
        _positionLabel.font = [UIFont systemFontOfSize:17.];
        [self addSubview:_positionLabel];
        
        _contactBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _contactBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        _contactBtn.layer.borderWidth = 1.f;
        _contactBtn.layer.cornerRadius = 4.f;
        [_contactBtn setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 67.f, 83.f, 40.f)];
        [_contactBtn setTitle:@"联系Ta" forState:UIControlStateNormal];
        [_contactBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        [self addSubview:_contactBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
