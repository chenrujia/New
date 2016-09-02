//
//  BXTOrderDetailDataManager.m
//  YouFeel
//
//  Created by Jason on 16/9/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTOrderDetailDataManager.h"
#import "BXTHeaderFile.h"
#import "MJExtension.h"

@interface BXTOrderDetailDataManager()<BXTDataResponseDelegate>

@end

@implementation BXTOrderDetailDataManager

- (instancetype)initWithOrderID:(NSString *)orderID requestType:(DataRequestType)requestType
{
    self = [super init];
    if (self)
    {
        self.successSubject = [RACSubject subject];
        self.failSubject = [RACSubject subject];
        self.dataRequestType = requestType;
        
        [BXTGlobal showLoadingMBP:@"加载中..."];
        if (requestType == OrderDetailType)
        {
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request repairDetail:orderID];
        }
        else if (requestType == AcceptOrderType)
        {
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request reaciveOrderID:orderID];
        }
    }
    return self;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == RepairDetail && data.count)
    {
        NSDictionary *dictionary = data[0];
        
        [BXTRepairDetailInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"orderID":@"id"};
        }];
        [BXTMaintenanceManInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"mmID":@"id"};
        }];
        [BXTDeviceMMListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"deviceMMID":@"id"};
        }];
        [BXTAdsNameInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"adsNameID":@"id"};
        }];
        [BXTRepairPersonInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"rpID":@"id"};
        }];
        [BXTFaultPicInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"picID":@"id"};
        }];
        
        BXTRepairDetailInfo *repairDetail = [BXTRepairDetailInfo mj_objectWithKeyValues:dictionary];
        [self.successSubject sendNext:repairDetail];
    }
    else if (type == ReaciveOrder)
    {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReaciveOrderSuccess" object:nil];
            [BXTGlobal showText:@"抢单成功！" view:window completionBlock:^{
                [self.successSubject sendNext:nil];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"041"])
        {
            [BXTGlobal showText:@"工单已被抢！" view:window completionBlock:^{
                [self.successSubject sendNext:nil];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"002"])
        {
            [BXTGlobal showText:@"抢单失败，工单已取消！" view:window completionBlock:^{
                [self.successSubject sendNext:nil];
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    [self.failSubject sendNext:nil];
}

@end
