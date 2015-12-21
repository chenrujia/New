//
//  BXTShopLocationViewController.h
//  BXT
//
//  Created by Jason on 15/8/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef void (^ChangeArea)();

@interface BXTShopLocationViewController : BXTBaseViewController

@property (nonatomic ,copy) ChangeArea selectAreaBlock;

- (instancetype)initWithIsResign:(BOOL)resign andBlock:(ChangeArea)selectArea;

@end
