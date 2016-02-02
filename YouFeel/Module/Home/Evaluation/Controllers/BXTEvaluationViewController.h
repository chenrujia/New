//
//  BXTEvaluationViewController.h
//  BXT
//
//  Created by Jason on 15/9/11.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"

@interface BXTEvaluationViewController : BXTPhotoBaseViewController

@property (nonatomic ,strong) NSString *repairID;
@property (nonatomic, strong) RACSubject *delegateSignal;

- (instancetype)initWithRepairID:(NSString *)reID;

@end
