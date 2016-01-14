//
//  BXTCurrentOrderData.h
//
//  Created by 孝意 满 on 15/12/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTCurrentOrderData : NSObject

@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) NSString *subgroup_name;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSString *fault;
@property (nonatomic, strong) NSString *faulttype_name;
@property (nonatomic, strong) NSString *cause;
@property (nonatomic, strong) NSString *repair_time;
@property (nonatomic, strong) NSString *is_receive;
@property (nonatomic, strong) NSString *dataIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
