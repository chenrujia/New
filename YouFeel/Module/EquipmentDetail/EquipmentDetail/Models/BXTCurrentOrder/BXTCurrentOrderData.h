//
//  BXTCurrentOrderData.h
//
//  Created by 孝意 满 on 15/12/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTCurrentOrderData : NSObject

@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *subgroup_name;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *fault;
@property (nonatomic, copy) NSString *faulttype_name;
@property (nonatomic, copy) NSString *cause;
@property (nonatomic, copy) NSString *repair_time;
@property (nonatomic, copy) NSString *is_receive;
@property (nonatomic, copy) NSString *dataIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
