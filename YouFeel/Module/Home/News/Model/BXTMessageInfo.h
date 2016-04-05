//
//  BXTMessageInfo.h
//  YouFeel
//
//  Created by Jason on 16/4/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTMessageInfo : NSObject

@property (nonatomic, copy) NSString *about_id;
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *send_time_name;
@property (nonatomic, copy) NSString *notice_title;
@property (nonatomic, copy) NSString *notice_desc;
@property (nonatomic, copy) NSString *notice_type;
@property (nonatomic, copy) NSString *event_type;

@end
