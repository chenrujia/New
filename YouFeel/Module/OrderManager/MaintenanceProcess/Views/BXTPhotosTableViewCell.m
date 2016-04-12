//
//  BXTPhotosTableViewCell.m
//  YouFeel
//
//  Created by Jason on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotosTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "BXTPublicSetting.h"

@implementation BXTPhotosTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel = ({
        
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:17.f];
            [self addSubview:label];
            
            label.sd_layout
            .leftSpaceToView(self,15)
            .topSpaceToView(self,8)
            .widthIs(100.f)
            .heightIs(20.f);
            
            label;
        
        });
        
        self.photosView = ({
            
            BXTPhotosView *photoView = [[BXTPhotosView alloc] init];
            [self addSubview:photoView];
            
            photoView.sd_layout
            .leftSpaceToView(self,0)
            .topSpaceToView(self.titleLabel,8)
            .widthIs(SCREEN_WIDTH)
            .heightIs(64.f);
            
            photoView;
            
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
