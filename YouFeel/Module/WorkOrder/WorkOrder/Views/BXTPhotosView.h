//
//  BXTPhotosView.h
//  YouFeel
//
//  Created by Jason on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTCustomImageView.h"

static CGFloat const GImageHeight = 64.f;

@interface BXTPhotosView : UIView

@property (nonatomic ,strong) UIButton           *addBtn;
@property (nonatomic ,strong) BXTCustomImageView *imgViewOne;
@property (nonatomic ,strong) BXTCustomImageView *imgViewTwo;
@property (nonatomic ,strong) BXTCustomImageView *imgViewThree;

- (void)handleImagesFrame:(NSArray *)array;

@end
