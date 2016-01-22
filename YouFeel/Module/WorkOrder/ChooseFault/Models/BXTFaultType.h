//
//  BXTFaultType.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTFaultType : NSObject

@property (nonatomic, copy) NSString *faultintegral;
@property (nonatomic, copy) NSString *faultID;
@property (nonatomic, copy) NSString *faulttype_type;
@property (nonatomic, copy) NSString *faulttype;
@property (nonatomic, copy) NSString *subgroup;
@property (nonatomic, copy) NSString *subgroup_name;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
