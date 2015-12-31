//
//  BXTEquipmentData.m
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTEquipmentData.h"
#import "BXTEquipmentParams.h"
#import "BXTEquipmentOperatingCondition.h"
#import "BXTEquipmentAdsName.h"
#import "BXTEquipmentFactoryInfo.h"
#import "BXTEquipmentPic.h"
#import "BXTEquipmentControlUserArr.h"


NSString *const kBXTEquipmentDataFactoryId = @"factory_id";
NSString *const kBXTEquipmentDataParams = @"params";
NSString *const kBXTEquipmentDataCodeNumber = @"code_number";
NSString *const kBXTEquipmentDataServerArea = @"server_area";
NSString *const kBXTEquipmentDataOperatingCondition = @"operating_condition";
NSString *const kBXTEquipmentDataBrand = @"brand";
NSString *const kBXTEquipmentDataStoresId = @"stores_id";
NSString *const kBXTEquipmentDataModelNumber = @"model_number";
NSString *const kBXTEquipmentDataTypeId = @"type_id";
NSString *const kBXTEquipmentDataName = @"name";
NSString *const kBXTEquipmentDataInstallTime = @"install_time";
NSString *const kBXTEquipmentDataTakeOverTime = @"take_over_time";
NSString *const kBXTEquipmentDataState = @"state";
NSString *const kBXTEquipmentDataAdsName = @"ads_name";
NSString *const kBXTEquipmentDataId = @"id";
NSString *const kBXTEquipmentDataFactoryInfo = @"factory_info";
NSString *const kBXTEquipmentDataPic = @"pic";
NSString *const kBXTEquipmentDataPlaceId = @"place_id";
NSString *const kBXTEquipmentDataTypeName = @"type_name";
NSString *const kBXTEquipmentDataStartTime = @"start_time";
NSString *const kBXTEquipmentDataNotes = @"notes";
NSString *const kBXTEquipmentDataControlUserArr = @"control_user_arr";
NSString *const kBXTEquipmentDataAreaId = @"area_id";
NSString *const kBXTEquipmentDataOperatingConditionId = @"operating_condition_id";
NSString *const kBXTEquipmentDataControlUsers = @"control_users";


@interface BXTEquipmentData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTEquipmentData

