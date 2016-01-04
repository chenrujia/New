//
//  BXTCurrentOrderData.m
//
//  Created by 孝意 满 on 15/12/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTCurrentOrderData.h"


NSString *const kBXTCurrentOrderDataDepartment = @"department";
NSString *const kBXTCurrentOrderDataCause = @"cause";
NSString *const kBXTCurrentOrderDataId = @"id";
NSString *const kBXTCurrentOrderDataIntegral = @"integral";
NSString *const kBXTCurrentOrderDataRepairUserName = @"repair_user_name";
NSString *const kBXTCurrentOrderDataStoresName = @"stores_name";
NSString *const kBXTCurrentOrderDataState = @"state";
NSString *const kBXTCurrentOrderDataUrgent = @"urgent";
NSString *const kBXTCurrentOrderDataFault = @"fault";
NSString *const kBXTCurrentOrderDataRepairTime = @"repair_time";
NSString *const kBXTCurrentOrderDataEvaluationNotes = @"evaluation_notes";
NSString *const kBXTCurrentOrderDataContactName = @"contact_name";
NSString *const kBXTCurrentOrderDataIsReceive = @"is_receive";
NSString *const kBXTCurrentOrderDataOrderid = @"orderid";
NSString *const kBXTCurrentOrderDataRepairstate = @"repairstate";
NSString *const kBXTCurrentOrderDataIsRepairing = @"is_repairing";
NSString *const kBXTCurrentOrderDataOperating = @"Operating";
NSString *const kBXTCurrentOrderDataWorkprocess = @"workprocess";
NSString *const kBXTCurrentOrderDataIsRead = @"is_read";
NSString *const kBXTCurrentOrderDataIsGadget = @"is_gadget";
NSString *const kBXTCurrentOrderDataRepairUser = @"repair_user";
NSString *const kBXTCurrentOrderDataArea = @"area";
NSString *const kBXTCurrentOrderDataSubgroupName = @"subgroup_name";
NSString *const kBXTCurrentOrderDataSubgroup = @"subgroup";
NSString *const kBXTCurrentOrderDataStoresId = @"stores_id";
NSString *const kBXTCurrentOrderDataPlace = @"place";
NSString *const kBXTCurrentOrderDataIntegralEdit = @"integral_edit";
NSString *const kBXTCurrentOrderDataIsDispatch = @"is_dispatch";
NSString *const kBXTCurrentOrderDataManHours = @"man_hours";
NSString *const kBXTCurrentOrderDataOrderType = @"order_type";
NSString *const kBXTCurrentOrderDataCollection = @"collection";
NSString *const kBXTCurrentOrderDataFixedPic = @"fixed_pic";
NSString *const kBXTCurrentOrderDataStartTime = @"start_time";
NSString *const kBXTCurrentOrderDataFaulttypeName = @"faulttype_name";
NSString *const kBXTCurrentOrderDataFaultId = @"fault_id";
NSString *const kBXTCurrentOrderDataReceiveState = @"receive_state";
NSString *const kBXTCurrentOrderDataFaulttype = @"faulttype";
NSString *const kBXTCurrentOrderDataFaulttypeType = @"faulttype_type";
NSString *const kBXTCurrentOrderDataTaskType = @"task_type";
NSString *const kBXTCurrentOrderDataLongTime = @"long_time";
NSString *const kBXTCurrentOrderDataContactTel = @"contact_tel";
NSString *const kBXTCurrentOrderDataReceiveTime = @"receive_time";
NSString *const kBXTCurrentOrderDataIntegralGrab = @"integral_grab";


@interface BXTCurrentOrderData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTCurrentOrderData

