//
//  BXTCertificationManageViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTCertificationManageViewController : BXTBaseViewController

/** ---- 其他事物 - 进行中 ---- */
@property (nonatomic, assign) BOOL isRunning;

@property (copy, nonatomic) NSString *transID;
@property (nonatomic, copy) NSString *affairs_id;

@property (strong, nonatomic) RACSubject *delegateSignal;

@end
