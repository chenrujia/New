//
//  BXTSettingTableViewCell.m
//  BXT
//
//  Created by Jason on 15/8/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTSettingTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 90.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:17.];
            [self addSubview:label];
            label;
            
        });
        
        self.detailLable = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 15.f, SCREEN_WIDTH - (CGRectGetMaxX(_titleLabel.frame) + 20.f) - 35.f, 20)];
            label.textColor = colorWithHexString(@"909497");
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:15.f];
            [self addSubview:label];
            label;
            
        });
        
        self.auditStatusLabel = ({
            
            UILabel *label = [[UILabel alloc] init];
            label.textColor = colorWithHexString(@"3dafff");
            label.font = [UIFont systemFontOfSize:15.f];
            [self addSubview:label];
            label;
            
        });
        
        self.detailTF = ({
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), 10., CGRectGetWidth(_detailLable.frame), 30)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.textColor = colorWithHexString(@"909497");
            textField.hidden = YES;
            [self addSubview:textField];
            textField;
            
        });
        
        self.checkImgView = ({
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 13.f - 25.f, 20, 13, 10)];
            imageView.hidden = YES;
            imageView.image = [UIImage imageNamed:@"checktransparent"];
            [self addSubview:imageView];
            imageView;
            
        });
        
        self.switchbtn = ({
            
            UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f - 10.f, 10, 60.f, 30.f)];
            switchBtn.on = NO;
            switchBtn.hidden = YES;
            [switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:switchBtn];
            switchBtn;
            
        });
        
        self.normelBtn = ({
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.hidden = YES;
            button.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 7.f, 5, 57.f, 40.f);
            [button setTitle:@"一般" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4.f;
            button.layer.borderWidth = 1.f;
            button.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
            [self addSubview:button];
            button;
            
        });
        
        self.emergencyBtn = ({
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.hidden = YES;
            button.frame = CGRectMake(CGRectGetMaxX(_normelBtn.frame) + 20, 5, 57.f, 40.f);
            [button setTitle:@"紧急" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4.f;
            button.layer.borderWidth = 1.f;
            button.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            [self addSubview:button];
            button;
            
        });
        
        self.headImageView = ({
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45.f-70, 15.f, 70.f, 70.f)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.hidden = YES;
            [self addSubview:imageView];
            imageView;
            
        });
    }
    return self;
}

- (void)switchChanged:(UISwitch *)swt
{
    NSString *obj = nil;
    if (swt.on)
    {
        obj = @"1";
    }
    else
    {
        obj = @"0";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PublicRepair" object:obj];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
