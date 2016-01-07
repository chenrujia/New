//
//  BXTInspectionBase.m
//
//  Created by 孝意 满 on 16/1/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "BXTInspectionBase.h"
#import "BXTInspectionData.h"


NSString *const kBXTInspectionBaseNumber = @"number";
NSString *const kBXTInspectionBaseData = @"data";
NSString *const kBXTInspectionBaseCount = @"count";
NSString *const kBXTInspectionBaseCurrentPage = @"current_page";
NSString *const kBXTInspectionBaseReturncode = @"returncode";
NSString *const kBXTInspectionBaseTotalNumber = @"total_number";
NSString *const kBXTInspectionBaseTotalPages = @"total_pages";


@interface BXTInspectionBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTInspectionBase

@synthesize number = _number;
@synthesize data = _data;
@synthesize count = _count;
@synthesize currentPage = _currentPage;
@synthesize returncode = _returncode;
@synthesize totalNumber = _totalNumber;
@synthesize totalPages = _totalPages;


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
            self.number = [[self objectOrNilForKey:kBXTInspectionBaseNumber fromDictionary:dict] doubleValue];
    NSObject *receivedBXTInspectionData = [dict objectForKey:kBXTInspectionBaseData];
    NSMutableArray *parsedBXTInspectionData = [NSMutableArray array];
    if ([receivedBXTInspectionData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBXTInspectionData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBXTInspectionData addObject:[BXTInspectionData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBXTInspectionData isKindOfClass:[NSDictionary class]]) {
       [parsedBXTInspectionData addObject:[BXTInspectionData modelObjectWithDictionary:(NSDictionary *)receivedBXTInspectionData]];
    }

    self.data = [NSArray arrayWithArray:parsedBXTInspectionData];
            self.count = [[self objectOrNilForKey:kBXTInspectionBaseCount fromDictionary:dict] doubleValue];
            self.currentPage = [self objectOrNilForKey:kBXTInspectionBaseCurrentPage fromDictionary:dict];
            self.returncode = [self objectOrNilForKey:kBXTInspectionBaseReturncode fromDictionary:dict];
            self.totalNumber = [[self objectOrNilForKey:kBXTInspectionBaseTotalNumber fromDictionary:dict] doubleValue];
            self.totalPages = [[self objectOrNilForKey:kBXTInspectionBaseTotalPages fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.number] forKey:kBXTInspectionBaseNumber];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kBXTInspectionBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kBXTInspectionBaseCount];
    [mutableDict setValue:self.currentPage forKey:kBXTInspectionBaseCurrentPage];
    [mutableDict setValue:self.returncode forKey:kBXTInspectionBaseReturncode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalNumber] forKey:kBXTInspectionBaseTotalNumber];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalPages] forKey:kBXTInspectionBaseTotalPages];

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

    self.number = [aDecoder decodeDoubleForKey:kBXTInspectionBaseNumber];
    self.data = [aDecoder decodeObjectForKey:kBXTInspectionBaseData];
    self.count = [aDecoder decodeDoubleForKey:kBXTInspectionBaseCount];
    self.currentPage = [aDecoder decodeObjectForKey:kBXTInspectionBaseCurrentPage];
    self.returncode = [aDecoder decodeObjectForKey:kBXTInspectionBaseReturncode];
    self.totalNumber = [aDecoder decodeDoubleForKey:kBXTInspectionBaseTotalNumber];
    self.totalPages = [aDecoder decodeDoubleForKey:kBXTInspectionBaseTotalPages];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_number forKey:kBXTInspectionBaseNumber];
    [aCoder encodeObject:_data forKey:kBXTInspectionBaseData];
    [aCoder encodeDouble:_count forKey:kBXTInspectionBaseCount];
    [aCoder encodeObject:_currentPage forKey:kBXTInspectionBaseCurrentPage];
    [aCoder encodeObject:_returncode forKey:kBXTInspectionBaseReturncode];
    [aCoder encodeDouble:_totalNumber forKey:kBXTInspectionBaseTotalNumber];
    [aCoder encodeDouble:_totalPages forKey:kBXTInspectionBaseTotalPages];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTInspectionBase *copy = [[BXTInspectionBase alloc] init];
    
    if (copy) {

        copy.number = self.number;
        copy.data = [self.data copyWithZone:zone];
        copy.count = self.count;
        copy.currentPage = [self.currentPage copyWithZone:zone];
        copy.returncode = [self.returncode copyWithZone:zone];
        copy.totalNumber = self.totalNumber;
        copy.totalPages = self.totalPages;
    }
    
    return copy;
}


@end
