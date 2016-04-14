//
//  BXTMailUserListInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTLists;

@interface BXTMailUserListInfo : NSObject

@property (nonatomic, strong) NSArray<BXTLists *> *lists;

@property (nonatomic, assign) NSInteger shop_id;

@end

@interface BXTLists : NSObject

@property (nonatomic, copy) NSString *shop_id;

@property (nonatomic, copy) NSString *userID;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *headMedium;

@end

