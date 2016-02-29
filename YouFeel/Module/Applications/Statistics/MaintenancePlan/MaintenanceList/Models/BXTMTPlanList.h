//
//  BXTMTPlanList.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/26.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTMTPlanList : NSObject

@property (nonatomic, copy) NSString *faulttype_id;
@property (nonatomic, copy) NSString *inspection_code;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *task_id;
@property (nonatomic, copy) NSString *end_date;
@property (nonatomic, copy) NSString *device_id;
@property (nonatomic, copy) NSString *device_state;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *over_date;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *over_time;
@property (nonatomic, copy) NSString *PlanID;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *workorder_id;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *start_date;
@property (nonatomic, copy) NSString *inspection_item_id;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *faulttype;
@property (nonatomic, copy) NSString *user_name;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
