//
//  BXTInspectionBase.h
//
//  Created by 孝意 满 on 16/1/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTInspectionBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double number;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) double count;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, strong) NSString *returncode;
@property (nonatomic, assign) double totalNumber;
@property (nonatomic, assign) double totalPages;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
