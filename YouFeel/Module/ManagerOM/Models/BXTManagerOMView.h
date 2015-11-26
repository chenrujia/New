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
    DoneType = 2
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
}

@property (nonatomic ,assign) BOOL isRequesting;
@property (nonatomic ,assign) OrderType orderType;

- (instancetype)initWithFrame:(CGRect)frame andOrderType:(OrderType )order_type;

@end
