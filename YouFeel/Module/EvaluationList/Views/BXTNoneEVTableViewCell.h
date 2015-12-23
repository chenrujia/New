//
//  BXTNoneEVTableViewCell.h
//  YouFeel
//
//  Created by Jason on 15/10/16.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTNoneEVTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel  *repairID;
@property (nonatomic ,strong) UIButton *evaButton;
@property (nonatomic ,strong) UILabel  *place;
@property (nonatomic ,strong) UILabel  *cause;
@property (nonatomic ,strong) UIView   *imgBackView;
@property (nonatomic ,strong) UILabel  *repairState;
@property (nonatomic ,strong) UILabel  *consumeTime;
@property (nonatomic ,strong) UIView   *line;
@property (nonatomic ,strong) NSArray  *picsArray;

- (void)reloadImageBackView;

@end
