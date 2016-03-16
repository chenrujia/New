//
//  BXTCommentTableViewCell.h
//  YouFeel
//
//  Created by Jason on 16/3/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *feebackTime;
@property (weak, nonatomic) IBOutlet UILabel *feebackNotes;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UILabel *commentNotes;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (weak, nonatomic) IBOutlet UIView *qpBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bv_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bv_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notes_width;

@end
