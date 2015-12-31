//
//  BXTEquipmentAdsName.m
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTEquipmentAdsName.h"


NSString *const kBXTEquipmentAdsNameAreaId = @"area_id";
NSString *const kBXTEquipmentAdsNameId = @"id";
NSString *const kBXTEquipmentAdsNameStoresId = @"stores_id";
NSString *const kBXTEquipmentAdsNameStoresName = @"stores_name";
NSString *const kBXTEquipmentAdsNameAreaName = @"area_name";
NSString *const kBXTEquipmentAdsNamePlaceName = @"place_name";
NSString *const kBXTEquipmentAdsNamePlaceId = @"place_id";


@interface BXTEquipmentAdsName ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTEquipmentAdsName

@synthesize areaId = _areaId;
@synthesize adsNameIdentifier = _adsNameIdentifier;
@synthesize storesId = _storesId;
@synthesize storesName = _storesName;
@synthesize areaName = _areaName;
@synthesize placeName = _placeName;
@synthesize placeId = _placeId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.areaId = [self objectOrNilForKey:kBXTEquipmentAdsNameAreaId fromDictionary:dict];
            self.adsNameIdentifier = [self objectOrNilForKey:kBXTEquipmentAdsNameId fromDictionary:dict];
            self.storesId = [self objectOrNilForKey:kBXTEquipmentAdsNameStoresId fromDictionary:dict];
            self.storesName = [self objectOrNilForKey:kBXTEquipmentAdsNameStoresName fromDictionary:dict];
            self.areaName = [self objectOrNilForKey:kBXTEquipmentAdsNameAreaName fromDictionary:dict];
            self.placeName = [self objectOrNilForKey:kBXTEquipmentAdsNamePlaceName fromDictionary:dict];
            self.placeId = [self objectOrNilForKey:kBXTEquipmentAdsNamePlaceId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.areaId forKey:kBXTEquipmentAdsNameAreaId];
    [mutableDict setValue:self.adsNameIdentifier forKey:kBXTEquipmentAdsNameId];
    [mutableDict setValue:self.storesId forKey:kBXTEquipmentAdsNameStoresId];
    [mutableDict setValue:self.storesName forKey:kBXTEquipmentAdsNameStoresName];
    [mutableDict setValue:self.areaName forKey:kBXTEquipmentAdsNameAreaName];
    [mutableDict setValue:self.placeName forKey:kBXTEquipmentAdsNamePlaceName];
    [mutableDict setValue:self.placeId forKey:kBXTEquipmentAdsNamePlaceId];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.areaId = [aDecoder decodeObjectForKey:kBXTEquipmentAdsNameAreaId];
    self.adsNameIdentifier = [aDecoder decodeObjectForKey:kBXTEquipmentAdsNameId];
    self.storesId = [aDecoder decodeObjectForKey:kBXTEquipmentAdsNameStoresId];
    self.storesName = [aDecoder decodeObjectForKey:kBXTEquipmentAdsNameStoresName];
    self.areaName = [aDecoder decodeObjectForKey:kBXTEquipmentAdsNameAreaName];
    self.placeName = [aDecoder decodeObjectForKey:kBXTEquipmentAdsNamePlaceName];
    self.placeId = [aDecoder decodeObjectForKey:kBXTEquipmentAdsNamePlaceId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_areaId forKey:kBXTEquipmentAdsNameAreaId];
    [aCoder encodeObject:_adsNameIdentifier forKey:kBXTEquipmentAdsNameId];
    [aCoder encodeObject:_storesId forKey:kBXTEquipmentAdsNameStoresId];
    [aCoder encodeObject:_storesName forKey:kBXTEquipmentAdsNameStoresName];
    [aCoder encodeObject:_areaName forKey:kBXTEquipmentAdsNameAreaName];
    [aCoder encodeObject:_placeName forKey:kBXTEquipmentAdsNamePlaceName];
    [aCoder encodeObject:_placeId forKey:kBXTEquipmentAdsNamePlaceId];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTEquipmentAdsName *copy = [[BXTEquipmentAdsName alloc] init];
    
    if (copy) {

        copy.areaId = [self.areaId copyWithZone:zone];
        copy.adsNameIdentifier = [self.adsNameIdentifier copyWithZone:zone];
        copy.storesId = [self.storesId copyWithZone:zone];
        copy.storesName = [self.storesName copyWithZone:zone];
        copy.areaName = [self.areaName copyWithZone:zone];
        copy.placeName = [self.placeName copyWithZone:zone];
        copy.placeId = [self.placeId copyWithZone:zone];
    }
    
    return copy;
}


@end
