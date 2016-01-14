//
//  BXTDeviceInfoTableViewCell.h
//  YouFeel
//
//  Created by Jason on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTDeviceInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumber;
@property (weak, nonatomic) IBOutlet UILabel *deviceSystem;
@property (weak, nonatomic) IBOutlet UILabel *maintenanceProject;
@property (weak, nonatomic) IBOutlet UILabel *maintenancePlane;
@property (weak, nonatomic) IBOutlet UILabel *orderState;

@end
