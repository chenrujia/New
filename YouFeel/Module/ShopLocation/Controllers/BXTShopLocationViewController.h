//
//  BXTShopLocationViewController.h
//  BXT
//
//  Created by Jason on 15/8/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

typedef NS_ENUM(NSInteger, PushType) {
    PushType_BindingAddress = 1,
    PushType_CreateOrder
};

#import "BXTBaseViewController.h"

typedef void (^ChangeArea)();

@interface BXTShopLocationViewController : BXTBaseViewController

@property (nonatomic ,copy) ChangeArea selectAreaBlock;

- (instancetype)initWithIsResign:(BOOL)resign andBlock:(ChangeArea)selectArea;

@property (nonatomic, assign) NSInteger whichPush;
@property (nonatomic, strong) RACSubject *delegateSignal;

@end
