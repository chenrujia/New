//
//  BXTPhotosTableViewCell.h
//  YouFeel
//
//  Created by Jason on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTPhotosView.h"

@interface BXTPhotosTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) BXTPhotosView *photosView;

@end
