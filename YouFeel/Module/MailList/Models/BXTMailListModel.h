//
//  BXTMailListModel.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/4.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTMailListModel : NSObject

@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *role_name;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *out_userid;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
