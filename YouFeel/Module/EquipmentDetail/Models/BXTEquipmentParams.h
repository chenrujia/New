//
//  BXTEquipmentParams.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTEquipmentParams : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *paramsIdentifier;
@property (nonatomic, strong) NSString *paramValue;
@property (nonatomic, strong) NSString *paramKey;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
