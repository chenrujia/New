//
//  BXTRepairTableViewCell.m
//  BXT
//
//  Created by Jason on 15/9/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTRepairTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.repairID = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 180.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
            
        });
        
        self.time = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80.f - 15.f, 15.f, 80.f, 20)];
            label.textColor = colorWithHexString(@"909497");
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 50.f, SCREEN_WIDTH - 20, 1.f)];
        lineView.backgroundColor = colorWithHexString(@"dee3e5");
        [self addSubview:lineView];
        
        
        self.place = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineView.frame) + 8.f, SCREEN_WIDTH - 30.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.name = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_place.frame) + 10.f, CGRectGetWidth(_place.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.cause = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_name.frame) + 10.f, CGRectGetWidth(_name.frame), 20)];
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
        
        self.state = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineViewTwo.frame) + 8.f, CGRectGetWidth(_cause.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.repairState = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_state.frame) + 6.f, CGRectGetWidth(_state.frame), 20)];
            label.textColor = colorWithHexString(@"909497");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.cancelRepair = ({
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
            button.layer.borderWidth = 1.f;
            button.layer.cornerRadius = 4.f;
            [button setFrame:CGRectMake(SCREEN_WIDTH - 114.f - 15.f, CGRectGetMaxY(lineViewTwo.frame) + 10.f, 114.f, 40.f)];
            [button setTitle:@"取消报修" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            [self addSubview:button];
            button;
        
        });
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
