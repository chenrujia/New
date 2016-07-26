//
//  BXTMeterReadingRecordDayListInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/20.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTRecordDayListsInfo, BXTSubRecordDayDataInfo;

@interface BXTMeterReadingRecordDayListInfo : NSObject

@property (nonatomic, strong) NSArray<BXTRecordDayListsInfo *> *lists;
@property (nonatomic, copy) NSString *pricing_scheme_id;
@property (nonatomic, copy) NSString *measurement_path;
@property (nonatomic, copy) NSString *code_number;
@property (nonatomic, copy) NSString *server_area;
@property (nonatomic, copy) NSString *place_name;
@property (nonatomic, copy) NSString *device_id;
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

@interface BXTRecordDayListsInfo : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) BXTSubRecordDayDataInfo *data;

@end

@interface BXTSubRecordDayDataInfo : NSObject

@property (nonatomic, assign) NSInteger peak_period_amount;
@property (nonatomic, assign) NSInteger use_amount;
@property (nonatomic, assign) NSInteger flat_section_amount;
@property (nonatomic, assign) NSInteger valley_section_amount;
@property (nonatomic, assign) NSInteger peak_segment_amount;
@property (nonatomic, assign) NSInteger temperature;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, assign) NSInteger wind_force;

@end

