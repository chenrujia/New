//
//  BXTInspectionData.h
//
//  Created by 孝意 满 on 16/1/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTInspectionData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *inspectionCode;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *faulttypeName;
@property (nonatomic, strong) NSString *faulttypeTypeName;
@property (nonatomic, strong) NSString *inspectionItemName;
@property (nonatomic, strong) NSString *inspectionItemId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *repairUser;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *inspectionTime;
@property (nonatomic, strong) NSString *workorderId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
