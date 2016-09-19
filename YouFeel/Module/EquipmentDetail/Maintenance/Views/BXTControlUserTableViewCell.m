//
//  BXTControlUserTableViewCell.m
//  YouFeel
//
//  Created by Jason on 16/1/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTControlUserTableViewCell.h"
#import "BXTPublicSetting.h"
#import "BXTGlobal.h"

@implementation BXTControlUserTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.connactTa.layer.cornerRadius = 4.f;
    self.connactTa.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    self.connactTa.layer.borderWidth = 1;
    self.userMoblie.userInteractionEnabled = YES;
    UITapGestureRecognizer *moblieTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mobileClick)];
    [self.userMoblie addGestureRecognizer:moblieTap];
}

- (void)mobileClick
{
    if (self.userMoblie.text.length > 0)
    {
        NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.userMoblie.text];
        UIWebView *callWeb = [[UIWebView alloc] init];
        [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
        [self addSubview:callWeb];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
