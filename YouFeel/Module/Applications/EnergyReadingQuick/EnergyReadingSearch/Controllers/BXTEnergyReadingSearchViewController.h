//
//  BXTEnergyReadingSearchViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef NS_ENUM(NSInteger, SearchPushType) {
    SearchPushTypeOFElectricity = 1,    // 能源抄表 - 电
    SearchPushTypeOFWater,                  // 能源抄表 - 水
    SearchPushTypeOFGas,                     // 能源抄表 - 燃气
    SearchPushTypeOFHeat,                    // 能源抄表 - 热能
    SearchPushTypeOFQuick,                  // 快捷抄表
};

@interface BXTEnergyReadingSearchViewController : BXTBaseViewController

- (instancetype)initWithSearchPushType:(SearchPushType)pushType;

@end
