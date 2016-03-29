//
//  BXTEquipmentParams.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentParams : NSObject

@property (nonatomic, copy) NSString *paramsIdentifier;
@property (nonatomic, copy) NSString *param_value;
@property (nonatomic, copy) NSString *param_key;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
