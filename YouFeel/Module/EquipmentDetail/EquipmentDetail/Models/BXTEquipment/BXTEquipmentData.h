//
//  BXTEquipmentData.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentData : NSObject

@property (nonatomic, copy) NSString *factory_id;
@property (nonatomic, copy) NSString *params;
@property (nonatomic, copy) NSString *code_number;
@property (nonatomic, copy) NSString *server_area;
@property (nonatomic, strong) NSArray *params_info;
@property (nonatomic, copy) NSString *control_users_names;
@property (nonatomic, copy) NSString *place_name;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *model_number;
@property (nonatomic, copy) NSString *stores_id;
@property (nonatomic, copy) NSString *qrcode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *install_time;
@property (nonatomic, copy) NSString *take_over_time;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *dataIdentifier;
@property (nonatomic, copy) NSString *place_true_name;
@property (nonatomic, copy) NSString *place_id;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, strong) NSArray *pic_lists;
@property (nonatomic, copy) NSString *del_state;
@property (nonatomic, strong) NSDictionary *factory_info;
@property (nonatomic, copy) NSString *type_name;
@property (nonatomic, strong) NSArray *control_users_info;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *state_name;
@property (nonatomic, copy) NSString *operating_desc;
@property (nonatomic, copy) NSString *control_users;
@property (nonatomic, copy) NSString *state_color;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end





