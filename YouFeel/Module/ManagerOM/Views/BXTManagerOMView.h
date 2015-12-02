//
//  BXTManagerOMView.h
//  YouFeel
//
//  Created by Jason on 15/11/26.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOPDropDownMenu.h"
#import "BXTDataRequest.h"

typedef NS_ENUM(NSInteger, RefreshType) {
    Down,
    Up
};

typedef NS_ENUM(NSInteger, OrderType) {
    OutTimeType = 0,
    DistributeType = 1,
    DoneType = 2,
    AllType = 3
};

@interface BXTManagerOMView : UIView <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>
{
    NSArray          *typesArray;
    NSInteger        currentPage;
    NSInteger        selectTag;
    RefreshType      refreshType;
    UITableView      *currentTableView;
    NSMutableArray   *repairListArray;
    NSString         *priorityType;//优先类型
    NSString         *groupID;
    //针对AllType
    NSString         *startTime;
    NSString         *endTime;
    NSString         *selectOT;//选择的工单类型
    NSArray          *groups;
    
}

@property (nonatomic ,assign) BOOL isRequesting;
@property (nonatomic ,assign) OrderType orderType;

- (instancetype)initWithFrame:(CGRect)frame andOrderType:(OrderType )order_type;
- (void)reloadAllType:(NSString *)startStr
           andEndTime:(NSString *)endStr
            andGourps:(NSArray *)theGroups
          andSelectOT:(NSString *)theOT;

@end