//
//  BXTReadNotice.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTReadNotice : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *noticeID;
@property (nonatomic, copy) NSString *view_url;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
