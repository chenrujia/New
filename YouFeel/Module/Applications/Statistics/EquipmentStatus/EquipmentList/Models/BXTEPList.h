//
//  BXTEPList.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/26.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEPList : NSObject

@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *type_name;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *state_name;
@property (nonatomic, copy) NSString *stores_id;
@property (nonatomic, copy) NSString *code_number;
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *place_id;
@property (nonatomic, copy) NSString *type_id_attribute;
@property (nonatomic, copy) NSString *stores;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *EPID;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
