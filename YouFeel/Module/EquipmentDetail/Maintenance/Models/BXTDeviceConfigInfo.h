//
//  BXTDeviceConfigInfo.h
//  YouFeel
//
//  Created by Jason on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTDeviceConfigInfo : NSObject

@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *code_number;
@property (nonatomic, strong) NSArray  *control_user_arr;
@property (nonatomic, strong) NSString *control_users;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *install_time;
@property (nonatomic, strong) NSString *model_number;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *place_id;
@property (nonatomic, strong) NSString *server_area;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSArray  *pic;
@property (nonatomic, strong) NSString *stores_id;
@property (nonatomic, strong) NSString *take_over_time;

@end
