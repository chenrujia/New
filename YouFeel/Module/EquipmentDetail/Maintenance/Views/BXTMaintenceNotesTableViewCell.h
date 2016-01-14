//
//  BXTMaintenceNotesTableViewCell.h
//  YouFeel
//
//  Created by Jason on 16/1/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMaintenceNotesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notes;
@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageThree;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_one_x;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_two_x;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_three_x;


@end
