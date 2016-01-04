//
//  BXTCurrentOrderBase.h
//
//  Created by 孝意 满 on 15/12/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTCurrentOrderBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) id page;
@property (nonatomic, assign) double number;
@property (nonatomic, assign) id pages;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *returncode;
@property (nonatomic, assign) double totalNumber;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
