//
//  BXTGrabOrderViewController.h
//  YFBX
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTDetailBaseViewController.h"

@interface BXTGrabOrderViewController : BXTDetailBaseViewController

@property (weak, nonatomic) IBOutlet UIView      *contentView;
@property (weak, nonatomic) IBOutlet UIView      *first_bg_view;
@property (weak, nonatomic) IBOutlet UIView      *second_bg_view;
@property (weak, nonatomic) IBOutlet UIView      *third_bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel     *repairName;
@property (weak, nonatomic) IBOutlet UILabel     *departmantName;
@property (weak, nonatomic) IBOutlet UILabel     *jobName;
@property (weak, nonatomic) IBOutlet UIView      *lineView;
@property (weak, nonatomic) IBOutlet UILabel     *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel     *repairTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *hoursTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *faultTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *repairContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *appointmentImgView;
@property (weak, nonatomic) IBOutlet UIImageView *urgentImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *second_view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *third_view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *job_width;

- (IBAction)grabOrder:(id)sender;

@end
