//
//  BXTEquipmentFactoryInfo.m
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTEquipmentFactoryInfo.h"


NSString *const kBXTEquipmentFactoryInfoAddress = @"address";
NSString *const kBXTEquipmentFactoryInfoId = @"id";
NSString *const kBXTEquipmentFactoryInfoBread = @"bread";
NSString *const kBXTEquipmentFactoryInfoMobile = @"mobile";
NSString *const kBXTEquipmentFactoryInfoLinkman = @"linkman";
NSString *const kBXTEquipmentFactoryInfoFactoryName = @"factory_name";


@interface BXTEquipmentFactoryInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTEquipmentFactoryInfo

@synthesize address = _address;
@synthesize factoryInfoIdentifier = _factoryInfoIdentifier;
@synthesize bread = _bread;
@synthesize mobile = _mobile;
@synthesize linkman = _linkman;
@synthesize factoryName = _factoryName;


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
            self.address = [self objectOrNilForKey:kBXTEquipmentFactoryInfoAddress fromDictionary:dict];
            self.factoryInfoIdentifier = [self objectOrNilForKey:kBXTEquipmentFactoryInfoId fromDictionary:dict];
            self.bread = [self objectOrNilForKey:kBXTEquipmentFactoryInfoBread fromDictionary:dict];
            self.mobile = [self objectOrNilForKey:kBXTEquipmentFactoryInfoMobile fromDictionary:dict];
            self.linkman = [self objectOrNilForKey:kBXTEquipmentFactoryInfoLinkman fromDictionary:dict];
            self.factoryName = [self objectOrNilForKey:kBXTEquipmentFactoryInfoFactoryName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.address forKey:kBXTEquipmentFactoryInfoAddress];
    [mutableDict setValue:self.factoryInfoIdentifier forKey:kBXTEquipmentFactoryInfoId];
    [mutableDict setValue:self.bread forKey:kBXTEquipmentFactoryInfoBread];
    [mutableDict setValue:self.mobile forKey:kBXTEquipmentFactoryInfoMobile];
    [mutableDict setValue:self.linkman forKey:kBXTEquipmentFactoryInfoLinkman];
    [mutableDict setValue:self.factoryName forKey:kBXTEquipmentFactoryInfoFactoryName];

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

    self.address = [aDecoder decodeObjectForKey:kBXTEquipmentFactoryInfoAddress];
    self.factoryInfoIdentifier = [aDecoder decodeObjectForKey:kBXTEquipmentFactoryInfoId];
    self.bread = [aDecoder decodeObjectForKey:kBXTEquipmentFactoryInfoBread];
    self.mobile = [aDecoder decodeObjectForKey:kBXTEquipmentFactoryInfoMobile];
    self.linkman = [aDecoder decodeObjectForKey:kBXTEquipmentFactoryInfoLinkman];
    self.factoryName = [aDecoder decodeObjectForKey:kBXTEquipmentFactoryInfoFactoryName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_address forKey:kBXTEquipmentFactoryInfoAddress];
    [aCoder encodeObject:_factoryInfoIdentifier forKey:kBXTEquipmentFactoryInfoId];
    [aCoder encodeObject:_bread forKey:kBXTEquipmentFactoryInfoBread];
    [aCoder encodeObject:_mobile forKey:kBXTEquipmentFactoryInfoMobile];
    [aCoder encodeObject:_linkman forKey:kBXTEquipmentFactoryInfoLinkman];
    [aCoder encodeObject:_factoryName forKey:kBXTEquipmentFactoryInfoFactoryName];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTEquipmentFactoryInfo *copy = [[BXTEquipmentFactoryInfo alloc] init];
    
    if (copy) {

        copy.address = [self.address copyWithZone:zone];
        copy.factoryInfoIdentifier = [self.factoryInfoIdentifier copyWithZone:zone];
        copy.bread = [self.bread copyWithZone:zone];
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.linkman = [self.linkman copyWithZone:zone];
        copy.factoryName = [self.factoryName copyWithZone:zone];
    }
    
    return copy;
}


@end
