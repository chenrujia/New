//
//  BXTFloorInfo.h
//  BXT
//
//  Created by Jason on 15/8/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTAreaInfo,BXTShopInfo;
@interface BXTFloorInfo : NSObject

@property (nonatomic ,copy) NSString *area_id;
@property (nonatomic ,copy) NSString *area_name;
@property (nonatomic ,strong) NSArray<BXTAreaInfo *> *place;

@end

@interface BXTAreaInfo : NSObject

@property (nonatomic ,copy) NSString *place_id;
@property (nonatomic ,copy) NSString *place_name;
@property (nonatomic ,strong) NSArray<BXTShopInfo *> *stores;

@end

@interface BXTShopInfo : NSObject

@property (nonatomic ,copy) NSString *stores_id;
@property (nonatomic ,copy) NSString *stores_name;

@end
