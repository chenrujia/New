//
//  BXTMessageListTableViewCell.h
//  YouFeel
//
//  Created by Jason on 15/10/22.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMessageListTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView      *iconView;
@property (strong, nonatomic) UILabel          *redLabel;
@property (strong, nonatomic) UILabel          *titleLabel;
@property (strong, nonatomic) UILabel          *detailLabel;

- (void)newsRedNumber:(NSInteger)number;

@end
