//
//  BXTPlace.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Lists;
@interface BXTPlace : NSObject


@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *del_state;

@property (nonatomic, copy) NSString *PlaceID;

@property (nonatomic, strong) NSArray<Lists *> *lists;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *lng;

@property (nonatomic, copy) NSString *lat;

@property (nonatomic, copy) NSString *place;

@property (nonatomic, copy) NSString *ppath;


@end
@interface Lists : NSObject

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *del_state;

@property (nonatomic, copy) NSString *subPlaceID;

@property (nonatomic, strong) NSArray *lists;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *lng;

@property (nonatomic, copy) NSString *lat;

@property (nonatomic, copy) NSString *place;

@property (nonatomic, copy) NSString *ppath;

@end
