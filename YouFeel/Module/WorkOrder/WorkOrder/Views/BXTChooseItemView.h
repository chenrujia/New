//
//  BXTChooseItemView.h
//  YouFeel
//
//  Created by Jason on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDeviceListInfo.h"

typedef NS_ENUM(NSInteger, ChooseViewType) {
    DeviceListType,
    DatePickerType
};

typedef void (^ChooseItemBlock)(id item,ChooseViewType chooseType,BOOL isDone);

@interface BXTChooseItemView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, assign) ChooseViewType    viewType;
@property (nonatomic, copy  ) ChooseItemBlock   chooseBlock;
@property (nonatomic, strong) NSArray           *devicesArray;
@property (nonatomic, strong) NSMutableArray    *markArray;
@property (nonatomic, strong) UITableView       *currentTable;
@property (nonatomic, strong) UIDatePicker      *currentDatePicker;
@property (nonatomic, strong) BXTDeviceListInfo *selectDeviceInfo;
@property (nonatomic, strong) NSDictionary      *selectTimeDic;

- (instancetype)initWithFrame:(CGRect)frame type:(ChooseViewType)cvType array:(NSArray *)array block:(ChooseItemBlock)block;
- (void)refreshChooseView:(ChooseViewType)cvType array:(NSArray *)array;

@end
