//
//  BXTEnergyTrendInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEnergyTrendInfo : NSObject

@property (nonatomic, assign) double energy_consumption_budget;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) double mom_money;
@property (nonatomic, copy  ) NSString  *mom_money_per;
@property (nonatomic, copy  ) NSString  *money_budget_diff_per;
@property (nonatomic, copy  ) NSString  *temperature;
@property (nonatomic, copy  ) NSString  *month;
@property (nonatomic, copy  ) NSString  *an_money_per;
@property (nonatomic, assign) double mom_energy_consumption_sign;
@property (nonatomic, assign) double money_unit_area;
@property (nonatomic, assign) double an_money;
@property (nonatomic, assign) double an_energy_consumption;
@property (nonatomic, assign) double an_money_sign;
@property (nonatomic, copy  ) NSString  *year;
@property (nonatomic, assign) double mom_money_sign;
@property (nonatomic, assign) double energy_consumption;
@property (nonatomic, assign) double mom_energy_consumption;
@property (nonatomic, assign) double money_budget_diff;
@property (nonatomic, assign) double energy_consumption_budget_diff;
@property (nonatomic, copy  ) NSString  *humidity;
@property (nonatomic, assign) double an_energy_consumption_sign;
@property (nonatomic, copy  ) NSString  *an_energy_consumption_per;
@property (nonatomic, assign) double money_budget;
@property (nonatomic, copy  ) NSString  *energy_consumption_budget_diff_per;
@property (nonatomic, assign) double energy_consumption_unit_area;
@property (nonatomic, copy  ) NSString  *mom_energy_consumption_per;
@property (nonatomic, assign) double true_money_diff;
@property (nonatomic, assign) double true_money;
@property (nonatomic, assign) double true_energy_consumption_diff;
@property (nonatomic, assign) double true_energy_consumption;

@end
