//
//  BXTInspectionData.m
//
//  Created by 孝意 满 on 16/1/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "BXTInspectionData.h"


NSString *const kBXTInspectionDataId = @"id";
NSString *const kBXTInspectionDataInspectionCode = @"inspection_code";
NSString *const kBXTInspectionDataState = @"state";
NSString *const kBXTInspectionDataFaulttypeName = @"faulttype_name";
NSString *const kBXTInspectionDataFaulttypeTypeName = @"faulttype_type_name";
NSString *const kBXTInspectionDataInspectionItemName = @"inspection_item_name";
NSString *const kBXTInspectionDataInspectionItemId = @"inspection_item_id";
NSString *const kBXTInspectionDataUserId = @"user_id";
NSString *const kBXTInspectionDataTaskId = @"task_id";
NSString *const kBXTInspectionDataRepairUser = @"repair_user";
NSString *const kBXTInspectionDataCreateTime = @"create_time";
NSString *const kBXTInspectionDataInspectionTime = @"inspection_time";
NSString *const kBXTInspectionDataWorkorderId = @"workorder_id";


@interface BXTInspectionData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTInspectionData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize inspectionCode = _inspectionCode;
@synthesize state = _state;
@synthesize faulttypeName = _faulttypeName;
@synthesize faulttypeTypeName = _faulttypeTypeName;
@synthesize inspectionItemName = _inspectionItemName;
@synthesize inspectionItemId = _inspectionItemId;
@synthesize userId = _userId;
@synthesize taskId = _taskId;
@synthesize repairUser = _repairUser;
@synthesize createTime = _createTime;
@synthesize inspectionTime = _inspectionTime;
@synthesize workorderId = _workorderId;


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
            self.dataIdentifier = [self objectOrNilForKey:kBXTInspectionDataId fromDictionary:dict];
            self.inspectionCode = [self objectOrNilForKey:kBXTInspectionDataInspectionCode fromDictionary:dict];
            self.state = [self objectOrNilForKey:kBXTInspectionDataState fromDictionary:dict];
            self.faulttypeName = [self objectOrNilForKey:kBXTInspectionDataFaulttypeName fromDictionary:dict];
            self.faulttypeTypeName = [self objectOrNilForKey:kBXTInspectionDataFaulttypeTypeName fromDictionary:dict];
            self.inspectionItemName = [self objectOrNilForKey:kBXTInspectionDataInspectionItemName fromDictionary:dict];
            self.inspectionItemId = [self objectOrNilForKey:kBXTInspectionDataInspectionItemId fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kBXTInspectionDataUserId fromDictionary:dict];
            self.taskId = [self objectOrNilForKey:kBXTInspectionDataTaskId fromDictionary:dict];
            self.repairUser = [self objectOrNilForKey:kBXTInspectionDataRepairUser fromDictionary:dict];
            self.createTime = [self objectOrNilForKey:kBXTInspectionDataCreateTime fromDictionary:dict];
            self.inspectionTime = [self objectOrNilForKey:kBXTInspectionDataInspectionTime fromDictionary:dict];
            self.workorderId = [self objectOrNilForKey:kBXTInspectionDataWorkorderId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dataIdentifier forKey:kBXTInspectionDataId];
    [mutableDict setValue:self.inspectionCode forKey:kBXTInspectionDataInspectionCode];
    [mutableDict setValue:self.state forKey:kBXTInspectionDataState];
    [mutableDict setValue:self.faulttypeName forKey:kBXTInspectionDataFaulttypeName];
    [mutableDict setValue:self.faulttypeTypeName forKey:kBXTInspectionDataFaulttypeTypeName];
    [mutableDict setValue:self.inspectionItemName forKey:kBXTInspectionDataInspectionItemName];
    [mutableDict setValue:self.inspectionItemId forKey:kBXTInspectionDataInspectionItemId];
    [mutableDict setValue:self.userId forKey:kBXTInspectionDataUserId];
    [mutableDict setValue:self.taskId forKey:kBXTInspectionDataTaskId];
    [mutableDict setValue:self.repairUser forKey:kBXTInspectionDataRepairUser];
    [mutableDict setValue:self.createTime forKey:kBXTInspectionDataCreateTime];
    [mutableDict setValue:self.inspectionTime forKey:kBXTInspectionDataInspectionTime];
    [mutableDict setValue:self.workorderId forKey:kBXTInspectionDataWorkorderId];

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

    self.dataIdentifier = [aDecoder decodeObjectForKey:kBXTInspectionDataId];
    self.inspectionCode = [aDecoder decodeObjectForKey:kBXTInspectionDataInspectionCode];
    self.state = [aDecoder decodeObjectForKey:kBXTInspectionDataState];
    self.faulttypeName = [aDecoder decodeObjectForKey:kBXTInspectionDataFaulttypeName];
    self.faulttypeTypeName = [aDecoder decodeObjectForKey:kBXTInspectionDataFaulttypeTypeName];
    self.inspectionItemName = [aDecoder decodeObjectForKey:kBXTInspectionDataInspectionItemName];
    self.inspectionItemId = [aDecoder decodeObjectForKey:kBXTInspectionDataInspectionItemId];
    self.userId = [aDecoder decodeObjectForKey:kBXTInspectionDataUserId];
    self.taskId = [aDecoder decodeObjectForKey:kBXTInspectionDataTaskId];
    self.repairUser = [aDecoder decodeObjectForKey:kBXTInspectionDataRepairUser];
    self.createTime = [aDecoder decodeObjectForKey:kBXTInspectionDataCreateTime];
    self.inspectionTime = [aDecoder decodeObjectForKey:kBXTInspectionDataInspectionTime];
    self.workorderId = [aDecoder decodeObjectForKey:kBXTInspectionDataWorkorderId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dataIdentifier forKey:kBXTInspectionDataId];
    [aCoder encodeObject:_inspectionCode forKey:kBXTInspectionDataInspectionCode];
    [aCoder encodeObject:_state forKey:kBXTInspectionDataState];
    [aCoder encodeObject:_faulttypeName forKey:kBXTInspectionDataFaulttypeName];
    [aCoder encodeObject:_faulttypeTypeName forKey:kBXTInspectionDataFaulttypeTypeName];
    [aCoder encodeObject:_inspectionItemName forKey:kBXTInspectionDataInspectionItemName];
    [aCoder encodeObject:_inspectionItemId forKey:kBXTInspectionDataInspectionItemId];
    [aCoder encodeObject:_userId forKey:kBXTInspectionDataUserId];
    [aCoder encodeObject:_taskId forKey:kBXTInspectionDataTaskId];
    [aCoder encodeObject:_repairUser forKey:kBXTInspectionDataRepairUser];
    [aCoder encodeObject:_createTime forKey:kBXTInspectionDataCreateTime];
    [aCoder encodeObject:_inspectionTime forKey:kBXTInspectionDataInspectionTime];
    [aCoder encodeObject:_workorderId forKey:kBXTInspectionDataWorkorderId];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTInspectionData *copy = [[BXTInspectionData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.inspectionCode = [self.inspectionCode copyWithZone:zone];
        copy.state = [self.state copyWithZone:zone];
        copy.faulttypeName = [self.faulttypeName copyWithZone:zone];
        copy.faulttypeTypeName = [self.faulttypeTypeName copyWithZone:zone];
        copy.inspectionItemName = [self.inspectionItemName copyWithZone:zone];
        copy.inspectionItemId = [self.inspectionItemId copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.taskId = [self.taskId copyWithZone:zone];
        copy.repairUser = [self.repairUser copyWithZone:zone];
        copy.createTime = [self.createTime copyWithZone:zone];
        copy.inspectionTime = [self.inspectionTime copyWithZone:zone];
        copy.workorderId = [self.workorderId copyWithZone:zone];
    }
    
    return copy;
}


@end
