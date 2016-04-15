//
//  BXTMailUserListSimpleInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTMailUserListSimpleInfo : NSObject

@property (nonatomic, copy) NSString *out_userid;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headMedium;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
