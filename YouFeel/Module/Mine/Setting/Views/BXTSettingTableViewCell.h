//
//  BXTSettingTableViewCell.h
//  BXT
//
//  Created by Jason on 15/8/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTSettingTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel     *titleLabel;
@property (nonatomic ,strong) UILabel     *detailLable;
@property (nonatomic ,strong) UILabel     *auditStatusLabel;
@property (nonatomic ,strong) UITextField *detailTF;
@property (nonatomic ,strong) UIImageView *checkImgView;
@property (nonatomic ,strong) UIButton    *emergencyBtn;//紧急
@property (nonatomic ,strong) UIButton    *normelBtn;//一般
@property (nonatomic ,strong) UISwitch    *switchbtn;
@property (nonatomic ,strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *phoneLabel;
//是否显示checkImgView
@property (nonatomic, assign) BOOL        isShow;

@end
