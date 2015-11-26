//
//  BXTManagerOMTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/11/26.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTManagerOMTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTManagerOMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.orderNumber = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 180.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:16.f];
            [self addSubview:label];
            label;
            
        });
        
        self.groupName = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50.f - 15.f, 12.f, 50.f, 26.3f)];
            label.textColor = colorWithHexString(@"00a2ff");
            label.layer.borderColor = colorWithHexString(@"00a2ff").CGColor;
            label.layer.borderWidth = 1.f;
            label.layer.cornerRadius = 4.f;
            label.font = [UIFont systemFontOfSize:16.f];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
            
        });
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 50.f, SCREEN_WIDTH - 30, 1.f)];
        lineView.backgroundColor = colorWithHexString(@"dee3e5");
        [self addSubview:lineView];
        
        self.place = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineView.frame) + 8.f, SCREEN_WIDTH - 30.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:16.f];
            [self addSubview:label];
            label;
            
        });
        
        self.faultType = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_place.frame) + 10.f, CGRectGetWidth(_place.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:16.f];
            [self addSubview:label];
            label;
            
        });
        
        self.cause = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_faultType.frame) + 10.f, CGRectGetWidth(_faultType.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:16.f];
            [self addSubview:label];
            label;
            
        });
        
        self.line = ({
        
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_cause.frame) + 10.f, SCREEN_WIDTH - 30, 1.f)];
            view.backgroundColor = colorWithHexString(@"dee3e5");
            [self addSubview:view];
            view;
        
        });
        
        self.orderType = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_line.frame) + 10.f, CGRectGetWidth(_cause.frame), 20)];
            label.textColor = colorWithHexString(@"cc0202");
            label.font = [UIFont boldSystemFontOfSize:16.f];
            [self addSubview:label];
            label;
            
        });
        
        self.repairTime = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_line.frame) + 10.f, CGRectGetWidth(_cause.frame), 20)];
            label.textColor = colorWithHexString(@"c1c9cc");
            label.font = [UIFont boldSystemFontOfSize:16.f];
            label.textAlignment = NSTextAlignmentRight;
            [self addSubview:label];
            label;
            
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