@synthesize department = _department;
@synthesize cause = _cause;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize integral = _integral;
@synthesize repairUserName = _repairUserName;
@synthesize storesName = _storesName;
@synthesize state = _state;
@synthesize urgent = _urgent;
@synthesize fault = _fault;
@synthesize repairTime = _repairTime;
@synthesize evaluationNotes = _evaluationNotes;
@synthesize contactName = _contactName;
@synthesize isReceive = _isReceive;
@synthesize orderid = _orderid;
@synthesize repairstate = _repairstate;
@synthesize isRepairing = _isRepairing;
@synthesize operating = _operating;
@synthesize workprocess = _workprocess;
@synthesize isRead = _isRead;
@synthesize isGadget = _isGadget;
@synthesize repairUser = _repairUser;
@synthesize area = _area;
@synthesize subgroupName = _subgroupName;
@synthesize subgroup = _subgroup;
@synthesize storesId = _storesId;
@synthesize place = _place;
@synthesize integralEdit = _integralEdit;
@synthesize isDispatch = _isDispatch;
@synthesize manHours = _manHours;
@synthesize orderType = _orderType;
@synthesize collection = _collection;
@synthesize fixedPic = _fixedPic;
@synthesize startTime = _startTime;
@synthesize faulttypeName = _faulttypeName;
@synthesize faultId = _faultId;
@synthesize receiveState = _receiveState;
@synthesize faulttype = _faulttype;
@synthesize faulttypeType = _faulttypeType;
@synthesize taskType = _taskType;
@synthesize longTime = _longTime;
@synthesize contactTel = _contactTel;
@synthesize receiveTime = _receiveTime;
@synthesize integralGrab = _integralGrab;


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
            self.department = [self objectOrNilForKey:kBXTCurrentOrderDataDepartment fromDictionary:dict];
            self.cause = [self objectOrNilForKey:kBXTCurrentOrderDataCause fromDictionary:dict];
            self.dataIdentifier = [self objectOrNilForKey:kBXTCurrentOrderDataId fromDictionary:dict];
            self.integral = [self objectOrNilForKey:kBXTCurrentOrderDataIntegral fromDictionary:dict];
            self.repairUserName = [self objectOrNilForKey:kBXTCurrentOrderDataRepairUserName fromDictionary:dict];
            self.storesName = [self objectOrNilForKey:kBXTCurrentOrderDataStoresName fromDictionary:dict];
            self.state = [self objectOrNilForKey:kBXTCurrentOrderDataState fromDictionary:dict];
            self.urgent = [self objectOrNilForKey:kBXTCurrentOrderDataUrgent fromDictionary:dict];
            self.fault = [self objectOrNilForKey:kBXTCurrentOrderDataFault fromDictionary:dict];
            self.repairTime = [self objectOrNilForKey:kBXTCurrentOrderDataRepairTime fromDictionary:dict];
            self.evaluationNotes = [self objectOrNilForKey:kBXTCurrentOrderDataEvaluationNotes fromDictionary:dict];
            self.contactName = [self objectOrNilForKey:kBXTCurrentOrderDataContactName fromDictionary:dict];
            self.isReceive = [self objectOrNilForKey:kBXTCurrentOrderDataIsReceive fromDictionary:dict];
            self.orderid = [self objectOrNilForKey:kBXTCurrentOrderDataOrderid fromDictionary:dict];
            self.repairstate = [self objectOrNilForKey:kBXTCurrentOrderDataRepairstate fromDictionary:dict];
            self.isRepairing = [self objectOrNilForKey:kBXTCurrentOrderDataIsRepairing fromDictionary:dict];
            self.operating = [self objectOrNilForKey:kBXTCurrentOrderDataOperating fromDictionary:dict];
            self.workprocess = [self objectOrNilForKey:kBXTCurrentOrderDataWorkprocess fromDictionary:dict];
            self.isRead = [self objectOrNilForKey:kBXTCurrentOrderDataIsRead fromDictionary:dict];
            self.isGadget = [self objectOrNilForKey:kBXTCurrentOrderDataIsGadget fromDictionary:dict];
            self.repairUser = [self objectOrNilForKey:kBXTCurrentOrderDataRepairUser fromDictionary:dict];
            self.area = [self objectOrNilForKey:kBXTCurrentOrderDataArea fromDictionary:dict];
            self.subgroupName = [self objectOrNilForKey:kBXTCurrentOrderDataSubgroupName fromDictionary:dict];
            self.subgroup = [self objectOrNilForKey:kBXTCurrentOrderDataSubgroup fromDictionary:dict];
            self.storesId = [self objectOrNilForKey:kBXTCurrentOrderDataStoresId fromDictionary:dict];
            self.place = [self objectOrNilForKey:kBXTCurrentOrderDataPlace fromDictionary:dict];
            self.integralEdit = [self objectOrNilForKey:kBXTCurrentOrderDataIntegralEdit fromDictionary:dict];
            self.isDispatch = [self objectOrNilForKey:kBXTCurrentOrderDataIsDispatch fromDictionary:dict];
            self.manHours = [self objectOrNilForKey:kBXTCurrentOrderDataManHours fromDictionary:dict];
            self.orderType = [[self objectOrNilForKey:kBXTCurrentOrderDataOrderType fromDictionary:dict] doubleValue];
            self.collection = [self objectOrNilForKey:kBXTCurrentOrderDataCollection fromDictionary:dict];
            self.fixedPic = [self objectOrNilForKey:kBXTCurrentOrderDataFixedPic fromDictionary:dict];
            self.startTime = [self objectOrNilForKey:kBXTCurrentOrderDataStartTime fromDictionary:dict];
            self.faulttypeName = [self objectOrNilForKey:kBXTCurrentOrderDataFaulttypeName fromDictionary:dict];
            self.faultId = [self objectOrNilForKey:kBXTCurrentOrderDataFaultId fromDictionary:dict];
            self.receiveState = [self objectOrNilForKey:kBXTCurrentOrderDataReceiveState fromDictionary:dict];
            self.faulttype = [self objectOrNilForKey:kBXTCurrentOrderDataFaulttype fromDictionary:dict];
            self.faulttypeType = [self objectOrNilForKey:kBXTCurrentOrderDataFaulttypeType fromDictionary:dict];
            self.taskType = [self objectOrNilForKey:kBXTCurrentOrderDataTaskType fromDictionary:dict];
            self.longTime = [[self objectOrNilForKey:kBXTCurrentOrderDataLongTime fromDictionary:dict] doubleValue];
            self.contactTel = [self objectOrNilForKey:kBXTCurrentOrderDataContactTel fromDictionary:dict];
            self.receiveTime = [self objectOrNilForKey:kBXTCurrentOrderDataReceiveTime fromDictionary:dict];
            self.integralGrab = [self objectOrNilForKey:kBXTCurrentOrderDataIntegralGrab fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.department forKey:kBXTCurrentOrderDataDepartment];
    [mutableDict setValue:self.cause forKey:kBXTCurrentOrderDataCause];
    [mutableDict setValue:self.dataIdentifier forKey:kBXTCurrentOrderDataId];
    [mutableDict setValue:self.integral forKey:kBXTCurrentOrderDataIntegral];
    [mutableDict setValue:self.repairUserName forKey:kBXTCurrentOrderDataRepairUserName];
    [mutableDict setValue:self.storesName forKey:kBXTCurrentOrderDataStoresName];
    [mutableDict setValue:self.state forKey:kBXTCurrentOrderDataState];
    [mutableDict setValue:self.urgent forKey:kBXTCurrentOrderDataUrgent];
    [mutableDict setValue:self.fault forKey:kBXTCurrentOrderDataFault];
    [mutableDict setValue:self.repairTime forKey:kBXTCurrentOrderDataRepairTime];
    [mutableDict setValue:self.evaluationNotes forKey:kBXTCurrentOrderDataEvaluationNotes];
    [mutableDict setValue:self.contactName forKey:kBXTCurrentOrderDataContactName];
    [mutableDict setValue:self.isReceive forKey:kBXTCurrentOrderDataIsReceive];
    [mutableDict setValue:self.orderid forKey:kBXTCurrentOrderDataOrderid];
    [mutableDict setValue:self.repairstate forKey:kBXTCurrentOrderDataRepairstate];
    [mutableDict setValue:self.isRepairing forKey:kBXTCurrentOrderDataIsRepairing];
    [mutableDict setValue:self.operating forKey:kBXTCurrentOrderDataOperating];
    [mutableDict setValue:self.workprocess forKey:kBXTCurrentOrderDataWorkprocess];
    [mutableDict setValue:self.isRead forKey:kBXTCurrentOrderDataIsRead];
    [mutableDict setValue:self.isGadget forKey:kBXTCurrentOrderDataIsGadget];
    [mutableDict setValue:self.repairUser forKey:kBXTCurrentOrderDataRepairUser];
    [mutableDict setValue:self.area forKey:kBXTCurrentOrderDataArea];
    [mutableDict setValue:self.subgroupName forKey:kBXTCurrentOrderDataSubgroupName];
    [mutableDict setValue:self.subgroup forKey:kBXTCurrentOrderDataSubgroup];
    [mutableDict setValue:self.storesId forKey:kBXTCurrentOrderDataStoresId];
    [mutableDict setValue:self.place forKey:kBXTCurrentOrderDataPlace];
    [mutableDict setValue:self.integralEdit forKey:kBXTCurrentOrderDataIntegralEdit];
    [mutableDict setValue:self.isDispatch forKey:kBXTCurrentOrderDataIsDispatch];
    [mutableDict setValue:self.manHours forKey:kBXTCurrentOrderDataManHours];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderType] forKey:kBXTCurrentOrderDataOrderType];
    [mutableDict setValue:self.collection forKey:kBXTCurrentOrderDataCollection];
    [mutableDict setValue:self.fixedPic forKey:kBXTCurrentOrderDataFixedPic];
    [mutableDict setValue:self.startTime forKey:kBXTCurrentOrderDataStartTime];
    [mutableDict setValue:self.faulttypeName forKey:kBXTCurrentOrderDataFaulttypeName];
    [mutableDict setValue:self.faultId forKey:kBXTCurrentOrderDataFaultId];
    [mutableDict setValue:self.receiveState forKey:kBXTCurrentOrderDataReceiveState];
    [mutableDict setValue:self.faulttype forKey:kBXTCurrentOrderDataFaulttype];
    [mutableDict setValue:self.faulttypeType forKey:kBXTCurrentOrderDataFaulttypeType];
    [mutableDict setValue:self.taskType forKey:kBXTCurrentOrderDataTaskType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.longTime] forKey:kBXTCurrentOrderDataLongTime];
    [mutableDict setValue:self.contactTel forKey:kBXTCurrentOrderDataContactTel];
    [mutableDict setValue:self.receiveTime forKey:kBXTCurrentOrderDataReceiveTime];
    [mutableDict setValue:self.integralGrab forKey:kBXTCurrentOrderDataIntegralGrab];

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

    self.department = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataDepartment];
    self.cause = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataCause];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataId];
    self.integral = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataIntegral];
    self.repairUserName = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataRepairUserName];
    self.storesName = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataStoresName];
    self.state = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataState];
    self.urgent = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataUrgent];
    self.fault = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataFault];
    self.repairTime = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataRepairTime];
    self.evaluationNotes = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataEvaluationNotes];
    self.contactName = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataContactName];
    self.isReceive = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataIsReceive];
    self.orderid = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataOrderid];
    self.repairstate = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataRepairstate];
    self.isRepairing = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataIsRepairing];
    self.operating = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataOperating];
    self.workprocess = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataWorkprocess];
    self.isRead = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataIsRead];
    self.isGadget = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataIsGadget];
    self.repairUser = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataRepairUser];
    self.area = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataArea];
    self.subgroupName = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataSubgroupName];
    self.subgroup = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataSubgroup];
    self.storesId = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataStoresId];
    self.place = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataPlace];
    self.integralEdit = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataIntegralEdit];
    self.isDispatch = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataIsDispatch];
    self.manHours = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataManHours];
    self.orderType = [aDecoder decodeDoubleForKey:kBXTCurrentOrderDataOrderType];
    self.collection = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataCollection];
    self.fixedPic = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataFixedPic];
    self.startTime = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataStartTime];
    self.faulttypeName = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataFaulttypeName];
    self.faultId = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataFaultId];
    self.receiveState = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataReceiveState];
    self.faulttype = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataFaulttype];
    self.faulttypeType = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataFaulttypeType];
    self.taskType = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataTaskType];
    self.longTime = [aDecoder decodeDoubleForKey:kBXTCurrentOrderDataLongTime];
    self.contactTel = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataContactTel];
    self.receiveTime = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataReceiveTime];
    self.integralGrab = [aDecoder decodeObjectForKey:kBXTCurrentOrderDataIntegralGrab];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_department forKey:kBXTCurrentOrderDataDepartment];
    [aCoder encodeObject:_cause forKey:kBXTCurrentOrderDataCause];
    [aCoder encodeObject:_dataIdentifier forKey:kBXTCurrentOrderDataId];
    [aCoder encodeObject:_integral forKey:kBXTCurrentOrderDataIntegral];
    [aCoder encodeObject:_repairUserName forKey:kBXTCurrentOrderDataRepairUserName];
    [aCoder encodeObject:_storesName forKey:kBXTCurrentOrderDataStoresName];
    [aCoder encodeObject:_state forKey:kBXTCurrentOrderDataState];
    [aCoder encodeObject:_urgent forKey:kBXTCurrentOrderDataUrgent];
    [aCoder encodeObject:_fault forKey:kBXTCurrentOrderDataFault];
    [aCoder encodeObject:_repairTime forKey:kBXTCurrentOrderDataRepairTime];
    [aCoder encodeObject:_evaluationNotes forKey:kBXTCurrentOrderDataEvaluationNotes];
    [aCoder encodeObject:_contactName forKey:kBXTCurrentOrderDataContactName];
    [aCoder encodeObject:_isReceive forKey:kBXTCurrentOrderDataIsReceive];
    [aCoder encodeObject:_orderid forKey:kBXTCurrentOrderDataOrderid];
    [aCoder encodeObject:_repairstate forKey:kBXTCurrentOrderDataRepairstate];
    [aCoder encodeObject:_isRepairing forKey:kBXTCurrentOrderDataIsRepairing];
    [aCoder encodeObject:_operating forKey:kBXTCurrentOrderDataOperating];
    [aCoder encodeObject:_workprocess forKey:kBXTCurrentOrderDataWorkprocess];
    [aCoder encodeObject:_isRead forKey:kBXTCurrentOrderDataIsRead];
    [aCoder encodeObject:_isGadget forKey:kBXTCurrentOrderDataIsGadget];
    [aCoder encodeObject:_repairUser forKey:kBXTCurrentOrderDataRepairUser];
    [aCoder encodeObject:_area forKey:kBXTCurrentOrderDataArea];
    [aCoder encodeObject:_subgroupName forKey:kBXTCurrentOrderDataSubgroupName];
    [aCoder encodeObject:_subgroup forKey:kBXTCurrentOrderDataSubgroup];
    [aCoder encodeObject:_storesId forKey:kBXTCurrentOrderDataStoresId];
    [aCoder encodeObject:_place forKey:kBXTCurrentOrderDataPlace];
    [aCoder encodeObject:_integralEdit forKey:kBXTCurrentOrderDataIntegralEdit];
    [aCoder encodeObject:_isDispatch forKey:kBXTCurrentOrderDataIsDispatch];
    [aCoder encodeObject:_manHours forKey:kBXTCurrentOrderDataManHours];
    [aCoder encodeDouble:_orderType forKey:kBXTCurrentOrderDataOrderType];
    [aCoder encodeObject:_collection forKey:kBXTCurrentOrderDataCollection];
    [aCoder encodeObject:_fixedPic forKey:kBXTCurrentOrderDataFixedPic];
    [aCoder encodeObject:_startTime forKey:kBXTCurrentOrderDataStartTime];
    [aCoder encodeObject:_faulttypeName forKey:kBXTCurrentOrderDataFaulttypeName];
    [aCoder encodeObject:_faultId forKey:kBXTCurrentOrderDataFaultId];
    [aCoder encodeObject:_receiveState forKey:kBXTCurrentOrderDataReceiveState];
    [aCoder encodeObject:_faulttype forKey:kBXTCurrentOrderDataFaulttype];
    [aCoder encodeObject:_faulttypeType forKey:kBXTCurrentOrderDataFaulttypeType];
    [aCoder encodeObject:_taskType forKey:kBXTCurrentOrderDataTaskType];
    [aCoder encodeDouble:_longTime forKey:kBXTCurrentOrderDataLongTime];
    [aCoder encodeObject:_contactTel forKey:kBXTCurrentOrderDataContactTel];
    [aCoder encodeObject:_receiveTime forKey:kBXTCurrentOrderDataReceiveTime];
    [aCoder encodeObject:_integralGrab forKey:kBXTCurrentOrderDataIntegralGrab];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTCurrentOrderData *copy = [[BXTCurrentOrderData alloc] init];
    
    if (copy) {

        copy.department = [self.department copyWithZone:zone];
        copy.cause = [self.cause copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.integral = [self.integral copyWithZone:zone];
        copy.repairUserName = [self.repairUserName copyWithZone:zone];
        copy.storesName = [self.storesName copyWithZone:zone];
        copy.state = [self.state copyWithZone:zone];
        copy.urgent = [self.urgent copyWithZone:zone];
        copy.fault = [self.fault copyWithZone:zone];
        copy.repairTime = [self.repairTime copyWithZone:zone];
        copy.evaluationNotes = [self.evaluationNotes copyWithZone:zone];
        copy.contactName = [self.contactName copyWithZone:zone];
        copy.isReceive = [self.isReceive copyWithZone:zone];
        copy.orderid = [self.orderid copyWithZone:zone];
        copy.repairstate = [self.repairstate copyWithZone:zone];
        copy.isRepairing = [self.isRepairing copyWithZone:zone];
        copy.operating = [self.operating copyWithZone:zone];
        copy.workprocess = [self.workprocess copyWithZone:zone];
        copy.isRead = [self.isRead copyWithZone:zone];
        copy.isGadget = [self.isGadget copyWithZone:zone];
        copy.repairUser = [self.repairUser copyWithZone:zone];
        copy.area = [self.area copyWithZone:zone];
        copy.subgroupName = [self.subgroupName copyWithZone:zone];
        copy.subgroup = [self.subgroup copyWithZone:zone];
        copy.storesId = [self.storesId copyWithZone:zone];
        copy.place = [self.place copyWithZone:zone];
        copy.integralEdit = [self.integralEdit copyWithZone:zone];
        copy.isDispatch = [self.isDispatch copyWithZone:zone];
        copy.manHours = [self.manHours copyWithZone:zone];
        copy.orderType = self.orderType;
        copy.collection = [self.collection copyWithZone:zone];
        copy.fixedPic = [self.fixedPic copyWithZone:zone];
        copy.startTime = [self.startTime copyWithZone:zone];
        copy.faulttypeName = [self.faulttypeName copyWithZone:zone];
        copy.faultId = [self.faultId copyWithZone:zone];
        copy.receiveState = [self.receiveState copyWithZone:zone];
        copy.faulttype = [self.faulttype copyWithZone:zone];
        copy.faulttypeType = [self.faulttypeType copyWithZone:zone];
        copy.taskType = [self.taskType copyWithZone:zone];
        copy.longTime = self.longTime;
        copy.contactTel = [self.contactTel copyWithZone:zone];
        copy.receiveTime = [self.receiveTime copyWithZone:zone];
        copy.integralGrab = [self.integralGrab copyWithZone:zone];
    }
    
    return copy;
}


@end
