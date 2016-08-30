//
//  BXTNewOrderViewController.h
//  YouFeel
//
//  Created by Jason on 15/11/12.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTDetailBaseViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface BXTNewOrderViewController : BXTDetailBaseViewController

@property (weak, nonatomic) IBOutlet UIView      *contentView;
@property (weak, nonatomic) IBOutlet UIView      *first_bg_view;
@property (weak, nonatomic) IBOutlet UIView      *second_bg_view;
@property (weak, nonatomic) IBOutlet UIView      *third_bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *repairHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel     *repairNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *departmentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel     *repairTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel     *placeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *appointmentImgView;
@property (weak, nonatomic) IBOutlet UIView      *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel     *dispathName;
@property (weak, nonatomic) IBOutlet UILabel     *departmentName;
@property (weak, nonatomic) IBOutlet UILabel     *jobName;
@property (weak, nonatomic) IBOutlet UILabel     *faultTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repairContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *second_view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *third_view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *job_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *job_name_width;
- (IBAction)rejectOrder:(id)sender;
- (IBAction)reaciveOrder:(id)sender;

@end
