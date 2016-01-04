//
//  BXTCurrentOrderBase.m
//
//  Created by 孝意 满 on 15/12/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTCurrentOrderBase.h"
#import "BXTCurrentOrderData.h"


NSString *const kBXTCurrentOrderBasePage = @"page";
NSString *const kBXTCurrentOrderBaseNumber = @"number";
NSString *const kBXTCurrentOrderBasePages = @"pages";
NSString *const kBXTCurrentOrderBaseData = @"data";
NSString *const kBXTCurrentOrderBaseReturncode = @"returncode";
NSString *const kBXTCurrentOrderBaseTotalNumber = @"total_number";


@interface BXTCurrentOrderBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTCurrentOrderBase

@synthesize page = _page;
@synthesize number = _number;
@synthesize pages = _pages;
@synthesize data = _data;
@synthesize returncode = _returncode;
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
            self.page = [self objectOrNilForKey:kBXTCurrentOrderBasePage fromDictionary:dict];
            self.number = [[self objectOrNilForKey:kBXTCurrentOrderBaseNumber fromDictionary:dict] doubleValue];
            self.pages = [self objectOrNilForKey:kBXTCurrentOrderBasePages fromDictionary:dict];
    NSObject *receivedBXTCurrentOrderData = [dict objectForKey:kBXTCurrentOrderBaseData];
    NSMutableArray *parsedBXTCurrentOrderData = [NSMutableArray array];
    if ([receivedBXTCurrentOrderData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBXTCurrentOrderData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBXTCurrentOrderData addObject:[BXTCurrentOrderData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBXTCurrentOrderData isKindOfClass:[NSDictionary class]]) {
       [parsedBXTCurrentOrderData addObject:[BXTCurrentOrderData modelObjectWithDictionary:(NSDictionary *)receivedBXTCurrentOrderData]];
    }

    self.data = [NSArray arrayWithArray:parsedBXTCurrentOrderData];
            self.returncode = [self objectOrNilForKey:kBXTCurrentOrderBaseReturncode fromDictionary:dict];
            self.totalNumber = [[self objectOrNilForKey:kBXTCurrentOrderBaseTotalNumber fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.page forKey:kBXTCurrentOrderBasePage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.number] forKey:kBXTCurrentOrderBaseNumber];
    [mutableDict setValue:self.pages forKey:kBXTCurrentOrderBasePages];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kBXTCurrentOrderBaseData];
    [mutableDict setValue:self.returncode forKey:kBXTCurrentOrderBaseReturncode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalNumber] forKey:kBXTCurrentOrderBaseTotalNumber];

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

    self.page = [aDecoder decodeObjectForKey:kBXTCurrentOrderBasePage];
    self.number = [aDecoder decodeDoubleForKey:kBXTCurrentOrderBaseNumber];
    self.pages = [aDecoder decodeObjectForKey:kBXTCurrentOrderBasePages];
    self.data = [aDecoder decodeObjectForKey:kBXTCurrentOrderBaseData];
    self.returncode = [aDecoder decodeObjectForKey:kBXTCurrentOrderBaseReturncode];
    self.totalNumber = [aDecoder decodeDoubleForKey:kBXTCurrentOrderBaseTotalNumber];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_page forKey:kBXTCurrentOrderBasePage];
    [aCoder encodeDouble:_number forKey:kBXTCurrentOrderBaseNumber];
    [aCoder encodeObject:_pages forKey:kBXTCurrentOrderBasePages];
    [aCoder encodeObject:_data forKey:kBXTCurrentOrderBaseData];
    [aCoder encodeObject:_returncode forKey:kBXTCurrentOrderBaseReturncode];
    [aCoder encodeDouble:_totalNumber forKey:kBXTCurrentOrderBaseTotalNumber];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTCurrentOrderBase *copy = [[BXTCurrentOrderBase alloc] init];
    
    if (copy) {

        copy.page = [self.page copyWithZone:zone];
        copy.number = self.number;
        copy.pages = [self.pages copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
        copy.returncode = [self.returncode copyWithZone:zone];
        copy.totalNumber = self.totalNumber;
    }
    
    return copy;
}


@end
