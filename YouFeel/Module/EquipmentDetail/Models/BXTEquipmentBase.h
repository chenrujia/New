//
//  BXTEquipmentBase.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTEquipmentBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *returncode;
@property (nonatomic, assign) double number;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) double totalNumber;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
