//
//  BXTSearchData.m
//
//  Created by 孝意 满 on 16/1/5
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "BXTSearchData.h"


NSString *const kBXTSearchDataId = @"id";
NSString *const kBXTSearchDataRoleId = @"role_id";
NSString *const kBXTSearchDataName = @"name";
NSString *const kBXTSearchDataEmail = @"email";
NSString *const kBXTSearchDataHead = @"head";
NSString *const kBXTSearchDataMobile = @"mobile";
NSString *const kBXTSearchDataDelTime = @"del_time";
NSString *const kBXTSearchDataShopsId = @"shops_id";
NSString *const kBXTSearchDataRoleName = @"role_name";
NSString *const kBXTSearchDataUserId = @"user_id";
NSString *const kBXTSearchDataNameShort = @"name_short";
NSString *const kBXTSearchDataOutUserid = @"out_userid";
NSString *const kBXTSearchDataSubgroupName = @"subgroup_name";
NSString *const kBXTSearchDataDirectoryId = @"directory_id";
NSString *const kBXTSearchDataDelState = @"del_state";
NSString *const kBXTSearchDataDelUser = @"del_user";
NSString *const kBXTSearchDataGender = @"gender";
NSString *const kBXTSearchDataSubgroup = @"subgroup";


@interface BXTSearchData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTSearchData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize roleId = _roleId;
@synthesize name = _name;
@synthesize email = _email;
@synthesize head = _head;
@synthesize mobile = _mobile;
@synthesize delTime = _delTime;
@synthesize shopsId = _shopsId;
@synthesize roleName = _roleName;
@synthesize userId = _userId;
@synthesize nameShort = _nameShort;
@synthesize outUserid = _outUserid;
@synthesize subgroupName = _subgroupName;
@synthesize directoryId = _directoryId;
@synthesize delState = _delState;
@synthesize delUser = _delUser;
@synthesize gender = _gender;
@synthesize subgroup = _subgroup;


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
            self.dataIdentifier = [self objectOrNilForKey:kBXTSearchDataId fromDictionary:dict];
            self.roleId = [self objectOrNilForKey:kBXTSearchDataRoleId fromDictionary:dict];
            self.name = [self objectOrNilForKey:kBXTSearchDataName fromDictionary:dict];
            self.email = [self objectOrNilForKey:kBXTSearchDataEmail fromDictionary:dict];
            self.head = [self objectOrNilForKey:kBXTSearchDataHead fromDictionary:dict];
            self.mobile = [self objectOrNilForKey:kBXTSearchDataMobile fromDictionary:dict];
            self.delTime = [self objectOrNilForKey:kBXTSearchDataDelTime fromDictionary:dict];
            self.shopsId = [self objectOrNilForKey:kBXTSearchDataShopsId fromDictionary:dict];
            self.roleName = [self objectOrNilForKey:kBXTSearchDataRoleName fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kBXTSearchDataUserId fromDictionary:dict];
            self.nameShort = [self objectOrNilForKey:kBXTSearchDataNameShort fromDictionary:dict];
            self.outUserid = [self objectOrNilForKey:kBXTSearchDataOutUserid fromDictionary:dict];
            self.subgroupName = [self objectOrNilForKey:kBXTSearchDataSubgroupName fromDictionary:dict];
            self.directoryId = [self objectOrNilForKey:kBXTSearchDataDirectoryId fromDictionary:dict];
            self.delState = [self objectOrNilForKey:kBXTSearchDataDelState fromDictionary:dict];
            self.delUser = [self objectOrNilForKey:kBXTSearchDataDelUser fromDictionary:dict];
            self.gender = [self objectOrNilForKey:kBXTSearchDataGender fromDictionary:dict];
            self.subgroup = [self objectOrNilForKey:kBXTSearchDataSubgroup fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dataIdentifier forKey:kBXTSearchDataId];
    [mutableDict setValue:self.roleId forKey:kBXTSearchDataRoleId];
    [mutableDict setValue:self.name forKey:kBXTSearchDataName];
    [mutableDict setValue:self.email forKey:kBXTSearchDataEmail];
    [mutableDict setValue:self.head forKey:kBXTSearchDataHead];
    [mutableDict setValue:self.mobile forKey:kBXTSearchDataMobile];
    [mutableDict setValue:self.delTime forKey:kBXTSearchDataDelTime];
    [mutableDict setValue:self.shopsId forKey:kBXTSearchDataShopsId];
    [mutableDict setValue:self.roleName forKey:kBXTSearchDataRoleName];
    [mutableDict setValue:self.userId forKey:kBXTSearchDataUserId];
    [mutableDict setValue:self.nameShort forKey:kBXTSearchDataNameShort];
    [mutableDict setValue:self.outUserid forKey:kBXTSearchDataOutUserid];
    [mutableDict setValue:self.subgroupName forKey:kBXTSearchDataSubgroupName];
    [mutableDict setValue:self.directoryId forKey:kBXTSearchDataDirectoryId];
    [mutableDict setValue:self.delState forKey:kBXTSearchDataDelState];
    [mutableDict setValue:self.delUser forKey:kBXTSearchDataDelUser];
    [mutableDict setValue:self.gender forKey:kBXTSearchDataGender];
    [mutableDict setValue:self.subgroup forKey:kBXTSearchDataSubgroup];

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

    self.dataIdentifier = [aDecoder decodeObjectForKey:kBXTSearchDataId];
    self.roleId = [aDecoder decodeObjectForKey:kBXTSearchDataRoleId];
    self.name = [aDecoder decodeObjectForKey:kBXTSearchDataName];
    self.email = [aDecoder decodeObjectForKey:kBXTSearchDataEmail];
    self.head = [aDecoder decodeObjectForKey:kBXTSearchDataHead];
    self.mobile = [aDecoder decodeObjectForKey:kBXTSearchDataMobile];
    self.delTime = [aDecoder decodeObjectForKey:kBXTSearchDataDelTime];
    self.shopsId = [aDecoder decodeObjectForKey:kBXTSearchDataShopsId];
    self.roleName = [aDecoder decodeObjectForKey:kBXTSearchDataRoleName];
    self.userId = [aDecoder decodeObjectForKey:kBXTSearchDataUserId];
    self.nameShort = [aDecoder decodeObjectForKey:kBXTSearchDataNameShort];
    self.outUserid = [aDecoder decodeObjectForKey:kBXTSearchDataOutUserid];
    self.subgroupName = [aDecoder decodeObjectForKey:kBXTSearchDataSubgroupName];
    self.directoryId = [aDecoder decodeObjectForKey:kBXTSearchDataDirectoryId];
    self.delState = [aDecoder decodeObjectForKey:kBXTSearchDataDelState];
    self.delUser = [aDecoder decodeObjectForKey:kBXTSearchDataDelUser];
    self.gender = [aDecoder decodeObjectForKey:kBXTSearchDataGender];
    self.subgroup = [aDecoder decodeObjectForKey:kBXTSearchDataSubgroup];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dataIdentifier forKey:kBXTSearchDataId];
    [aCoder encodeObject:_roleId forKey:kBXTSearchDataRoleId];
    [aCoder encodeObject:_name forKey:kBXTSearchDataName];
    [aCoder encodeObject:_email forKey:kBXTSearchDataEmail];
    [aCoder encodeObject:_head forKey:kBXTSearchDataHead];
    [aCoder encodeObject:_mobile forKey:kBXTSearchDataMobile];
    [aCoder encodeObject:_delTime forKey:kBXTSearchDataDelTime];
    [aCoder encodeObject:_shopsId forKey:kBXTSearchDataShopsId];
    [aCoder encodeObject:_roleName forKey:kBXTSearchDataRoleName];
    [aCoder encodeObject:_userId forKey:kBXTSearchDataUserId];
    [aCoder encodeObject:_nameShort forKey:kBXTSearchDataNameShort];
    [aCoder encodeObject:_outUserid forKey:kBXTSearchDataOutUserid];
    [aCoder encodeObject:_subgroupName forKey:kBXTSearchDataSubgroupName];
    [aCoder encodeObject:_directoryId forKey:kBXTSearchDataDirectoryId];
    [aCoder encodeObject:_delState forKey:kBXTSearchDataDelState];
    [aCoder encodeObject:_delUser forKey:kBXTSearchDataDelUser];
    [aCoder encodeObject:_gender forKey:kBXTSearchDataGender];
    [aCoder encodeObject:_subgroup forKey:kBXTSearchDataSubgroup];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTSearchData *copy = [[BXTSearchData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.roleId = [self.roleId copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.head = [self.head copyWithZone:zone];
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.delTime = [self.delTime copyWithZone:zone];
        copy.shopsId = [self.shopsId copyWithZone:zone];
        copy.roleName = [self.roleName copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.nameShort = [self.nameShort copyWithZone:zone];
        copy.outUserid = [self.outUserid copyWithZone:zone];
        copy.subgroupName = [self.subgroupName copyWithZone:zone];
        copy.directoryId = [self.directoryId copyWithZone:zone];
        copy.delState = [self.delState copyWithZone:zone];
        copy.delUser = [self.delUser copyWithZone:zone];
        copy.gender = [self.gender copyWithZone:zone];
        copy.subgroup = [self.subgroup copyWithZone:zone];
    }
    
    return copy;
}


@end
