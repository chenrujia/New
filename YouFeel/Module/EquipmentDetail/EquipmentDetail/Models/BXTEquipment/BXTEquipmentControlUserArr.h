//
//  BXTEquipmentControlUserArr.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTEquipmentControlUserArr : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *controlUserArrIdentifier;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *headPic;
@property (nonatomic, strong) NSString *outUserid;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
