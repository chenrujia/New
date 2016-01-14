//
//  BXTEquipmentFactoryInfo.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentFactoryInfo : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *factoryInfoIdentifier;
@property (nonatomic, strong) NSString *bread;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *linkman;
@property (nonatomic, strong) NSString *factory_name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
