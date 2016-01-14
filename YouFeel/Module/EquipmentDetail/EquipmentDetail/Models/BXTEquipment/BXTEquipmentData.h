//
//  BXTEquipmentData.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentData : NSObject

@property (nonatomic, strong) NSString *factory_id;
@property (nonatomic, strong) NSString *code_number;
@property (nonatomic, strong) NSString *server_area;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *stores_id;
@property (nonatomic, strong) NSString *model_number;
@property (nonatomic, strong) NSString *type_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *install_time;
@property (nonatomic, strong) NSString *take_over_time;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *place_id;
@property (nonatomic, strong) NSString *type_name;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *operating_condition_id;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
