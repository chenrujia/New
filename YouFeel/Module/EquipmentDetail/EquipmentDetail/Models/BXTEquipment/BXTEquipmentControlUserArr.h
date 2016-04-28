//
//  BXTEquipmentControlUserArr.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentControlUserArr : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *controlUserArrIdentifier;
@property (nonatomic, copy) NSString *duty_id;
@property (nonatomic, copy) NSString *headMedium;
@property (nonatomic, copy) NSString *out_userid;
@property (nonatomic, copy) NSString *department_id;
@property (nonatomic, copy) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
