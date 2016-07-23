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

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
