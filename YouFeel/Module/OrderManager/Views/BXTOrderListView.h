//
//  BXTOrderListView.h
//  BXT
//
//  Created by Jason on 15/9/14.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDataRequest.h"
#import "BXTSelectBoxView.h"

typedef NS_ENUM(NSInteger, RefreshType) {
    Down,
    Up
};

@interface BXTOrderListView : UIView <UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate>
{
    NSMutableArray   *repairListArray;
    UITableView      *currentTableView;
    NSInteger        currentPage;
    RefreshType      refreshType;
    NSInteger        selectTag;
    NSString         *orderID;
    BXTSelectBoxView *boxView;
    NSArray          *comeTimeArray;
    
    UIView *bgView;
    UIDatePicker *datePicker;
    UIView *toolView;
    NSDate *originDate;
    NSTimeInterval timeInterval;
}

@property (nonatomic ,strong) NSString *isReacive;
@property (nonatomic ,strong) NSString *repairState;
@property (nonatomic ,assign) CGFloat startPointY;
@property (nonatomic ,assign) BOOL isRequesting;

- (instancetype)initWithFrame:(CGRect)frame andState:(NSString *)state andRepairerIsReacive:(NSString *)reacive;

@end
