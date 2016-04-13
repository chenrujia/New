//
//  BXTSelectBoxView.m
//  BXT
//
//  Created by Jason on 15/8/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTSelectBoxView.h"
#import "BXTHeaderFile.h"
#import "BXTSettingTableViewCell.h"
#import "BXTDepartmentInfo.h"
#import "BXTFloorInfo.h"
#import "BXTFaultInfo.h"
#import "BXTGroupingInfo.h"
#import "BXTDeviceMaintenceInfo.h"
#import "BXTSpecialOrderInfo.h"

@implementation BXTSelectBoxView

- (instancetype)initWithFrame:(CGRect)rect boxTitle:(NSString *)title boxSelectedViewType:(BoxSelectedType)type listDataSource:(NSArray *)array markID:(NSString *)mark actionDelegate:(id <BXTBoxSelectedTitleDelegate>)delegate
{
    self = [super initWithFrame:rect];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"EFF3F6");
        markArray = [NSMutableArray array];
        self.dataArray = array;
        self.delegate = delegate;
        self.boxType = type;
        for (NSInteger i = 0; i < _dataArray.count; i++)
        {
            [markArray addObject:@"0"];
        }
        
        markID = mark;
        /**标记上次的选项**/
        [self mark];
        
        UIView *titleBV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        titleBV.backgroundColor = [UIColor whiteColor];
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200.f, 20.f)];
        title_label.center = CGPointMake(SCREEN_WIDTH/2.f, 20.f);
        title_label.textAlignment = NSTextAlignmentCenter;
        title_label.textColor = colorWithHexString(@"000000");
        title_label.font = [UIFont systemFontOfSize:17.f];
        title_label.text = title;
        [titleBV addSubview:title_label];
        [self addSubview:titleBV];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.4f, SCREEN_WIDTH, 0.6f)];
        lineView.backgroundColor = colorWithHexString(@"e2e6e8");
        [self addSubview:lineView];
        
        currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), SCREEN_WIDTH, rect.size.height - 110.f) style:UITableViewStylePlain];
        currentTableView.backgroundColor = [UIColor whiteColor];
        currentTableView.rowHeight = 50.f;
        [currentTableView registerClass:[BXTSettingTableViewCell class] forCellReuseIdentifier:@"BoxCell"];
        currentTableView.delegate = self;
        currentTableView.dataSource = self;
        currentTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:currentTableView];
        
        UIView *buttonBV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(rect) - 56.f, CGRectGetWidth(rect), 56.f)];
        buttonBV.backgroundColor = [UIColor whiteColor];
        [self addSubview:buttonBV];
        
        UIView *lineTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.f, SCREEN_WIDTH, 0.5f)];
        lineTwoView.backgroundColor = colorWithHexString(@"e2e6e8");
        [buttonBV addSubview:lineTwoView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelBtn setFrame:CGRectMake(0, 6, 120.f, 44.f)];
        [cancelBtn setCenter:CGPointMake(SCREEN_WIDTH/4.f, cancelBtn.center.y)];
        [cancelBtn setTitleColor:colorWithHexString(@"6E6E6E") forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        @weakify(self);
        [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate boxSelectedObj:nil selectedType:self.boxType];
        }];
        [buttonBV addSubview:cancelBtn];
        
        UIView *lineThreeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.f - 1.f, 16.f, 2.f, 24.f)];
        lineThreeView.backgroundColor = colorWithHexString(@"ACADB2");
        [buttonBV addSubview:lineThreeView];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [doneBtn setFrame:CGRectMake(0, 6, 120.f, 44.f)];
        [doneBtn setCenter:CGPointMake(SCREEN_WIDTH/4.f*3.f, cancelBtn.center.y)];
        [doneBtn setTitleColor:colorWithHexString(@"3CAFFF") forState:UIControlStateNormal];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate boxSelectedObj:self.choosedItem selectedType:self.boxType];
        }];
        [buttonBV addSubview:doneBtn];
    }
    return self;
}

