//
//  BXTShopLocationViewController.h
//  BXT
//
//  Created by Jason on 15/8/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTFloorInfo.h"
#import "BXTAreaInfo.h"

typedef void (^ChangeArea)(BXTFloorInfo *floorInfo,BXTAreaInfo *areaInfo);

@interface BXTShopLocationViewController : BXTBaseViewController

@property (nonatomic ,copy) ChangeArea selectAreaBlock;

- (instancetype)initWithPublic:(BOOL)is_public changeArea:(ChangeArea)selectArea;

@end
