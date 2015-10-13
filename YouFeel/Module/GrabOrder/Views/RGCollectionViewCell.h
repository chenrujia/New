//
//  RGCollectionViewCell.h
//  RGCardViewLayout
//
//  Created by ROBERA GELETA on 1/23/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDataRequest.h"
@import AVFoundation.AVAudioPlayer;

typedef void (^UpdateTimeNumber)(NSInteger time);

@interface RGCollectionViewCell : UICollectionViewCell<BXTDataResponseDelegate>
{
    AVAudioPlayer *player;
    NSInteger count;
    BOOL isUpdated;
    UpdateTimeNumber timeNumber;
}

@property (strong, nonatomic) UIImageView      *imageView;
@property (strong, nonatomic) UILabel          *repairID;
@property (strong, nonatomic) UILabel          *location;
@property (strong, nonatomic) UILabel          *cause;
@property (strong, nonatomic) UILabel          *level;
@property (strong, nonatomic) UILabel          *coinLabel;

- (void)loadTimeBlock:(UpdateTimeNumber)block;
- (void)removeBlock;

@end