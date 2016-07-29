//
//  BXTEnergyStatisticBaseView.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTGlobal.h"
#import "BXTHeaderFile.h"
#import "BXTEnergyStatisticFilterView.h"
#import "BXTDataRequest.h"
#import "MJExtension.h"

typedef NS_ENUM(NSInteger, ViewControllerType) {
    ViewControllerTypeOFMonth = 1,  // 选择年和月
    ViewControllerTypeOFYear    // 选择年份
};

@interface BXTEnergyStatisticBaseView : UIView <UITableViewDelegate, UITableViewDataSource>

/** ---- 初始化 ---- */
- (instancetype)initWithFrame:(CGRect)frame VCType:(ViewControllerType)vcType;
/** ---- 统计类型 ---- */
@property (nonatomic, assign) ViewControllerType vcType;

/** ---- 年份选择 ---- */
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, copy) NSString *timeStr;

/** ---- tableView ---- */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
