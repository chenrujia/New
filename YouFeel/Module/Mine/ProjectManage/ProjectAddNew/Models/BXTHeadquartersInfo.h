//
//  BXTHeadquartersInfo.h
//  BXT
//
//  Created by Jason on 15/8/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTHeadquartersInfo : NSObject

@property (nonatomic ,strong) NSString *full_name;
@property (nonatomic ,strong) NSString *company_id;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *pid;
@property (nonatomic ,strong) NSString *short_name;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

@end
