//
//  BXTEquipmentParams.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentParams : NSObject

@property (nonatomic, strong) NSString *paramsIdentifier;
@property (nonatomic, strong) NSString *param_value;
@property (nonatomic, strong) NSString *param_key;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
