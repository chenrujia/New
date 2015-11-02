//
//  BXTNewsTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/10/19.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTNewsTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"ffffff");
        
        self.titleLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 240.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
            
        });
        
        self.evaButton = ({
            
            CGFloat width = IS_IPHONE6 ? 84.f : 56.f;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setFrame:CGRectMake(SCREEN_WIDTH - width - 15.f, 12.f, width, 30.f)];
            [button setTitle:@"接受" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"3aaeff") forState:UIControlStateNormal];
            button.layer.borderColor = colorWithHexString(@"3aaeff").CGColor;
            button.layer.borderWidth = 0.7f;
            button.layer.cornerRadius = 4.f;
            [self addSubview:button];
            button;
            
        });
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 50.f, SCREEN_WIDTH - 20, 0.7f)];
        lineView.backgroundColor = colorWithHexString(@"dee3e5");
        [self addSubview:lineView];
        
        self.detailLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineView.frame) + 8.f, SCREEN_WIDTH - 130.f - 10.f - 30.f, 40)];
            label.textColor = colorWithHexString(@"909497");
            label.numberOfLines = 0.f;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.font = [UIFont boldSystemFontOfSize:15.f];
            [self addSubview:label];
            label;
            
        });
        
        self.timeLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130.f - 15.f, CGRectGetMinY(_detailLabel.frame) + 34.f, 130, 20)];
            label.textColor = colorWithHexString(@"909497");
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont boldSystemFontOfSize:15.f];
            [self addSubview:label];
            label;
            
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
