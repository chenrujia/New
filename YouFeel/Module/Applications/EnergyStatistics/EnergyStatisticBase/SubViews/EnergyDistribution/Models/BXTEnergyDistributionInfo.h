//
//  BXTEnergyDistributionInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTEYDTTotalInfo,BXTEYDTListsInfo;

@interface BXTEnergyDistributionInfo : NSObject

@property (nonatomic, strong) BXTEYDTTotalInfo *total;
@property (nonatomic, strong) NSArray<BXTEYDTListsInfo *> *lists;
@property (nonatomic, copy) NSString *unit;

@end

@interface BXTEYDTTotalInfo : NSObject

@property (nonatomic, assign) double an_money;
@property (nonatomic, assign) double energy_consumption;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) double an_money_sign;
@property (nonatomic, copy) NSString *mom_money_per;
@property (nonatomic, copy) NSString *an_money_per;
@property (nonatomic, copy) NSString *an_energy_consumption_per;
@property (nonatomic, assign) double mom_money;
@property (nonatomic, assign) double an_energy_consumption_sign;
@property (nonatomic, assign) double mom_money_sign;
@property (nonatomic, copy) NSString *mom_energy_consumption_per;
@property (nonatomic, assign) double mom_energy_consumption_sign;
@property (nonatomic, assign) double an_energy_consumption;
@property (nonatomic, assign) double mom_energy_consumption;
@property (nonatomic, assign) double true_money_diff;
@property (nonatomic, assign) double true_money;
@property (nonatomic, assign) double true_energy_consumption_diff;
@property (nonatomic, assign) double true_energy_consumption;

@end

@interface BXTEYDTListsInfo : NSObject

@property (nonatomic, copy) NSString *energyID;
@property (nonatomic, assign) double energy_consumption;
@property (nonatomic, copy) NSString *ppath;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) double an_money;
@property (nonatomic, copy) NSString *an_money_per;
@property (nonatomic, copy) NSString *an_energy_consumption_per;
@property (nonatomic, assign) double money_per;
@property (nonatomic, assign) double an_money_sign;
@property (nonatomic, assign) double an_energy_consumption_sign;
@property (nonatomic, copy) NSString *mom_money_per;
@property (nonatomic, assign) double mom_money_sign;
@property (nonatomic, assign) double mom_money;
@property (nonatomic, copy) NSString *mom_energy_consumption_per;
@property (nonatomic, assign) double energy_consumption_per;
@property (nonatomic, assign) double mom_energy_consumption_sign;
@property (nonatomic, assign) double an_energy_consumption;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double mom_energy_consumption;

@end

