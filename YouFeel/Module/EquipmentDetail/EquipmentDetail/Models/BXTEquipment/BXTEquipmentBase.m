//
//  BXTEquipmentBase.m
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTEquipmentBase.h"
#import "BXTEquipmentData.h"


NSString *const kBXTEquipmentBaseReturncode = @"returncode";
NSString *const kBXTEquipmentBaseNumber = @"number";
NSString *const kBXTEquipmentBaseData = @"data";
NSString *const kBXTEquipmentBaseTotalNumber = @"total_number";


@interface BXTEquipmentBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTEquipmentBase

@synthesize returncode = _returncode;
@synthesize number = _number;
@synthesize data = _data;
@synthesize totalNumber = _totalNumber;


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
            self.returncode = [self objectOrNilForKey:kBXTEquipmentBaseReturncode fromDictionary:dict];
            self.number = [[self objectOrNilForKey:kBXTEquipmentBaseNumber fromDictionary:dict] doubleValue];
    NSObject *receivedBXTEquipmentData = [dict objectForKey:kBXTEquipmentBaseData];
    NSMutableArray *parsedBXTEquipmentData = [NSMutableArray array];
    if ([receivedBXTEquipmentData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBXTEquipmentData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBXTEquipmentData addObject:[BXTEquipmentData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBXTEquipmentData isKindOfClass:[NSDictionary class]]) {
       [parsedBXTEquipmentData addObject:[BXTEquipmentData modelObjectWithDictionary:(NSDictionary *)receivedBXTEquipmentData]];
    }

    self.data = [NSArray arrayWithArray:parsedBXTEquipmentData];
            self.totalNumber = [[self objectOrNilForKey:kBXTEquipmentBaseTotalNumber fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.returncode forKey:kBXTEquipmentBaseReturncode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.number] forKey:kBXTEquipmentBaseNumber];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kBXTEquipmentBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalNumber] forKey:kBXTEquipmentBaseTotalNumber];

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

    self.returncode = [aDecoder decodeObjectForKey:kBXTEquipmentBaseReturncode];
    self.number = [aDecoder decodeDoubleForKey:kBXTEquipmentBaseNumber];
    self.data = [aDecoder decodeObjectForKey:kBXTEquipmentBaseData];
    self.totalNumber = [aDecoder decodeDoubleForKey:kBXTEquipmentBaseTotalNumber];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_returncode forKey:kBXTEquipmentBaseReturncode];
    [aCoder encodeDouble:_number forKey:kBXTEquipmentBaseNumber];
    [aCoder encodeObject:_data forKey:kBXTEquipmentBaseData];
    [aCoder encodeDouble:_totalNumber forKey:kBXTEquipmentBaseTotalNumber];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTEquipmentBase *copy = [[BXTEquipmentBase alloc] init];
    
    if (copy) {

        copy.returncode = [self.returncode copyWithZone:zone];
        copy.number = self.number;
        copy.data = [self.data copyWithZone:zone];
        copy.totalNumber = self.totalNumber;
    }
    
    return copy;
}


@end
