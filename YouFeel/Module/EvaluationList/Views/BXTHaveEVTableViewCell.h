//
//  BXTHaveEVTableViewCell.h
//  YouFeel
//
//  Created by Jason on 15/10/16.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMRatingControl.h"

@interface BXTHaveEVTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel *repairID;
@property (nonatomic ,strong) UILabel *place;
@property (nonatomic ,strong) UILabel *cause;
@property (nonatomic ,strong) AMRatingControl *ratingControl;
@property (nonatomic ,strong) UILabel *notes;

@end
