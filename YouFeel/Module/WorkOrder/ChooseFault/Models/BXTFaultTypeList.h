//
//  BXTFaultTypeList.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTFaultTypeList : NSObject

@property (nonatomic, copy) NSString *faulttype_type_name;
@property (nonatomic, copy) NSString *faultID;
@property (nonatomic, copy) NSString *faulttype_type;
@property (nonatomic, copy) NSString *faulttype;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
