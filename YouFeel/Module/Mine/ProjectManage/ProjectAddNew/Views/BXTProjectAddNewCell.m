//
//  BXTHeadquartersTableViewCell.m
//  BXT
//
//  Created by Jason on 15/8/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTProjectAddNewCell.h"
#import "BXTPublicSetting.h"

@implementation BXTProjectAddNewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., SCREEN_WIDTH - 100, 30)];
        _nameLabel.font = [UIFont systemFontOfSize:16.];
        [self.contentView addSubview:_nameLabel];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20.f - 15.f, 15.f, 20.f, 20.f)];
        _rightImageView.image = [UIImage imageNamed:@"Locate"];
        [self.contentView addSubview:_rightImageView];
        
        _rightAddView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20.f - 15.f, 15.f, 20.f, 20.f)];
        _rightAddView.image = [UIImage imageNamed:@"add_to"];
        [self.contentView addSubview:_rightAddView];
        
        _switchbtn = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f - 10.f, 10, 60.f, 30.f)];
        _switchbtn.on = YES;
        [self.contentView addSubview:_switchbtn];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
