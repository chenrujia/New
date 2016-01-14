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
    
}

- (void)handleImages:(BXTDeviceConfigInfo *)deviceInfo
{
    if (deviceInfo.pic.count == 0)
    {
        self.imageOne.hidden = YES;
        self.imageTwo.hidden = YES;
        self.imageThree.hidden = YES;
    }
    else if (deviceInfo.pic.count == 1)
    {
        self.imageOne.hidden = NO;
        NSDictionary *picOne = deviceInfo.pic[0];
        [self.imageOne sd_setImageWithURL:[NSURL URLWithString:[picOne objectForKey:@"photo_thumb_file"]]];
    }
    else if (deviceInfo.pic.count == 2)
    {
        self.imageOne.hidden = NO;
        self.imageTwo.hidden = NO;
        NSDictionary *picOne = deviceInfo.pic[0];
        [self.imageOne sd_setImageWithURL:[NSURL URLWithString:[picOne objectForKey:@"photo_thumb_file"]]];
        NSDictionary *picTwo = deviceInfo.pic[1];
        [self.imageTwo sd_setImageWithURL:[NSURL URLWithString:[picTwo objectForKey:@"photo_thumb_file"]]];
    }
    else if (deviceInfo.pic.count == 3)
    {
        self.imageOne.hidden = NO;
        self.imageTwo.hidden = NO;
        self.imageThree.hidden = NO;
        NSDictionary *picOne = deviceInfo.pic[0];
        [self.imageOne sd_setImageWithURL:[NSURL URLWithString:[picOne objectForKey:@"photo_thumb_file"]]];
        NSDictionary *picTwo = deviceInfo.pic[1];
        [self.imageTwo sd_setImageWithURL:[NSURL URLWithString:[picTwo objectForKey:@"photo_thumb_file"]]];
        NSDictionary *picThree = deviceInfo.pic[2];
        [self.imageThree sd_setImageWithURL:[NSURL URLWithString:[picThree objectForKey:@"photo_thumb_file"]]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
