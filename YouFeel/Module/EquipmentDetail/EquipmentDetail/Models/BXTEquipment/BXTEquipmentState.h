//
//  BXTEquipmentState.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentState : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *device_id;
@property (nonatomic, copy) NSString *state_name;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *create_date;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
