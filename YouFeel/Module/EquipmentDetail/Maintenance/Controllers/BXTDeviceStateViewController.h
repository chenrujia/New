//
//  BXTDeviceStateViewController.h
//  YouFeel
//
//  Created by Jason on 16/3/3.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef void (^ChangeDeviceState)(NSString *name,NSString *state,NSString *notes);

@interface BXTDeviceStateViewController : BXTBaseViewController

@property (nonatomic, copy) ChangeDeviceState cdStateBlock;

- (instancetype)initWithArray:(NSArray *)array deviceState:(NSString *)state stateBlock:(ChangeDeviceState)block;

@end
