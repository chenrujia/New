//
//  BXTEquipmentData.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTEquipmentData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *factoryId;
@property (nonatomic, strong) NSArray *params;
@property (nonatomic, strong) NSString *codeNumber;
@property (nonatomic, strong) NSString *serverArea;
@property (nonatomic, strong) NSArray *operatingCondition;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *storesId;
@property (nonatomic, strong) NSString *modelNumber;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *installTime;
@property (nonatomic, strong) NSString *takeOverTime;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSArray *adsName;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSArray *factoryInfo;
@property (nonatomic, strong) NSArray *pic;
@property (nonatomic, strong) NSString *placeId;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSArray *controlUserArr;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *operatingConditionId;
@property (nonatomic, strong) NSString *controlUsers;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
