//
//  BXTMeterReadingDailyDetailViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyBaseViewController.h"

@interface BXTMeterReadingDailyDetailViewController : BXTEnergyBaseViewController

@property (nonatomic, copy) NSString *transID;

@property (nonatomic, strong) RACSubject *delegateSignal;

/** ---- 解锁 ---- */
@property (nonatomic, assign) BOOL unlocked;

@end
