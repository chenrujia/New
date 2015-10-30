//
//  BXTHomeCollectionViewCell.h
//  BXT
//
//  Created by Jason on 15/8/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *iconImgView;
@property (nonatomic ,strong) UIImage     *iconImage;
@property (nonatomic ,strong) UILabel     *namelabel;
@property (strong, nonatomic) UILabel     *redLabel;

- (void)newsRedNumber:(NSInteger)number;

@end
