//
//  BXTRemarksTableViewCell.h
//  BXT
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGEWIDTH 67.5f

@interface BXTRemarksTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel        *titleLabel;
@property (nonatomic ,strong) UIButton       *addBtn;
@property (nonatomic ,strong) UITextView     *remarkTV;
@property (nonatomic ,strong) UIImageView    *imgViewOne;
@property (nonatomic ,strong) UIImageView    *imgViewTwo;
@property (nonatomic ,strong) UIImageView    *imgViewThree;
@property (nonatomic ,strong) NSMutableArray *photosArray;

@end
