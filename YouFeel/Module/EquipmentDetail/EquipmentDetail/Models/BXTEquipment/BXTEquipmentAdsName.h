//
//  BXTEquipmentAdsName.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentAdsName : NSObject

@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *adsNameIdentifier;
@property (nonatomic, strong) NSString *stores_id;
@property (nonatomic, strong) NSString *stores_name;
@property (nonatomic, strong) NSString *area_name;
@property (nonatomic, strong) NSString *place_name;
@property (nonatomic, strong) NSString *place_id;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
