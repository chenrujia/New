//
//  BXTEquipmentFactoryInfo.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentFactoryInfo : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *factoryInfoIdentifier;
@property (nonatomic, copy) NSString *bread;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, copy) NSString *factory_name;
@property (nonatomic, copy) NSString *del_state;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
