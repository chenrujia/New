//
//  BXTEquipmentControlUserArr.m
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTEquipmentControlUserArr.h"


NSString *const kBXTEquipmentControlUserArrMobile = @"mobile";
NSString *const kBXTEquipmentControlUserArrId = @"id";
NSString *const kBXTEquipmentControlUserArrRole = @"role";
NSString *const kBXTEquipmentControlUserArrHeadPic = @"head_pic";
NSString *const kBXTEquipmentControlUserArrOutUserid = @"out_userid";
NSString *const kBXTEquipmentControlUserArrDepartment = @"department";
NSString *const kBXTEquipmentControlUserArrName = @"name";


@interface BXTEquipmentControlUserArr ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTEquipmentControlUserArr

@synthesize mobile = _mobile;
@synthesize controlUserArrIdentifier = _controlUserArrIdentifier;
@synthesize role = _role;
@synthesize headPic = _headPic;
@synthesize outUserid = _outUserid;
@synthesize department = _department;
@synthesize name = _name;


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
            self.mobile = [self objectOrNilForKey:kBXTEquipmentControlUserArrMobile fromDictionary:dict];
            self.controlUserArrIdentifier = [self objectOrNilForKey:kBXTEquipmentControlUserArrId fromDictionary:dict];
            self.role = [self objectOrNilForKey:kBXTEquipmentControlUserArrRole fromDictionary:dict];
            self.headPic = [self objectOrNilForKey:kBXTEquipmentControlUserArrHeadPic fromDictionary:dict];
            self.outUserid = [self objectOrNilForKey:kBXTEquipmentControlUserArrOutUserid fromDictionary:dict];
            self.department = [self objectOrNilForKey:kBXTEquipmentControlUserArrDepartment fromDictionary:dict];
            self.name = [self objectOrNilForKey:kBXTEquipmentControlUserArrName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.mobile forKey:kBXTEquipmentControlUserArrMobile];
    [mutableDict setValue:self.controlUserArrIdentifier forKey:kBXTEquipmentControlUserArrId];
    [mutableDict setValue:self.role forKey:kBXTEquipmentControlUserArrRole];
    [mutableDict setValue:self.headPic forKey:kBXTEquipmentControlUserArrHeadPic];
    [mutableDict setValue:self.outUserid forKey:kBXTEquipmentControlUserArrOutUserid];
    [mutableDict setValue:self.department forKey:kBXTEquipmentControlUserArrDepartment];
    [mutableDict setValue:self.name forKey:kBXTEquipmentControlUserArrName];

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

    self.mobile = [aDecoder decodeObjectForKey:kBXTEquipmentControlUserArrMobile];
    self.controlUserArrIdentifier = [aDecoder decodeObjectForKey:kBXTEquipmentControlUserArrId];
    self.role = [aDecoder decodeObjectForKey:kBXTEquipmentControlUserArrRole];
    self.headPic = [aDecoder decodeObjectForKey:kBXTEquipmentControlUserArrHeadPic];
    self.outUserid = [aDecoder decodeObjectForKey:kBXTEquipmentControlUserArrOutUserid];
    self.department = [aDecoder decodeObjectForKey:kBXTEquipmentControlUserArrDepartment];
    self.name = [aDecoder decodeObjectForKey:kBXTEquipmentControlUserArrName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_mobile forKey:kBXTEquipmentControlUserArrMobile];
    [aCoder encodeObject:_controlUserArrIdentifier forKey:kBXTEquipmentControlUserArrId];
    [aCoder encodeObject:_role forKey:kBXTEquipmentControlUserArrRole];
    [aCoder encodeObject:_headPic forKey:kBXTEquipmentControlUserArrHeadPic];
    [aCoder encodeObject:_outUserid forKey:kBXTEquipmentControlUserArrOutUserid];
    [aCoder encodeObject:_department forKey:kBXTEquipmentControlUserArrDepartment];
    [aCoder encodeObject:_name forKey:kBXTEquipmentControlUserArrName];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTEquipmentControlUserArr *copy = [[BXTEquipmentControlUserArr alloc] init];
    
    if (copy) {

        copy.mobile = [self.mobile copyWithZone:zone];
        copy.controlUserArrIdentifier = [self.controlUserArrIdentifier copyWithZone:zone];
        copy.role = [self.role copyWithZone:zone];
        copy.headPic = [self.headPic copyWithZone:zone];
        copy.outUserid = [self.outUserid copyWithZone:zone];
        copy.department = [self.department copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
