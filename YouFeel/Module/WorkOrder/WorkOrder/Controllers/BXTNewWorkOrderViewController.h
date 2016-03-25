//
//  BXTNewWorkOrderViewController.h
//  YouFeel
//
//  Created by Jason on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"

@interface BXTNewWorkOrderViewController : BXTPhotoBaseViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *orderTypeBV;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *order_type_height;

- (IBAction)commitOrder:(id)sender;

@end
