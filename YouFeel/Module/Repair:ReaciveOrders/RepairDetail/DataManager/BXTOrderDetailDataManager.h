//
//  BXTOrderDetailDataManager.h
//  YouFeel
//
//  Created by Jason on 16/9/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXTRepairDetailInfo.h"

typedef NS_ENUM(NSInteger, DataRequestType)
{
    OrderDetailType = 1,//工单详情
    AcceptOrderType = 2//接单
};

@interface BXTOrderDetailDataManager : NSObject

@property (nonatomic, strong) RACSubject      *successSubject;
@property (nonatomic, strong) RACSubject      *failSubject;
@property (nonatomic, assign) DataRequestType dataRequestType;

- (instancetype)initWithOrderID:(NSString *)orderID requestType:(DataRequestType)requestType;

@end
