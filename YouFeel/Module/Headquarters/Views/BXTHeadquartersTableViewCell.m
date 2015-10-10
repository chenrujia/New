//
//  BXTHeadquartersTableViewCell.m
//  BXT
//
//  Created by Jason on 15/8/20.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTHeadquartersTableViewCell.h"
#import "BXTPublicSetting.h"

@implementation BXTHeadquartersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 0., 160.f, 44)];
        _nameLabel.font = [UIFont systemFontOfSize:16.];
        [self.contentView addSubview:_nameLabel];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20.f - 15.f, 12.f, 20.f, 20.f)];
        _rightImageView.image = [UIImage imageNamed:@"Locate"];
        [self.contentView addSubview:_rightImageView];
        
        _switchbtn = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f - 10.f, 7, 60.f, 30.f)];
        _switchbtn.on = YES;
        [self.contentView addSubview:_switchbtn];
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
