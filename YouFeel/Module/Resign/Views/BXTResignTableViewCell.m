//
//  BXTResignTableViewCell.m
//  BXT
//
//  Created by Jason on 15/8/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTResignTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTResignTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., 60.f, 30)];
        _nameLabel.textColor = colorWithHexString(@"000000");
        _nameLabel.font = [UIFont boldSystemFontOfSize:18.];
        [self addSubview:_nameLabel];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 10.f, 3, SCREEN_WIDTH - 30.f - 60.f, 44.f)];
        [_textField setValue:colorWithHexString(@"909497") forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:[UIFont systemFontOfSize:10.f] forKeyPath:@"_placeholderLabel.font"];
        _textField.textColor = colorWithHexString(@"909497");
        [self addSubview:_textField];
        
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeButton.frame = CGRectMake(SCREEN_WIDTH - 75.f - 13.f, 7, 75.f, 36.f);
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_codeButton setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        _codeButton.layer.masksToBounds = YES;
        _codeButton.layer.cornerRadius = 6.f;
        _codeButton.layer.borderWidth = 1.f;
        _codeButton.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        [self addSubview:_codeButton];
        
        _boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _boyBtn.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 20.f, 5, 57.f, 40.f);
        [_boyBtn setTitle:@"男" forState:UIControlStateNormal];
        [_boyBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        _boyBtn.layer.masksToBounds = YES;
        _boyBtn.layer.cornerRadius = 6.f;
        _boyBtn.layer.borderWidth = 1.f;
        _boyBtn.tag = 11;
        _boyBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        [self addSubview:_boyBtn];
        
        _girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _girlBtn.frame = CGRectMake(CGRectGetMaxX(_boyBtn.frame) + 27.f, 5, 57.f, 40.f);
        [_girlBtn setTitle:@"女" forState:UIControlStateNormal];
        [_girlBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        _girlBtn.layer.masksToBounds = YES;
        _girlBtn.layer.cornerRadius = 6.f;
        _girlBtn.layer.borderWidth = 1.f;
        _girlBtn.tag = 12;
        _girlBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        [self addSubview:_girlBtn];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
