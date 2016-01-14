//
//  BXTEquipmentControlUserArr.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEquipmentControlUserArr : NSObject

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *controlUserArrIdentifier;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *head_pic;
@property (nonatomic, strong) NSString *out_userid;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
