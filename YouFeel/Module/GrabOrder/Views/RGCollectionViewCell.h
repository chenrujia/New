//
//  RGCollectionViewCell.h
//  RGCardViewLayout
//
//  Created by ROBERA GELETA on 1/23/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDataRequest.h"

@interface RGCollectionViewCell : UICollectionViewCell<BXTDataResponseDelegate>

@property (strong, nonatomic) UIImageView      *imageView;
@property (strong, nonatomic) UILabel          *repairID;
@property (strong, nonatomic) UILabel          *location;
@property (strong, nonatomic) UILabel          *cause;
@property (strong, nonatomic) UILabel          *level;
//@property (strong, nonatomic) UIView           *backView;
//@property (strong, nonatomic) UILabel          *coinLabel;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)requestDetailWithOrderID:(NSString *)orderID;

@end