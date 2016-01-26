//
//  NewWorkMtOrderViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"

@interface BXTNewWorkMtOrderViewController : BXTPhotoBaseViewController

@property (nonatomic, strong) NSString *deviceID;

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
