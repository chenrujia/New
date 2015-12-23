//
//  BXTMaintenanceManTableViewCell.m
//  BXT
//
//  Created by Jason on 15/9/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTMaintenanceManTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTMaintenanceManTableViewCell

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
        
        self.maintenanceProcess = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
            button.layer.borderWidth = 1.f;
            button.layer.cornerRadius = 4.f;
            [button setFrame:CGRectMake(SCREEN_WIDTH - 90.f - 15.f, 10.f, 90.f, 30.f)];
            [button setTitle:@"维修过程" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            [self addSubview:button];
            button;
        
        });
        
        self.orderType = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100.f - 15.f, 10.f, 100.f, 20)];
            label.textColor = colorWithHexString(@"de1a1a");
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont boldSystemFontOfSize:17.f];
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
        
        self.cause = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_place.frame) + 10.f, CGRectGetWidth(_place.frame), 20)];
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
        
        self.time = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_level.frame) + 8.f, CGRectGetWidth(_level.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        UIView *lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 124.f, SCREEN_WIDTH - 20, 1.f)];
        lineViewTwo.backgroundColor = colorWithHexString(@"dee3e5");
        [self addSubview:lineViewTwo];
        
        self.reaciveBtn = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = 6.f;
            button.backgroundColor = colorWithHexString(@"3cafff");
            [button setFrame:CGRectMake(0, CGRectGetMaxY(lineViewTwo.frame) + 10.f, 230.f, 40.f)];
            [button setCenter:CGPointMake(SCREEN_WIDTH/2.f, button.center.y)];
            [button setTitle:@"开始维修" forState:UIControlStateNormal];
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
