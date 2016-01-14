//
//  BXTControlUserTableViewCell.h
//  YouFeel
//
//  Created by Jason on 16/1/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTControlUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userJob;
@property (weak, nonatomic) IBOutlet UILabel *userMoblie;
@property (weak, nonatomic) IBOutlet UIButton *connactTa;

@end
