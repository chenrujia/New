//
//  BXTArchievementsTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/10/15.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTArchievementsTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTArchievementsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.timeLabel = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 100.f, 20.f)];
            label.font = [UIFont systemFontOfSize:16.f];
            [self addSubview:label];
            label;
        
        });
        
        self.imgView = ({
        
            UIImageView *imageView = [[UIImageView alloc] init];
            [self addSubview:imageView];
            imageView;
        
        });
        
        self.nameLabel = ({
        
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16.f];
            [self addSubview:label];
            label;
        
        });
        
        self.dateLabel = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100.f - 20.f, 15.f, 100.f, 20.f)];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:16.f];
            [self addSubview:label];
            label;
        
        });
        
        self.lineView = ({
        
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = colorWithHexString(@"e2e6e7");
            [self addSubview:view];
            view;
        
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
