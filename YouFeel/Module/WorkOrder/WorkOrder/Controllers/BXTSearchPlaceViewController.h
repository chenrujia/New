//
//  BXTSearchPlaceViewController.h
//  YouFeel
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTPlaceInfo.h"
#import "BXTAllDepartmentInfo.h"

typedef NS_ENUM(NSInteger, SearchVCType)
{
    PlaceSearchType,//位置筛选
    FaultSearchType,//故障类型筛选
    DepartmentSearchType//部门筛选
};

typedef void (^ChoosePlace)(BXTBaseClassifyInfo *classifyInfo,NSString *name);

@interface BXTSearchPlaceViewController : BXTBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;
@property (nonatomic, assign) SearchVCType searchType;
@property (nonatomic, copy) ChoosePlace selectPlace;

- (void)userChoosePlace:(NSArray *)array type:(SearchVCType)type block:(ChoosePlace)place;

- (IBAction)commitClick:(id)sender;
- (IBAction)switchValueChanged:(id)sender;

@end
