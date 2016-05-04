//
//  BXTMaintenceNotesTableViewCell.m
//  YouFeel
//
//  Created by Jason on 16/1/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenceNotesTableViewCell.h"
#import "BXTPublicSetting.h"
#import "UIImageView+WebCache.h"

@implementation BXTMaintenceNotesTableViewCell

- (void)awakeFromNib
{
    self.imageOne.layer.masksToBounds = YES;
    self.imageTwo.layer.masksToBounds = YES;
    self.imageThree.layer.masksToBounds = YES;
}

- (void)handleImages:(BXTDeviceMaintenceInfo *)maintenceInfo
{
    if (maintenceInfo.pic.count == 0)
    {
        self.imageOne.hidden = YES;
        self.imageTwo.hidden = YES;
        self.imageThree.hidden = YES;
    }
    else if (maintenceInfo.pic.count == 1)
    {
        self.imageOne.hidden = NO;
        BXTFaultPicInfo *faultInfo = maintenceInfo.pic[0];
        [self.imageOne sd_setImageWithURL:[NSURL URLWithString:faultInfo.photo_thumb_file]];
    }
    else if (maintenceInfo.pic.count == 2)
    {
        self.imageOne.hidden = NO;
        self.imageTwo.hidden = NO;
        BXTFaultPicInfo *faultInfoOne = maintenceInfo.pic[0];
        [self.imageOne sd_setImageWithURL:[NSURL URLWithString:faultInfoOne.photo_thumb_file]];
        BXTFaultPicInfo *faultInfoTwo = maintenceInfo.pic[1];
        [self.imageTwo sd_setImageWithURL:[NSURL URLWithString:faultInfoTwo.photo_thumb_file]];
    }
    else if (maintenceInfo.pic.count == 3)
    {
        self.imageOne.hidden = NO;
        self.imageTwo.hidden = NO;
        self.imageThree.hidden = NO;
        BXTFaultPicInfo *faultInfoOne = maintenceInfo.pic[0];
        [self.imageOne sd_setImageWithURL:[NSURL URLWithString:faultInfoOne.photo_thumb_file]];
        BXTFaultPicInfo *faultInfoTwo = maintenceInfo.pic[1];
        [self.imageTwo sd_setImageWithURL:[NSURL URLWithString:faultInfoTwo.photo_thumb_file]];
        BXTFaultPicInfo *faultInfoThree = maintenceInfo.pic[2];
        [self.imageThree sd_setImageWithURL:[NSURL URLWithString:faultInfoThree.photo_thumb_file]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
