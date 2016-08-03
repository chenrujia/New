//
//  BXTSelectItemView.h
//  YouFeel
//
//  Created by Jason on 16/6/27.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTBaseClassifyInfo.h"

typedef NS_ENUM(NSInteger, SearchVCType)
{
    PlaceSearchType,//位置筛选
    FaultSearchType,//故障类型筛选
    DepartmentSearchType,//部门筛选
    FilterSearchType//筛选
};

typedef void (^ChooseItem)(BXTBaseClassifyInfo *classifyInfo,NSString *name);

@interface BXTSelectItemView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView         *currentTable;
@property (nonatomic, strong) UISearchBar         *searchBarView;
//手动or自动
@property (nonatomic, assign) BOOL                isOpen;
//资源数据
@property (nonatomic, strong) NSArray             *dataSource;
//变动的数据
@property (nonatomic, strong) NSMutableArray      *mutableArray;
//标记数组
@property (nonatomic, strong) NSMutableArray      *marksArray;
//当前选择的区
@property (nonatomic, strong) NSIndexPath         *lastIndexPath;
//当前选择的行
@property (nonatomic, assign) NSInteger           lastIndex;
//筛选结果数组
@property (nonatomic, strong) NSMutableArray      *resultsArray;
//筛选结果标记数组
@property (nonatomic, strong) NSMutableArray      *resultMarksArray;
//筛选出来的标题（标题是一级一级拼接起来的）
@property (nonatomic, strong) NSMutableArray      *searchTitlesArray;
//手动选择的结果
@property (nonatomic, strong) BXTBaseClassifyInfo *manualClassifyInfo;
//自动选择的结果
@property (nonatomic, strong) BXTBaseClassifyInfo *autoClassifyInfo;
//判断是否是从维修过程过来的
@property (nonatomic, assign) BOOL         isProgress;

@property (nonatomic, copy  ) NSString     *faultTypeID;
@property (nonatomic, assign) SearchVCType searchType;
@property (nonatomic, copy  ) ChooseItem   selectItemBlock;

- (instancetype)initWithFrame:(CGRect)frame tableViewFrame:(CGRect)tableFrame datasource:(NSArray *)array isProgress:(BOOL)progress type:(SearchVCType)type block:(ChooseItem)itemBlock;

//过滤出复合筛选字符串的数据
- (NSMutableArray *)filterItemsWithData:(NSArray *)array searchString:(NSString *)searchStr lastLevelTitle:(NSString *)lastTitle;

@end
