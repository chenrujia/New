//
//  BXTPersonChecks.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTPersonChecks : NSObject

@property (nonatomic, copy) NSString *checks_user_department;
@property (nonatomic, copy) NSString *checks_user_mobile;
@property (nonatomic, copy) NSString *checks_user_pic;
@property (nonatomic, copy) NSString *state_name;
@property (nonatomic, copy) NSString *checks_user;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *checks_user_out_userid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
