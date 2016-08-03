//
//  BXTLoginViewController.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTLoginViewController : BXTBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *wxLogin;
@property (weak, nonatomic) IBOutlet UIButton *userNameCancel;
@property (weak, nonatomic) IBOutlet UIButton *passWordCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wx_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_y;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *login_back_y;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIView *loginBackView;

- (IBAction)resignUser:(id)sender;
- (IBAction)findPassword:(id)sender;

@end