- (void)boxTitle:(NSString *)title boxSelectedViewType:(BoxSelectedType)type listDataSource:(NSArray *)array
{
    title_label.text = [NSString stringWithFormat:@"%@",title];
    _boxType = type;
    _dataArray = array;
    [markArray removeAllObjects];
    for (NSInteger i = 0; i < _dataArray.count; i++)
    {
        [markArray addObject:@"0"];
    }
    /**标记上次的选项**/
    [self mark];
    
    [currentTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoxCell" forIndexPath:indexPath];
    CGRect rect = cell.titleLabel.frame;
    rect.size = CGSizeMake(SCREEN_WIDTH - 30.f, rect.size.height);
    cell.titleLabel.frame = rect;
    cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([markArray[indexPath.row] integerValue])
    {
        cell.checkImgView.hidden = NO;
        cell.titleLabel.textColor = colorWithHexString(@"3cafff");
    }
    else
    {
        cell.checkImgView.hidden = YES;
        cell.titleLabel.textColor = colorWithHexString(@"000000");
    }
    
    if (_boxType == DepartmentView)
    {
        BXTDepartmentInfo *departmentInfo = _dataArray[indexPath.row];
        cell.titleLabel.text = departmentInfo.department;
    }
    else if (_boxType == PositionView)
    {
        BXTPostionInfo *positionInfo = _dataArray[indexPath.row];
        cell.titleLabel.text = positionInfo.duty_name;
    }
    else if (_boxType == FloorInfoView)
    {
        BXTFloorInfo *floorInfo = _dataArray[indexPath.row];
        cell.titleLabel.text = floorInfo.area_name;
    }
    else if (_boxType == AreaInfoView)
    {
        BXTAreaInfo *areaInfo = _dataArray[indexPath.row];
        cell.titleLabel.text = areaInfo.place_name;
    }
    else if (_boxType == ShopInfoView)
    {
        if ([_dataArray[indexPath.row] isKindOfClass:[NSString class]])
        {
            cell.titleLabel.text = _dataArray[indexPath.row];
        }
        else
        {
            BXTShopInfo *shopInfo = _dataArray[indexPath.row];
            cell.titleLabel.text = shopInfo.stores_name;
        }
    }
    else if (_boxType == GroupingView)
    {
        BXTGroupingInfo *groupInfo = _dataArray[indexPath.row];
        cell.titleLabel.text = groupInfo.subgroup;
    }
    else if (_boxType == SpecialOrderView)
    {
        NSDictionary *dic = _dataArray[indexPath.row];
        cell.titleLabel.text = [dic objectForKey:@"collection"];
    }
    else if (_boxType == CheckProjectsView)
    {
        BXTDeviceMaintenceInfo *maintence = _dataArray[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",maintence.time_name,maintence.inspection_title];
    }
    else if (_boxType == OrderDeviceStateView)
    {
        BXTDeviceStateInfo *deviceInfo = _dataArray[indexPath.row];
        cell.titleLabel.text = deviceInfo.param_value;
    }
    else if (_boxType == FaultTypeView)
    {
        BXTFaultInfo *faultInfo = _dataArray[indexPath.row];
        cell.titleLabel.text = faultInfo.faulttype;
    }
    else if (_boxType == SpecialSeasonView)
    {
        BXTSpecialOrderInfo *orderType = _dataArray[indexPath.row];
        cell.titleLabel.text = orderType.param_value;
    }
    else if (_boxType == Other)
    {
        cell.titleLabel.text = _dataArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //更改标记数组
    [markArray removeAllObjects];
    for (NSInteger i = 0; i < _dataArray.count; i++)
    {
        [markArray addObject:@"0"];
    }
    [markArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [tableView reloadData];
    //保存选项
    if (_boxType == DepartmentView)
    {
        BXTDepartmentInfo *departmentInfo = _dataArray[indexPath.row];
        [BXTGlobal setUserProperty:departmentInfo withKey:U_DEPARTMENT];
        self.choosedItem = departmentInfo;
    }
    else if (_boxType == PositionView)
    {
        BXTPostionInfo *positionInfo = _dataArray[indexPath.row];
        [BXTGlobal setUserProperty:positionInfo withKey:U_POSITION];
        self.choosedItem = positionInfo;
    }
    else if (_boxType == FloorInfoView)
    {
        BXTFloorInfo *floorInfo = _dataArray[indexPath.row];
        [BXTGlobal setUserProperty:floorInfo withKey:U_FLOOOR];
        self.choosedItem = floorInfo;
    }
    else if (_boxType == AreaInfoView)
    {
        BXTAreaInfo *areaInfo = _dataArray[indexPath.row];
        [BXTGlobal setUserProperty:areaInfo withKey:U_AREA];
        self.choosedItem = areaInfo;
    }
    else if (_boxType == ShopInfoView)
    {
        if ([_dataArray[indexPath.row] isKindOfClass:[NSString class]])
        {
            self.choosedItem = _dataArray[indexPath.row];
        }
        else
        {
            BXTShopInfo *shopInfo = _dataArray[indexPath.row];
            [BXTGlobal setUserProperty:shopInfo withKey:U_SHOP];
            self.choosedItem = shopInfo;
        }
    }
    else if (_boxType == GroupingView)
    {
        BXTGroupingInfo *groupInfo = _dataArray[indexPath.row];
        self.choosedItem = groupInfo;
    }
    else if (_boxType == SpecialOrderView)
    {
        NSDictionary *dic = _dataArray[indexPath.row];
        self.choosedItem = dic;
    }
    else if (_boxType == CheckProjectsView)
    {
        BXTDeviceMaintenceInfo *maintence = _dataArray[indexPath.row];
        self.choosedItem = maintence;
    }
    else if (_boxType == OrderDeviceStateView)
    {
        BXTDeviceStateInfo *stateInfo = _dataArray[indexPath.row];
        self.choosedItem = stateInfo;
    }
    else if (_boxType == FaultTypeView)
    {
        BXTFaultInfo *faultInfo = _dataArray[indexPath.row];
        self.choosedItem = faultInfo;
    }
    else if (_boxType == SpecialSeasonView)
    {
        BXTSpecialOrderInfo *orderType = _dataArray[indexPath.row];
        self.choosedItem = orderType;
    }
    else if (_boxType == Other)
    {
        self.choosedItem = _dataArray[indexPath.row];
    }
}

- (void)mark
{
    NSInteger index = 0;
    if (_boxType == DepartmentView)
    {
        BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
        if (departmentInfo)
        {
            NSArray *arrResult = [_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.dep_id = %@",departmentInfo.dep_id]];
            if (arrResult.count)
            {
                BXTDepartmentInfo *departmentInfo = arrResult[0];
                index = [_dataArray indexOfObject:departmentInfo];
                [self replaceMarkObj:index];
            }
        }
    }
    else if (_boxType == PositionView)
    {
        BXTPostionInfo *postionInfo = [BXTGlobal getUserProperty:U_POSITION];
        if (postionInfo)
        {
            NSArray *arrResult = [_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.role_id = %@",postionInfo.role_id]];
            if (arrResult.count)
            {
                BXTPostionInfo *positionInfo = arrResult[0];
                index = [_dataArray indexOfObject:positionInfo];
                [self replaceMarkObj:index];
            }
        }
    }
    else if (_boxType == FloorInfoView)
    {
        BXTFloorInfo *floorInfo = [BXTGlobal getUserProperty:U_FLOOOR];
        if (floorInfo)
        {
            NSArray *arrResult = [_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.area_id = %@",floorInfo.area_id]];
            if (arrResult.count)
            {
                BXTFloorInfo *floorInfo = arrResult[0];
                index = [_dataArray indexOfObject:floorInfo];
                [self replaceMarkObj:index];
            }
        }
    }
    else if (_boxType == AreaInfoView)
    {
        BXTAreaInfo *areaInfo = [BXTGlobal getUserProperty:U_AREA];
        if (areaInfo)
        {
            NSArray *arrResult = [_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.place_id = %@",areaInfo.place_id]];
            if (arrResult.count)
            {
                BXTAreaInfo *areaInfo = arrResult[0];
                index = [_dataArray indexOfObject:areaInfo];
                [self replaceMarkObj:index];
            }
        }
    }
    else if (_boxType == ShopInfoView)
    {
        id shopInfo = [BXTGlobal getUserProperty:U_SHOP];
        if (shopInfo)
        {
            if ([shopInfo isKindOfClass:[BXTShopInfo class]])
            {
                BXTShopInfo *tempShop = (BXTShopInfo *)shopInfo;
                NSMutableArray *tempArray = [NSMutableArray array];
                for (id shop in _dataArray)
                {
                    if ([shop isMemberOfClass:[BXTShopInfo class]])
                    {
                        [tempArray addObject:shop];
                    }
                }
                NSArray *arrResult = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.stores_id = %@",tempShop.stores_id]];
                if (arrResult.count)
                {
                    BXTShopInfo *shopInfo = arrResult[0];
                    index = [_dataArray indexOfObject:shopInfo];
                    [self replaceMarkObj:index];
                }
            }
        }
    }
    else if (_boxType == GroupingView)
    {
        BXTGroupingInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
        if (groupInfo)
        {
            NSArray *arrResult = [_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.group_id = %@",groupInfo.group_id]];
            if (arrResult.count)
            {
                BXTGroupingInfo *group_info = arrResult[0];
                index = [_dataArray indexOfObject:group_info];
                [self replaceMarkObj:index];
            }
        }
    }
}

- (void)replaceMarkObj:(NSInteger)index
{
    if (index < markArray.count)
    {
        [markArray replaceObjectAtIndex:index withObject:@"1"];
    }
}

@end
