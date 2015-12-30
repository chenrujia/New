//
//  BXTEquipmentParams.m
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTEquipmentParams.h"


NSString *const kBXTEquipmentParamsId = @"id";
NSString *const kBXTEquipmentParamsParamValue = @"param_value";
NSString *const kBXTEquipmentParamsParamKey = @"param_key";


@interface BXTEquipmentParams ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTEquipmentParams

@synthesize paramsIdentifier = _paramsIdentifier;
@synthesize paramValue = _paramValue;
@synthesize paramKey = _paramKey;


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
            self.paramsIdentifier = [self objectOrNilForKey:kBXTEquipmentParamsId fromDictionary:dict];
            self.paramValue = [self objectOrNilForKey:kBXTEquipmentParamsParamValue fromDictionary:dict];
            self.paramKey = [self objectOrNilForKey:kBXTEquipmentParamsParamKey fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.paramsIdentifier forKey:kBXTEquipmentParamsId];
    [mutableDict setValue:self.paramValue forKey:kBXTEquipmentParamsParamValue];
    [mutableDict setValue:self.paramKey forKey:kBXTEquipmentParamsParamKey];

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

    self.paramsIdentifier = [aDecoder decodeObjectForKey:kBXTEquipmentParamsId];
    self.paramValue = [aDecoder decodeObjectForKey:kBXTEquipmentParamsParamValue];
    self.paramKey = [aDecoder decodeObjectForKey:kBXTEquipmentParamsParamKey];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_paramsIdentifier forKey:kBXTEquipmentParamsId];
    [aCoder encodeObject:_paramValue forKey:kBXTEquipmentParamsParamValue];
    [aCoder encodeObject:_paramKey forKey:kBXTEquipmentParamsParamKey];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTEquipmentParams *copy = [[BXTEquipmentParams alloc] init];
    
    if (copy) {

        copy.paramsIdentifier = [self.paramsIdentifier copyWithZone:zone];
        copy.paramValue = [self.paramValue copyWithZone:zone];
        copy.paramKey = [self.paramKey copyWithZone:zone];
    }
    
    return copy;
}


@end
