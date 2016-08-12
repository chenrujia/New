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
#import "BMDatePickerView.h"
#import "UIScrollView+EmptyDataSet.h"

/** ---- 能效趋势特殊 - 判断None ---- */
typedef NS_ENUM(NSInteger, ViewControllerType) {
    ViewControllerTypeOFMonth = 1,  // 选择年和月
    ViewControllerTypeOFYear,    // 选择年份
    ViewControllerTypeOFNone
};

@interface BXTEnergyStatisticBaseView : UIView <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** ---- 初始化 ---- */
- (instancetype)initWithFrame:(CGRect)frame VCType:(ViewControllerType)vcType;
/** ---- 统计类型 ---- */
@property (nonatomic, assign) ViewControllerType vcType;


/** ---- 时间选择器 ---- */
@property (nonatomic, strong) BXTEnergyStatisticFilterView *filterView;
/** ---- 年份选择 ---- */
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, copy) NSString *timeStr;
/** ---- 初始化时间 ---- */
- (void)initializeTime;

/** ---- tableView ---- */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
