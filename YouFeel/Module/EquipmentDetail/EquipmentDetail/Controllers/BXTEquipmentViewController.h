//
//  EquipmentViewController.h
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef  NS_ENUM(NSInteger, PushType) {
    PushType_StartMaintain = 1,
    PushType_Scan,
    PushType_Other
};

@interface BXTEquipmentViewController : BXTBaseViewController

@property (nonatomic, assign) NSInteger pushType;

- (instancetype)initWithDeviceID:(NSString *)device_id orderID:(NSString *)orderID;

@end
