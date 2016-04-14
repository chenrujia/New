//
//  BXTMailListModel.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTMailListModel : NSObject

@property (nonatomic, copy) NSString *department_id;
@property (nonatomic, copy) NSString *department_name;
@property (nonatomic, copy) NSString *duty_id;
@property (nonatomic, copy) NSString *duty_name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *out_userid;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *subgroup_id;
@property (nonatomic, copy) NSString *subgroup_name;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
