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

@property (nonatomic, assign) NSInteger an_money;
@property (nonatomic, assign) NSInteger energy_consumption;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger an_money_sign;
@property (nonatomic, copy) NSString *mom_money_per;
@property (nonatomic, copy) NSString *an_money_per;
@property (nonatomic, copy) NSString *an_energy_consumption_per;
@property (nonatomic, assign) NSInteger mom_money;
@property (nonatomic, assign) NSInteger an_energy_consumption_sign;
@property (nonatomic, assign) NSInteger mom_money_sign;
@property (nonatomic, copy) NSString *mom_energy_consumption_per;
@property (nonatomic, assign) NSInteger mom_energy_consumption_sign;
@property (nonatomic, assign) NSInteger an_energy_consumption;
@property (nonatomic, assign) NSInteger mom_energy_consumption;

@end

@interface BXTEYDTListsInfo : NSObject

@property (nonatomic, copy) NSString *energyID;
@property (nonatomic, copy) NSString *energy_consumption;
@property (nonatomic, copy) NSString *ppath;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger an_money;
@property (nonatomic, copy) NSString *an_money_per;
@property (nonatomic, copy) NSString *an_energy_consumption_per;
@property (nonatomic, assign) CGFloat money_per;
@property (nonatomic, assign) NSInteger an_money_sign;
@property (nonatomic, assign) NSInteger an_energy_consumption_sign;
@property (nonatomic, copy) NSString *mom_money_per;
@property (nonatomic, assign) NSInteger mom_money_sign;
@property (nonatomic, assign) NSInteger mom_money;
@property (nonatomic, copy) NSString *mom_energy_consumption_per;
@property (nonatomic, assign) CGFloat energy_consumption_per;
@property (nonatomic, assign) NSInteger mom_energy_consumption_sign;
@property (nonatomic, assign) NSInteger an_energy_consumption;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger mom_energy_consumption;

@end

