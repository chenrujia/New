//
//  BXTPersonChecks.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTPersonChecks : NSObject

@property (nonatomic, strong) NSString *checks_user_department;
@property (nonatomic, strong) NSString *checks_user_mobile;
@property (nonatomic, strong) NSString *checks_user_pic;
@property (nonatomic, strong) NSString *state_name;
@property (nonatomic, strong) NSString *checks_user;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *checks_user_out_userid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
