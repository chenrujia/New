//
//  BXTEvaluationViewController.h
//  BXT
//
//  Created by Jason on 15/9/11.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
@import AssetsLibrary;
@import AVFoundation;
@import MobileCoreServices;

@interface BXTEvaluationViewController : BXTBaseViewController

@property (nonatomic ,strong) NSString *repairID;

- (instancetype)initWithRepairID:(NSString *)reID;

@end
