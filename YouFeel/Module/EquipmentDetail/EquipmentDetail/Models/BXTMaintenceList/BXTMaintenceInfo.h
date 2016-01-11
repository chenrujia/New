//
//  BXTMaintenceInfo.h
//  YouFeel
//
//  Created by Jason on 16/1/8.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTMaintenceInfo : NSObject

@property (nonatomic, strong) NSNumber *maintenceID;
@property (nonatomic, strong) NSArray  *inspection_info;
@property (nonatomic, strong) NSNumber *inspection_item_id;
@property (nonatomic, strong) NSString *inspection_title;
@property (nonatomic, strong) NSString *operating_condition_content;
@property (nonatomic, strong) NSString *operating_condition_title;
@property (nonatomic, strong) NSNumber *task_id;
@property (nonatomic, strong) NSString *time_name;

@end
