//
//  BXTMailRootInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTMailRootInfo : NSObject

@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSArray *data;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
