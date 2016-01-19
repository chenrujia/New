//
//  BXTSelectBoxView.h
//  BXT
//
//  Created by Jason on 15/8/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BoxSelectedType) {
    DepartmentView,
    ShopView,
    PositionView,
    GroupingView,
    FloorInfoView,
    AreaInfoView,
    ShopInfoView,
    FaultInfoView,
    SpecialOrderView,
    CheckProjectsView,
    Other
};

@protocol BXTBoxSelectedTitleDelegate <NSObject>

- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type;

@end

@interface BXTSelectBoxView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *markArray;
    UILabel *title_label;
    UITableView *currentTableView;
    NSString *markID;
}

@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,assign) BoxSelectedType boxType;
@property (nonatomic ,weak) id <BXTBoxSelectedTitleDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)rect boxTitle:(NSString *)title boxSelectedViewType:(BoxSelectedType)type listDataSource:(NSArray *)array markID:(NSString *)mark actionDelegate:(id <BXTBoxSelectedTitleDelegate>)delegate;
- (void)boxTitle:(NSString *)title boxSelectedViewType:(BoxSelectedType)type listDataSource:(NSArray *)array;

@end
