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
        
        _repairID = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 160.f, 20)];
        _repairID.textColor = colorWithHexString(@"000000");
        _repairID.font = [UIFont boldSystemFontOfSize:17.f];
        [self addSubview:_repairID];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80.f - 15.f, 15.f, 80.f, 20)];
        _time.textColor = colorWithHexString(@"909497");
        _time.textAlignment = NSTextAlignmentRight;
        _time.font = [UIFont systemFontOfSize:17.f];
        [self addSubview:_time];
        
        _place = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineView.frame) + 8.f, SCREEN_WIDTH - 30.f, 20)];
        _place.textColor = colorWithHexString(@"000000");
        _place.font = [UIFont boldSystemFontOfSize:17.f];
        [self addSubview:_place];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_place.frame) + 10.f, CGRectGetWidth(_place.frame), 20)];
        _name.textColor = colorWithHexString(@"000000");
        _name.font = [UIFont boldSystemFontOfSize:17.f];
        [self addSubview:_name];
        
        _cause = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_name.frame) + 10.f, CGRectGetWidth(_name.frame), 20)];
        _cause.textColor = colorWithHexString(@"000000");
        _cause.font = [UIFont boldSystemFontOfSize:17.f];
        [self addSubview:_cause];
        
        _level = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_cause.frame) + 10.f, CGRectGetWidth(_cause.frame), 20)];
        _level.textColor = colorWithHexString(@"000000");
        _level.font = [UIFont boldSystemFontOfSize:17.f];
        [self addSubview:_level];
        
        UIView *lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 124.f, SCREEN_WIDTH - 20, 1.f)];
        lineViewTwo.backgroundColor = colorWithHexString(@"dee3e5");
        [self addSubview:lineViewTwo];
        
        _reaciveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reaciveBtn.layer.cornerRadius = 6.f;
        _reaciveBtn.backgroundColor = colorWithHexString(@"febc2d");
        [_reaciveBtn setFrame:CGRectMake(0, CGRectGetMaxY(lineViewTwo.frame) + 10.f, 230.f, 40.f)];
        [_reaciveBtn setCenter:CGPointMake(SCREEN_WIDTH/2.f, _reaciveBtn.center.y)];
        [_reaciveBtn setTitle:@"接单" forState:UIControlStateNormal];
        [_reaciveBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [self addSubview:_reaciveBtn];
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
