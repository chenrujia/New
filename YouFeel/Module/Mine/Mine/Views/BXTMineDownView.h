//
//  BXTMineDownView.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTMineInfo.h"

@interface BXTMineDownView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *firstStarView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdStarView;

@property (strong, nonatomic) BXTMineInfo *mineInfo;

@end
