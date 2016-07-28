//
//  BXTMeterReadingRecordViewController.h.h
//  YouFeel
//
//  Created by 满孝意 on 16/6/27.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyBaseViewController.h"

@interface BXTMeterReadingRecordViewController : BXTEnergyBaseViewController

@property (nonatomic, copy) NSString *transID;

/** ---- 解锁 ---- */
@property (nonatomic, assign) BOOL unlocked;

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
