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
@property (weak, nonatomic) IBOutlet UIView *photosBV;
@property (weak, nonatomic) IBOutlet UIView *deviceSelectBtnBV;
@property (weak, nonatomic) IBOutlet UIView *dateSelectBtnBV;
@property (weak, nonatomic) IBOutlet UIView *notesBV;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *notes_image;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *order_type_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notes_image_top;

- (IBAction)commitOrder:(id)sender;
- (IBAction)switchValueChanged:(id)sender;

@end
