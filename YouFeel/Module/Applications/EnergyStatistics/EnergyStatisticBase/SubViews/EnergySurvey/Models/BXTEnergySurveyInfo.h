//
//  BXTEnergySurveyInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTEySyEleInfo,BXTEySyTheInfo,BXTEySyGasInfo,BXTEySyTotalInfo,BXTEySyWatInfo;

@interface BXTEnergySurveyInfo : NSObject

/** ---- 总数据 ---- */
@property (nonatomic, strong) BXTEySyTotalInfo *total;
/** ---- 燃气 ---- */
@property (nonatomic, strong) BXTEySyTheInfo *the;
/** ---- 热能 ---- */
@property (nonatomic, strong) BXTEySyGasInfo *gas;
/** ---- 电 ---- */
@property (nonatomic, strong) BXTEySyEleInfo *ele;
/** ---- 水 ---- */
@property (nonatomic, strong) BXTEySyWatInfo *wat;

@end

@interface BXTEySyEleInfo : NSObject

@property (nonatomic, assign) double an_money;
@property (nonatomic, assign) double an_sign;
@property (nonatomic, copy) NSString *mom;
@property (nonatomic, assign) double mom_money;
@property (nonatomic, copy) NSString *an;
@property (nonatomic, assign) double mom_sign;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) double per;

@end

@interface BXTEySyTheInfo : NSObject

@property (nonatomic, assign) double an_money;
@property (nonatomic, assign) double an_sign;
@property (nonatomic, copy) NSString *mom;
@property (nonatomic, assign) double mom_money;
@property (nonatomic, copy) NSString *an;
@property (nonatomic, assign) double mom_sign;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) double per;

@end

@interface BXTEySyGasInfo : NSObject

@property (nonatomic, assign) double an_money;
@property (nonatomic, assign) double an_sign;
@property (nonatomic, copy) NSString *mom;
@property (nonatomic, assign) double mom_money;
@property (nonatomic, copy) NSString *an;
@property (nonatomic, assign) double mom_sign;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) double per;

@end

@interface BXTEySyTotalInfo : NSObject

@property (nonatomic, assign) double an_money;
@property (nonatomic, assign) double an_sign;
@property (nonatomic, copy) NSString *mom;
@property (nonatomic, assign) double mom_money;
@property (nonatomic, copy) NSString *an;
@property (nonatomic, assign) double mom_sign;
@property (nonatomic, assign) double money;

@end

@interface BXTEySyWatInfo : NSObject

@property (nonatomic, assign) double an_money;
@property (nonatomic, assign) double an_sign;
@property (nonatomic, copy) NSString *mom;
@property (nonatomic, assign) double mom_money;
@property (nonatomic, copy) NSString *an;
@property (nonatomic, assign) double mom_sign;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) double per;

@end

