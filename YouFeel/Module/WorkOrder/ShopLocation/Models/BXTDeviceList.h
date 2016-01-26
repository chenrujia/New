//
//  BXTDeviceList.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/26.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTDeviceList : NSObject

@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *deviceID;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
