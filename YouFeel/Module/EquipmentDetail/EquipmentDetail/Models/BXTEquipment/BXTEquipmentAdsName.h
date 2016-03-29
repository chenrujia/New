//
//  BXTEquipmentAdsName.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentAdsName : NSObject

@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *adsNameIdentifier;
@property (nonatomic, copy) NSString *stores_id;
@property (nonatomic, copy) NSString *stores_name;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *place_name;
@property (nonatomic, copy) NSString *place_id;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
