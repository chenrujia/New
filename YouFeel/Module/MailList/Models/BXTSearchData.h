//
//  BXTSearchData.h
//
//  Created by 孝意 满 on 16/1/5
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTSearchData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *roleId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *head;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *delTime;
@property (nonatomic, strong) NSString *shopsId;
@property (nonatomic, strong) NSString *roleName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *nameShort;
@property (nonatomic, strong) NSString *outUserid;
@property (nonatomic, strong) NSString *subgroupName;
@property (nonatomic, strong) NSString *directoryId;
@property (nonatomic, strong) NSString *delState;
@property (nonatomic, strong) NSString *delUser;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *subgroup;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
