//
//  BXTRemarksTableViewCell.h
//  BXT
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTCustomImageView.h"

#define IMAGEWIDTH 67.5f

@interface BXTRemarksTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel            *titleLabel;
@property (nonatomic ,strong) UIButton           *addBtn;
@property (nonatomic ,strong) UITextView         *remarkTV;
@property (nonatomic ,strong) BXTCustomImageView *imgViewOne;
@property (nonatomic ,strong) BXTCustomImageView *imgViewTwo;
@property (nonatomic ,strong) BXTCustomImageView *imgViewThree;
@property (nonatomic ,strong) NSMutableArray     *photosArray;

- (void)handleImagesFrame:(NSArray *)array;

@end
