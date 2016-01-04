//
//  BXTEquipmentAdsName.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTEquipmentAdsName : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *adsNameIdentifier;
@property (nonatomic, strong) NSString *storesId;
@property (nonatomic, strong) NSString *storesName;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
