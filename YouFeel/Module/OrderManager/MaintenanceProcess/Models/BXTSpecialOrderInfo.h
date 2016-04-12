//
//  BXTSpecialOrderInfo.h
//  YouFeel
//
//  Created by Jason on 16/4/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTSpecialOrderInfo : NSObject

@property (nonatomic, copy) NSString *param_desc;
@property (nonatomic, copy) NSString *specialOrderID;
@property (nonatomic, copy) NSString *param_value;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *param_key;

@end

@interface BXTDeviceStateInfo : NSObject

@property (nonatomic, copy) NSString *param_desc;
@property (nonatomic, copy) NSString *stateID;
@property (nonatomic, copy) NSString *param_value;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *param_key;

@end
