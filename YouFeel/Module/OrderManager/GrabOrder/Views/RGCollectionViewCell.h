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

@property (strong, nonatomic) UIScrollView     *scrollView;
@property (strong, nonatomic) UIImageView      *imageView;
@property (strong, nonatomic) UILabel          *repairTime;
@property (strong, nonatomic) UILabel          *faulttype;
@property (strong, nonatomic) UILabel          *repairID;
@property (strong, nonatomic) UILabel          *location;
@property (strong, nonatomic) UILabel          *cause;
@property (strong, nonatomic) UILabel          *notes;
@property (strong, nonatomic) UILabel          *level;
@property (strong, nonatomic) UILabel          *remarks;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)requestDetailWithOrderID:(NSString *)orderID;

@end