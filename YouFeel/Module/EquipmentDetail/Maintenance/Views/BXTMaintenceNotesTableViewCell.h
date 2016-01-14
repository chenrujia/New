//
//  BXTMaintenceNotesTableViewCell.h
//  YouFeel
//
//  Created by Jason on 16/1/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDeviceConfigInfo.h"

@interface BXTMaintenceNotesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notes;
@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageThree;

- (void)handleImages:(BXTDeviceConfigInfo *)deviceInfo;

@end
