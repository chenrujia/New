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
        self.nameLabel = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., 60.f, 30)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:18.];
            [self addSubview:label];
            label;
        
        });
        
        self.textField = ({
        
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 10.f, 3, SCREEN_WIDTH - 30.f - 60.f, 44.f)];
            [tf setValue:colorWithHexString(@"909497") forKeyPath:@"_placeholderLabel.textColor"];
            [tf setValue:[UIFont systemFontOfSize:10.f] forKeyPath:@"_placeholderLabel.font"];
            tf.textColor = colorWithHexString(@"909497");
            [self addSubview:tf];
            tf;
        
        });
        
        self.codeButton = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(SCREEN_WIDTH - 75.f - 13.f, 7, 75.f, 36.f);
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [button setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 6.f;
            button.layer.borderWidth = 1.f;
            button.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            [self addSubview:button];
            button;
        
        });
        
        self.boyBtn = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 20.f, 5, 57.f, 40.f);
            [button setTitle:@"男" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 6.f;
            button.layer.borderWidth = 1.f;
            button.tag = 11;
            button.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
            [self addSubview:button];
            button;
        
        });
        
        self.girlBtn = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(CGRectGetMaxX(_boyBtn.frame) + 27.f, 5, 57.f, 40.f);
            [button setTitle:@"女" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 6.f;
            button.layer.borderWidth = 1.f;
            button.tag = 12;
            button.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            [self addSubview:button];
            button;
        
        });
        
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
