//
//  BXTEquipmentState.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentState : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *device_id;
@property (nonatomic, strong) NSString *state_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *desc;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
