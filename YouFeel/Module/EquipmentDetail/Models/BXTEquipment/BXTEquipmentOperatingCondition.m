//
//  BXTEquipmentOperatingCondition.m
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTEquipmentOperatingCondition.h"


NSString *const kBXTEquipmentOperatingConditionTitle = @"title";
NSString *const kBXTEquipmentOperatingConditionContent = @"content";


@interface BXTEquipmentOperatingCondition ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTEquipmentOperatingCondition

@synthesize title = _title;
@synthesize content = _content;


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
            self.title = [self objectOrNilForKey:kBXTEquipmentOperatingConditionTitle fromDictionary:dict];
            self.content = [self objectOrNilForKey:kBXTEquipmentOperatingConditionContent fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.title forKey:kBXTEquipmentOperatingConditionTitle];
    [mutableDict setValue:self.content forKey:kBXTEquipmentOperatingConditionContent];

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

    self.title = [aDecoder decodeObjectForKey:kBXTEquipmentOperatingConditionTitle];
    self.content = [aDecoder decodeObjectForKey:kBXTEquipmentOperatingConditionContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_title forKey:kBXTEquipmentOperatingConditionTitle];
    [aCoder encodeObject:_content forKey:kBXTEquipmentOperatingConditionContent];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTEquipmentOperatingCondition *copy = [[BXTEquipmentOperatingCondition alloc] init];
    
    if (copy) {

        copy.title = [self.title copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
    }
    
    return copy;
}


@end
