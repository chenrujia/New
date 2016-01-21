//
//  BXTReaciveOrderTableViewCell.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTReaciveOrderTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTReaciveOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 50.f, SCREEN_WIDTH - 20, 1.f)];
        lineView.backgroundColor = colorWithHexString(@"dee3e5");
        [self addSubview:lineView];
        
        self.repairID = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 180.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
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
        
        self.place = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineView.frame) + 8.f, SCREEN_WIDTH - 30.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.faultType = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_place.frame) + 10.f, CGRectGetWidth(_place.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.cause = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_faultType.frame) + 10.f, CGRectGetWidth(_faultType.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.level = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_cause.frame) + 10.f, CGRectGetWidth(_cause.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        
        UIView *lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 124.f, SCREEN_WIDTH - 20, 1.f)];
        lineViewTwo.backgroundColor = colorWithHexString(@"dee3e5");
        [self addSubview:lineViewTwo];
        
        self.longTime= ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineViewTwo.frame) + 10.f, 150.f, 20)];
            label.textColor = colorWithHexString(@"de1a1a");
            label.font = [UIFont boldSystemFontOfSize:16.f];
            [self addSubview:label];
            label;
            
        });
        
        self.repairTime = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f - 15.f, CGRectGetMaxY(lineViewTwo.frame) + 10.f, 150.f, 20)];
            label.textColor = colorWithHexString(@"909497");
            label.font = [UIFont boldSystemFontOfSize:16.f];
            label.textAlignment = NSTextAlignmentRight;
            [self addSubview:label];
            label;
            
        });
        
        self.reaciveBtn = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = 4.f;
            button.backgroundColor = colorWithHexString(@"3cafff");
            [button setFrame:CGRectMake(0, CGRectGetMaxY(_repairTime.frame) + 10.f, 230.f, 40.f)];
            [button setCenter:CGPointMake(SCREEN_WIDTH/2.f, button.center.y)];
            [button setTitle:@"接单" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
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
