//
//  BXTPlaceInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTBaseClassifyInfo.h"

@class BXTLists;
@interface BXTPlaceInfo : BXTBaseClassifyInfo

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *del_state;
@property (nonatomic, copy) NSString *placeID;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *ppath;

@end

