//
//  BXTNewsTableViewCell.h
//  YouFeel
//
//  Created by Jason on 15/10/19.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTNewsTableViewCell : UITableViewCell

//@property (strong, nonatomic) UIImageView      *iconView;
//@property (strong, nonatomic) UILabel          *titleLabel;
//@property (strong, nonatomic) UILabel          *detailLabel;

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIButton *evaButton;
@property (nonatomic ,strong) UILabel *place;
@property (nonatomic ,strong) UILabel *cause;
@property (nonatomic ,strong) UILabel *orderState;

@end