@synthesize factoryId = _factoryId;
@synthesize params = _params;
@synthesize codeNumber = _codeNumber;
@synthesize serverArea = _serverArea;
@synthesize operatingCondition = _operatingCondition;
@synthesize brand = _brand;
@synthesize storesId = _storesId;
@synthesize modelNumber = _modelNumber;
@synthesize typeId = _typeId;
@synthesize name = _name;
@synthesize installTime = _installTime;
@synthesize takeOverTime = _takeOverTime;
@synthesize state = _state;
@synthesize adsName = _adsName;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize factoryInfo = _factoryInfo;
@synthesize pic = _pic;
@synthesize placeId = _placeId;
@synthesize typeName = _typeName;
@synthesize startTime = _startTime;
@synthesize notes = _notes;
@synthesize controlUserArr = _controlUserArr;
@synthesize areaId = _areaId;
@synthesize operatingConditionId = _operatingConditionId;
@synthesize controlUsers = _controlUsers;


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
            self.factoryId = [self objectOrNilForKey:kBXTEquipmentDataFactoryId fromDictionary:dict];
    NSObject *receivedBXTEquipmentParams = [dict objectForKey:kBXTEquipmentDataParams];
    NSMutableArray *parsedBXTEquipmentParams = [NSMutableArray array];
    if ([receivedBXTEquipmentParams isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBXTEquipmentParams) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBXTEquipmentParams addObject:[BXTEquipmentParams modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBXTEquipmentParams isKindOfClass:[NSDictionary class]]) {
       [parsedBXTEquipmentParams addObject:[BXTEquipmentParams modelObjectWithDictionary:(NSDictionary *)receivedBXTEquipmentParams]];
    }

    self.params = [NSArray arrayWithArray:parsedBXTEquipmentParams];
            self.codeNumber = [self objectOrNilForKey:kBXTEquipmentDataCodeNumber fromDictionary:dict];
            self.serverArea = [self objectOrNilForKey:kBXTEquipmentDataServerArea fromDictionary:dict];
    NSObject *receivedBXTEquipmentOperatingCondition = [dict objectForKey:kBXTEquipmentDataOperatingCondition];
    NSMutableArray *parsedBXTEquipmentOperatingCondition = [NSMutableArray array];
    if ([receivedBXTEquipmentOperatingCondition isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBXTEquipmentOperatingCondition) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBXTEquipmentOperatingCondition addObject:[BXTEquipmentOperatingCondition modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBXTEquipmentOperatingCondition isKindOfClass:[NSDictionary class]]) {
       [parsedBXTEquipmentOperatingCondition addObject:[BXTEquipmentOperatingCondition modelObjectWithDictionary:(NSDictionary *)receivedBXTEquipmentOperatingCondition]];
    }

    self.operatingCondition = [NSArray arrayWithArray:parsedBXTEquipmentOperatingCondition];
            self.brand = [self objectOrNilForKey:kBXTEquipmentDataBrand fromDictionary:dict];
            self.storesId = [self objectOrNilForKey:kBXTEquipmentDataStoresId fromDictionary:dict];
            self.modelNumber = [self objectOrNilForKey:kBXTEquipmentDataModelNumber fromDictionary:dict];
            self.typeId = [self objectOrNilForKey:kBXTEquipmentDataTypeId fromDictionary:dict];
            self.name = [self objectOrNilForKey:kBXTEquipmentDataName fromDictionary:dict];
            self.installTime = [self objectOrNilForKey:kBXTEquipmentDataInstallTime fromDictionary:dict];
            self.takeOverTime = [self objectOrNilForKey:kBXTEquipmentDataTakeOverTime fromDictionary:dict];
            self.state = [self objectOrNilForKey:kBXTEquipmentDataState fromDictionary:dict];
    NSObject *receivedBXTEquipmentAdsName = [dict objectForKey:kBXTEquipmentDataAdsName];
    NSMutableArray *parsedBXTEquipmentAdsName = [NSMutableArray array];
    if ([receivedBXTEquipmentAdsName isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBXTEquipmentAdsName) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBXTEquipmentAdsName addObject:[BXTEquipmentAdsName modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBXTEquipmentAdsName isKindOfClass:[NSDictionary class]]) {
       [parsedBXTEquipmentAdsName addObject:[BXTEquipmentAdsName modelObjectWithDictionary:(NSDictionary *)receivedBXTEquipmentAdsName]];
    }

    self.adsName = [NSArray arrayWithArray:parsedBXTEquipmentAdsName];
            self.dataIdentifier = [self objectOrNilForKey:kBXTEquipmentDataId fromDictionary:dict];
    NSObject *receivedBXTEquipmentFactoryInfo = [dict objectForKey:kBXTEquipmentDataFactoryInfo];
    NSMutableArray *parsedBXTEquipmentFactoryInfo = [NSMutableArray array];
    if ([receivedBXTEquipmentFactoryInfo isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBXTEquipmentFactoryInfo) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBXTEquipmentFactoryInfo addObject:[BXTEquipmentFactoryInfo modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBXTEquipmentFactoryInfo isKindOfClass:[NSDictionary class]]) {
       [parsedBXTEquipmentFactoryInfo addObject:[BXTEquipmentFactoryInfo modelObjectWithDictionary:(NSDictionary *)receivedBXTEquipmentFactoryInfo]];
    }

    self.factoryInfo = [NSArray arrayWithArray:parsedBXTEquipmentFactoryInfo];
    NSObject *receivedBXTEquipmentPic = [dict objectForKey:kBXTEquipmentDataPic];
    NSMutableArray *parsedBXTEquipmentPic = [NSMutableArray array];
    if ([receivedBXTEquipmentPic isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBXTEquipmentPic) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBXTEquipmentPic addObject:[BXTEquipmentPic modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBXTEquipmentPic isKindOfClass:[NSDictionary class]]) {
       [parsedBXTEquipmentPic addObject:[BXTEquipmentPic modelObjectWithDictionary:(NSDictionary *)receivedBXTEquipmentPic]];
    }

    self.pic = [NSArray arrayWithArray:parsedBXTEquipmentPic];
            self.placeId = [self objectOrNilForKey:kBXTEquipmentDataPlaceId fromDictionary:dict];
            self.typeName = [self objectOrNilForKey:kBXTEquipmentDataTypeName fromDictionary:dict];
            self.startTime = [self objectOrNilForKey:kBXTEquipmentDataStartTime fromDictionary:dict];
            self.notes = [self objectOrNilForKey:kBXTEquipmentDataNotes fromDictionary:dict];
    NSObject *receivedBXTEquipmentControlUserArr = [dict objectForKey:kBXTEquipmentDataControlUserArr];
    NSMutableArray *parsedBXTEquipmentControlUserArr = [NSMutableArray array];
    if ([receivedBXTEquipmentControlUserArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBXTEquipmentControlUserArr) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBXTEquipmentControlUserArr addObject:[BXTEquipmentControlUserArr modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBXTEquipmentControlUserArr isKindOfClass:[NSDictionary class]]) {
       [parsedBXTEquipmentControlUserArr addObject:[BXTEquipmentControlUserArr modelObjectWithDictionary:(NSDictionary *)receivedBXTEquipmentControlUserArr]];
    }

    self.controlUserArr = [NSArray arrayWithArray:parsedBXTEquipmentControlUserArr];
            self.areaId = [self objectOrNilForKey:kBXTEquipmentDataAreaId fromDictionary:dict];
            self.operatingConditionId = [self objectOrNilForKey:kBXTEquipmentDataOperatingConditionId fromDictionary:dict];
            self.controlUsers = [self objectOrNilForKey:kBXTEquipmentDataControlUsers fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.factoryId forKey:kBXTEquipmentDataFactoryId];
    NSMutableArray *tempArrayForParams = [NSMutableArray array];
    for (NSObject *subArrayObject in self.params) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForParams addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForParams addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForParams] forKey:kBXTEquipmentDataParams];
    [mutableDict setValue:self.codeNumber forKey:kBXTEquipmentDataCodeNumber];
    [mutableDict setValue:self.serverArea forKey:kBXTEquipmentDataServerArea];
    NSMutableArray *tempArrayForOperatingCondition = [NSMutableArray array];
    for (NSObject *subArrayObject in self.operatingCondition) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForOperatingCondition addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForOperatingCondition addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForOperatingCondition] forKey:kBXTEquipmentDataOperatingCondition];
    [mutableDict setValue:self.brand forKey:kBXTEquipmentDataBrand];
    [mutableDict setValue:self.storesId forKey:kBXTEquipmentDataStoresId];
    [mutableDict setValue:self.modelNumber forKey:kBXTEquipmentDataModelNumber];
    [mutableDict setValue:self.typeId forKey:kBXTEquipmentDataTypeId];
    [mutableDict setValue:self.name forKey:kBXTEquipmentDataName];
    [mutableDict setValue:self.installTime forKey:kBXTEquipmentDataInstallTime];
    [mutableDict setValue:self.takeOverTime forKey:kBXTEquipmentDataTakeOverTime];
    [mutableDict setValue:self.state forKey:kBXTEquipmentDataState];
    NSMutableArray *tempArrayForAdsName = [NSMutableArray array];
    for (NSObject *subArrayObject in self.adsName) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAdsName addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAdsName addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAdsName] forKey:kBXTEquipmentDataAdsName];
    [mutableDict setValue:self.dataIdentifier forKey:kBXTEquipmentDataId];
    NSMutableArray *tempArrayForFactoryInfo = [NSMutableArray array];
    for (NSObject *subArrayObject in self.factoryInfo) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForFactoryInfo addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForFactoryInfo addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForFactoryInfo] forKey:kBXTEquipmentDataFactoryInfo];
    NSMutableArray *tempArrayForPic = [NSMutableArray array];
    for (NSObject *subArrayObject in self.pic) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPic addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPic addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPic] forKey:kBXTEquipmentDataPic];
    [mutableDict setValue:self.placeId forKey:kBXTEquipmentDataPlaceId];
    [mutableDict setValue:self.typeName forKey:kBXTEquipmentDataTypeName];
    [mutableDict setValue:self.startTime forKey:kBXTEquipmentDataStartTime];
    [mutableDict setValue:self.notes forKey:kBXTEquipmentDataNotes];
    NSMutableArray *tempArrayForControlUserArr = [NSMutableArray array];
    for (NSObject *subArrayObject in self.controlUserArr) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForControlUserArr addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForControlUserArr addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForControlUserArr] forKey:kBXTEquipmentDataControlUserArr];
    [mutableDict setValue:self.areaId forKey:kBXTEquipmentDataAreaId];
    [mutableDict setValue:self.operatingConditionId forKey:kBXTEquipmentDataOperatingConditionId];
    [mutableDict setValue:self.controlUsers forKey:kBXTEquipmentDataControlUsers];

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

    self.factoryId = [aDecoder decodeObjectForKey:kBXTEquipmentDataFactoryId];
    self.params = [aDecoder decodeObjectForKey:kBXTEquipmentDataParams];
    self.codeNumber = [aDecoder decodeObjectForKey:kBXTEquipmentDataCodeNumber];
    self.serverArea = [aDecoder decodeObjectForKey:kBXTEquipmentDataServerArea];
    self.operatingCondition = [aDecoder decodeObjectForKey:kBXTEquipmentDataOperatingCondition];
    self.brand = [aDecoder decodeObjectForKey:kBXTEquipmentDataBrand];
    self.storesId = [aDecoder decodeObjectForKey:kBXTEquipmentDataStoresId];
    self.modelNumber = [aDecoder decodeObjectForKey:kBXTEquipmentDataModelNumber];
    self.typeId = [aDecoder decodeObjectForKey:kBXTEquipmentDataTypeId];
    self.name = [aDecoder decodeObjectForKey:kBXTEquipmentDataName];
    self.installTime = [aDecoder decodeObjectForKey:kBXTEquipmentDataInstallTime];
    self.takeOverTime = [aDecoder decodeObjectForKey:kBXTEquipmentDataTakeOverTime];
    self.state = [aDecoder decodeObjectForKey:kBXTEquipmentDataState];
    self.adsName = [aDecoder decodeObjectForKey:kBXTEquipmentDataAdsName];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kBXTEquipmentDataId];
    self.factoryInfo = [aDecoder decodeObjectForKey:kBXTEquipmentDataFactoryInfo];
    self.pic = [aDecoder decodeObjectForKey:kBXTEquipmentDataPic];
    self.placeId = [aDecoder decodeObjectForKey:kBXTEquipmentDataPlaceId];
    self.typeName = [aDecoder decodeObjectForKey:kBXTEquipmentDataTypeName];
    self.startTime = [aDecoder decodeObjectForKey:kBXTEquipmentDataStartTime];
    self.notes = [aDecoder decodeObjectForKey:kBXTEquipmentDataNotes];
    self.controlUserArr = [aDecoder decodeObjectForKey:kBXTEquipmentDataControlUserArr];
    self.areaId = [aDecoder decodeObjectForKey:kBXTEquipmentDataAreaId];
    self.operatingConditionId = [aDecoder decodeObjectForKey:kBXTEquipmentDataOperatingConditionId];
    self.controlUsers = [aDecoder decodeObjectForKey:kBXTEquipmentDataControlUsers];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_factoryId forKey:kBXTEquipmentDataFactoryId];
    [aCoder encodeObject:_params forKey:kBXTEquipmentDataParams];
    [aCoder encodeObject:_codeNumber forKey:kBXTEquipmentDataCodeNumber];
    [aCoder encodeObject:_serverArea forKey:kBXTEquipmentDataServerArea];
    [aCoder encodeObject:_operatingCondition forKey:kBXTEquipmentDataOperatingCondition];
    [aCoder encodeObject:_brand forKey:kBXTEquipmentDataBrand];
    [aCoder encodeObject:_storesId forKey:kBXTEquipmentDataStoresId];
    [aCoder encodeObject:_modelNumber forKey:kBXTEquipmentDataModelNumber];
    [aCoder encodeObject:_typeId forKey:kBXTEquipmentDataTypeId];
    [aCoder encodeObject:_name forKey:kBXTEquipmentDataName];
    [aCoder encodeObject:_installTime forKey:kBXTEquipmentDataInstallTime];
    [aCoder encodeObject:_takeOverTime forKey:kBXTEquipmentDataTakeOverTime];
    [aCoder encodeObject:_state forKey:kBXTEquipmentDataState];
    [aCoder encodeObject:_adsName forKey:kBXTEquipmentDataAdsName];
    [aCoder encodeObject:_dataIdentifier forKey:kBXTEquipmentDataId];
    [aCoder encodeObject:_factoryInfo forKey:kBXTEquipmentDataFactoryInfo];
    [aCoder encodeObject:_pic forKey:kBXTEquipmentDataPic];
    [aCoder encodeObject:_placeId forKey:kBXTEquipmentDataPlaceId];
    [aCoder encodeObject:_typeName forKey:kBXTEquipmentDataTypeName];
    [aCoder encodeObject:_startTime forKey:kBXTEquipmentDataStartTime];
    [aCoder encodeObject:_notes forKey:kBXTEquipmentDataNotes];
    [aCoder encodeObject:_controlUserArr forKey:kBXTEquipmentDataControlUserArr];
    [aCoder encodeObject:_areaId forKey:kBXTEquipmentDataAreaId];
    [aCoder encodeObject:_operatingConditionId forKey:kBXTEquipmentDataOperatingConditionId];
    [aCoder encodeObject:_controlUsers forKey:kBXTEquipmentDataControlUsers];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTEquipmentData *copy = [[BXTEquipmentData alloc] init];
    
    if (copy) {

        copy.factoryId = [self.factoryId copyWithZone:zone];
        copy.params = [self.params copyWithZone:zone];
        copy.codeNumber = [self.codeNumber copyWithZone:zone];
        copy.serverArea = [self.serverArea copyWithZone:zone];
        copy.operatingCondition = [self.operatingCondition copyWithZone:zone];
        copy.brand = [self.brand copyWithZone:zone];
        copy.storesId = [self.storesId copyWithZone:zone];
        copy.modelNumber = [self.modelNumber copyWithZone:zone];
        copy.typeId = [self.typeId copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.installTime = [self.installTime copyWithZone:zone];
        copy.takeOverTime = [self.takeOverTime copyWithZone:zone];
        copy.state = [self.state copyWithZone:zone];
        copy.adsName = [self.adsName copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.factoryInfo = [self.factoryInfo copyWithZone:zone];
        copy.pic = [self.pic copyWithZone:zone];
        copy.placeId = [self.placeId copyWithZone:zone];
        copy.typeName = [self.typeName copyWithZone:zone];
        copy.startTime = [self.startTime copyWithZone:zone];
        copy.notes = [self.notes copyWithZone:zone];
        copy.controlUserArr = [self.controlUserArr copyWithZone:zone];
        copy.areaId = [self.areaId copyWithZone:zone];
        copy.operatingConditionId = [self.operatingConditionId copyWithZone:zone];
        copy.controlUsers = [self.controlUsers copyWithZone:zone];
    }
    
    return copy;
}


@end
