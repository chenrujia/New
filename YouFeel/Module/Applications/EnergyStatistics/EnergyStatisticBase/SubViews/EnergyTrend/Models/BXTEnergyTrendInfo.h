//
//  BXTEnergyTrendInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTEnergyTrendInfo : NSObject

@property (nonatomic, assign) NSInteger energy_consumption_budget;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger mom_money;
@property (nonatomic, copy  ) NSString  *mom_money_per;
@property (nonatomic, copy  ) NSString  *money_budget_diff_per;
@property (nonatomic, copy  ) NSString  *temperature;
@property (nonatomic, copy  ) NSString  *month;
@property (nonatomic, copy  ) NSString  *an_money_per;
@property (nonatomic, assign) NSInteger mom_energy_consumption_sign;
@property (nonatomic, assign) NSInteger money_unit_area;
@property (nonatomic, assign) NSInteger an_money;
@property (nonatomic, assign) NSInteger an_energy_consumption;
@property (nonatomic, assign) NSInteger an_money_sign;
@property (nonatomic, copy  ) NSString  *year;
@property (nonatomic, assign) NSInteger mom_money_sign;
@property (nonatomic, assign) NSInteger energy_consumption;
@property (nonatomic, assign) NSInteger mom_energy_consumption;
@property (nonatomic, assign) NSInteger money_budget_diff;
@property (nonatomic, assign) NSInteger energy_consumption_budget_diff;
@property (nonatomic, copy  ) NSString  *humidity;
@property (nonatomic, assign) NSInteger an_energy_consumption_sign;
@property (nonatomic, copy  ) NSString  *an_energy_consumption_per;
@property (nonatomic, assign) NSInteger money_budget;
@property (nonatomic, copy  ) NSString  *energy_consumption_budget_diff_per;
@property (nonatomic, assign) NSInteger energy_consumption_unit_area;
@property (nonatomic, copy  ) NSString  *mom_energy_consumption_per;
@property (nonatomic, assign) NSInteger true_money_diff;
@property (nonatomic, assign) NSInteger true_money;
@property (nonatomic, assign) NSInteger true_energy_consumption_diff;
@property (nonatomic, assign) NSInteger true_energy_consumption;

@end
