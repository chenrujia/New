//
//  BXTMMLogTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/12/2.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTMMLogTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTMMLogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., 80.f, 30)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:18.f];
            [self addSubview:label];
            label;
        
        });
        
        self.remarkTV = ({
        
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(110.f, 7.f, SCREEN_WIDTH - 110.f - 10.f, 96.f)];
            textView.font = [UIFont systemFontOfSize:16.];
            textView.textColor = colorWithHexString(@"909497");
            textView.text = @"请输入维修日志（少于200字）";
            [self addSubview:textView];
            textView;
        
        });
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
