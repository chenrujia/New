//
//  BXTMTAddImageCell.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTCustomImageView.h"

#define IMAGEWIDTH 67.5f

@interface BXTMTAddImageCell : UITableViewCell

@property (nonatomic ,strong) UILabel            *titleLabel;
@property (nonatomic ,strong) UIButton           *addBtn;
@property (nonatomic ,strong) BXTCustomImageView *imgViewOne;
@property (nonatomic ,strong) BXTCustomImageView *imgViewTwo;
@property (nonatomic ,strong) BXTCustomImageView *imgViewThree;

- (void)handleImagesFrame:(NSArray *)array;

@end
