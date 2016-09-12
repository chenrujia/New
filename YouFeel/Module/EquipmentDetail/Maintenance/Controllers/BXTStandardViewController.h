//
//  BXTStandardViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTDeviceMaintenceInfo.h"

@interface BXTStandardViewController : BXTBaseViewController

/**
 * 维保作业 - 安全指引（点击我已阅读 返回上一页面）maintence 为 @""
 * 维保档案 - 安全指引（点击我已阅读 返回次二页面）
 */
- (instancetype)initWithSafetyGuidelines:(NSString *)safety
                               maintence:(BXTDeviceMaintenceInfo *)maintence
                                deviceID:(NSString *)devID
                         deviceStateList:(NSArray *)states;

@end
