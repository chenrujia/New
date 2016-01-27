//
//  BXTManagerOMTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/11/26.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTManagerOMTableViewCell.h"
#import "BXTHeaderFile.h"

@interface BXTManagerOMTableViewCell ()

@end

@implementation BXTManagerOMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.orderNumber = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 180.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:16.f];
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
            label.numberOfLines = 0;
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:16.f];
            [self addSubview:label];
            label;
            
        });
        
        self.faultType = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_place.frame) + 10.f, CGRectGetWidth(_place.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:16.f];
            [self addSubview:label];
            label;
            
        });
        
        self.cause = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_faultType.frame) + 10.f, CGRectGetWidth(_faultType.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.font = [UIFont systemFontOfSize:16.f];
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
            label.font = [UIFont systemFontOfSize:16.f];
            [self addSubview:label];
            label;
            
        });
        
        self.repairTime = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_line.frame) + 10.f, CGRectGetWidth(_cause.frame), 20)];
            label.textColor = colorWithHexString(@"c1c9cc");
            label.font = [UIFont systemFontOfSize:16.f];
            label.textAlignment = NSTextAlignmentRight;
            [self addSubview:label];
            label;
            
        });
    }
    return self;
}

- (void)refreshSubViewsFrame:(BXTRepairInfo *)repairInfo
{
    //自适应分组名
    NSString *group_name = repairInfo.subgroup_name.length > 0 ? repairInfo.subgroup_name : @"其他";
    CGSize group_size = MB_MULTILINE_TEXTSIZE(group_name, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH, 40.f), NSLineBreakByWordWrapping);
    group_size.width += 10.f;
    group_size.height = CGRectGetHeight(self.groupName.frame);
    self.groupName.frame = CGRectMake(SCREEN_WIDTH - group_size.width - 15.f, CGRectGetMinY(self.groupName.frame), group_size.width, group_size.height);
    self.groupName.text = group_name;
    
    
    NSString *placeStr = [NSString stringWithFormat:@"位置:%@-%@-%@",repairInfo.area, repairInfo.place, repairInfo.stores_name];
    if ([BXTGlobal isBlankString:repairInfo.stores_name]) {
        placeStr = [NSString stringWithFormat:@"位置:%@-%@",repairInfo.area, repairInfo.place];
    }
    
    CGSize cause_size0 = MB_MULTILINE_TEXTSIZE(placeStr, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
    self.place.text = placeStr;
    // 更新所有控件位置 1
    self.place.frame = CGRectMake(15.f, 50.f + 8.f, SCREEN_WIDTH - 30.f, cause_size0.height + 3);
    self.faultType.frame = CGRectMake(15.f, CGRectGetMaxY(_place.frame) + 10.f, CGRectGetWidth(_place.frame), 20);
    
    
    self.faultType.text = [NSString stringWithFormat:@"故障类型:%@",repairInfo.faulttype_name];
    
    //自适应故障描述
    NSString *causeStr = [NSString stringWithFormat:@"故障描述:%@",repairInfo.cause];
    CGSize cause_size = MB_MULTILINE_TEXTSIZE(causeStr, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
    self.cause.text = causeStr;
    
    
    // 更新所有控件位置 2
    self.cause.frame = CGRectMake(15.f, CGRectGetMaxY(_faultType.frame) + 10.f, CGRectGetWidth(_faultType.frame), cause_size.height);
    self.line.frame = CGRectMake(15, CGRectGetMaxY(_cause.frame) + 10.f, SCREEN_WIDTH - 30, 1.f);
    self.orderType.frame = CGRectMake(15.f, CGRectGetMaxY(_line.frame) + 10.f, CGRectGetWidth(_cause.frame), 20);
    self.repairTime.frame = CGRectMake(15.f, CGRectGetMaxY(_line.frame) + 10.f, CGRectGetWidth(_cause.frame), 20);
    self.cellHeight = CGRectGetMaxY(_repairTime.frame) + 8;
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
