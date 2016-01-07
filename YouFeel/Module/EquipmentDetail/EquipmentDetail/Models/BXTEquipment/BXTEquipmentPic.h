//
//  BXTEquipmentPic.h
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BXTEquipmentPic : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *picIdentifier;
@property (nonatomic, strong) NSString *uploadTime;
@property (nonatomic, strong) NSString *photoThumbFile;
@property (nonatomic, strong) NSString *photoFile;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
