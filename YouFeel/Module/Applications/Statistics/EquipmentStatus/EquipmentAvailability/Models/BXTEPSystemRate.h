//
//  BXTEPSystemRate.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEPSystemRate : NSObject

@property (nonatomic, copy) NSString *stop;
@property (nonatomic, copy) NSString *stop_per;
@property (nonatomic, copy) NSString *working;
@property (nonatomic, copy) NSString *working_per;
@property (nonatomic, copy) NSString *type_name;
@property (nonatomic, copy) NSString *total;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
