//
//  BXTMeterReadingRecordListInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/21.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTRecordListsInfo;

@interface BXTMeterReadingRecordListInfo : NSObject

@property (nonatomic, strong) NSArray<BXTRecordListsInfo *> *lists;
@property (nonatomic, copy) NSString *pricing_scheme_id;
@property (nonatomic, copy) NSString *measurement_path;
@property (nonatomic, copy) NSString *code_number;
@property (nonatomic, copy) NSString *server_area;
@property (nonatomic, copy) NSString *place_name;
@property (nonatomic, copy) NSString *device_id;
@property (nonatomic, copy) NSString *scheme_code;
@property (nonatomic, copy) NSString *meter_condition;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *meterReadingID;
@property (nonatomic, copy) NSString *check_type_name;
@property (nonatomic, copy) NSString *price_type_name;
@property (nonatomic, copy) NSString *meter_name;
@property (nonatomic, copy) NSString *check_price_type;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *state_name;
@property (nonatomic, copy) NSString *check_type;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *price_type_id;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *measurement_path_name;
@property (nonatomic, copy) NSString *is_collect;

@end

@interface BXTRecordListsInfo : NSObject

@property (nonatomic, copy) NSString *valley_section_amount;
@property (nonatomic, copy) NSString *use_amount;
@property (nonatomic, copy) NSString *peak_segment_num;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *peak_segment_amount;
@property (nonatomic, copy) NSString *peak_period_amount;
@property (nonatomic, copy) NSString *flat_section_amount;
@property (nonatomic, copy) NSString *peak_period_pic;
@property (nonatomic, copy) NSString *flat_section_num;
@property (nonatomic, copy) NSString *peak_segment_pic;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *meter_id;
@property (nonatomic, copy) NSString *weather_id;
@property (nonatomic, copy) NSString *listInfoID;
@property (nonatomic, copy) NSString *total_num;
@property (nonatomic, copy) NSString *del_state;
@property (nonatomic, copy) NSString *valley_section_num;
@property (nonatomic, copy) NSString *flat_section_pic;
@property (nonatomic, copy) NSString *valley_section_pic;
@property (nonatomic, copy) NSString *total_pic;
@property (nonatomic, copy) NSString *peak_period_num;

@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *humidity;
@property (nonatomic, copy) NSString *wind_force;

@end

