//
//  BXTCurrentOrderData.h
//
//  Created by 孝意 满 on 15/12/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTCurrentOrderData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *cause;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *integral;
@property (nonatomic, strong) NSString *repairUserName;
@property (nonatomic, strong) NSString *storesName;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *urgent;
@property (nonatomic, strong) NSString *fault;
@property (nonatomic, strong) NSString *repairTime;
@property (nonatomic, strong) NSString *evaluationNotes;
@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSString *isReceive;
@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) NSString *repairstate;
@property (nonatomic, strong) NSString *isRepairing;
@property (nonatomic, strong) NSString *operating;
@property (nonatomic, strong) NSString *workprocess;
@property (nonatomic, strong) NSString *isRead;
@property (nonatomic, strong) NSString *isGadget;
@property (nonatomic, strong) NSString *repairUser;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *subgroupName;
@property (nonatomic, strong) NSString *subgroup;
@property (nonatomic, assign) id storesId;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSString *integralEdit;
@property (nonatomic, strong) NSString *isDispatch;
@property (nonatomic, strong) NSString *manHours;
@property (nonatomic, assign) double orderType;
@property (nonatomic, strong) NSString *collection;
@property (nonatomic, strong) NSString *fixedPic;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *faulttypeName;
@property (nonatomic, strong) NSString *faultId;
@property (nonatomic, strong) NSString *receiveState;
@property (nonatomic, strong) NSString *faulttype;
@property (nonatomic, strong) NSString *faulttypeType;
@property (nonatomic, strong) NSString *taskType;
@property (nonatomic, assign) double longTime;
@property (nonatomic, strong) NSString *contactTel;
@property (nonatomic, strong) NSString *receiveTime;
@property (nonatomic, strong) NSString *integralGrab;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
