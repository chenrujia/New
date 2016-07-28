//
//  BXTMeterReadingViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"

@interface BXTMeterReadingViewController : BXTPhotoBaseViewController

@property (nonatomic, copy) NSString *transID;

/** ----  已解锁 ---- */
@property (nonatomic, assign) BOOL unlocked;

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
