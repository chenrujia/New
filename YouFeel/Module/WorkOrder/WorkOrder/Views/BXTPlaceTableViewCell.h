//
//  BXTPlaceInfoTableViewCell.h
//  YouFeel
//
//  Created by Jason on 16/3/26.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTPlaceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_left;

@end
