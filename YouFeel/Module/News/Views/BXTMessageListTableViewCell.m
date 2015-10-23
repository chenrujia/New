//
//  BXTMessageListTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/10/22.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTMessageListTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTMessageListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"ffffff");
        
        self.iconView = ({
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 16.f, 53.f, 53.f)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.layer.masksToBounds = YES;
            [self addSubview:imgView];
            imgView;
            
        });
        
        self.redLabel = ({
        
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = colorWithHexString(@"fd453e");
            label.layer.borderColor = [UIColor whiteColor].CGColor;
            label.layer.borderWidth = 1.f;
            [self addSubview:label];
            label;
        
        });
        
        self.titleLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + 15.f, 20.f, 100.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
            
        });
        
        self.detailLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 10.f, SCREEN_WIDTH - CGRectGetMinX(_titleLabel.frame) - 15.f, 20)];
            label.textColor = colorWithHexString(@"909497");
            label.font = [UIFont boldSystemFontOfSize:14.f];
            [self addSubview:label];
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
    [_redLabel setCenter:CGPointMake(CGRectGetMaxX(_iconView.frame), CGRectGetMinY(_iconView.frame))];
    _redLabel.layer.cornerRadius = 10.f;
    _redLabel.layer.masksToBounds = YES;
    _redLabel.text = numberStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
