//
//  BXTSelectBoxView.m
//  BXT
//
//  Created by Jason on 15/8/25.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTSelectBoxView.h"
#import "KZAsserts.h"
#import "BXTHeaderFile.h"
#import "BXTSettingTableViewCell.h"
#import "BXTDepartmentInfo.h"
#import "BXTFloorInfo.h"
#import "BXTAreaInfo.h"
#import "BXTShopInfo.h"
#import "BXTFaultTypeInfo.h"
#import "BXTGroupingInfo.h"

@implementation BXTSelectBoxView

- (instancetype)initWithFrame:(CGRect)rect boxTitle:(NSString *)title boxSelectedViewType:(BoxSelectedType)type listDataSource:(NSArray *)array markID:(NSString *)mark actionDelegate:(id <BXTBoxSelectedTitleDelegate>)delegate
{
    self = [super initWithFrame:rect];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
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
        
        title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200.f, 20.f)];
        title_label.center = CGPointMake(SCREEN_WIDTH/2.f, 20.f);
        title_label.textAlignment = NSTextAlignmentCenter;
        title_label.textColor = colorWithHexString(@"000000");
        title_label.font = [UIFont boldSystemFontOfSize:16.f];
        title_label.text = [NSString stringWithFormat:@"选择%@",title];
        [self addSubview:title_label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 39.f, SCREEN_WIDTH - 30.f, 1.f)];
        lineView.backgroundColor = colorWithHexString(@"e2e6e8");
        [self addSubview:lineView];
        
        currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), SCREEN_WIDTH, rect.size.height - 40.f) style:UITableViewStylePlain];
        currentTableView.backgroundColor = [UIColor whiteColor];
        currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [currentTableView registerClass:[BXTSettingTableViewCell class] forCellReuseIdentifier:@"BoxCell"];
        currentTableView.delegate = self;
        currentTableView.dataSource = self;
        currentTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:currentTableView];
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
    BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoxCell"];
    if (!cell)
    {
        cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoxCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
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
        cell.titleLabel.frame = CGRectMake(15., 10., 160.f, 30);
        cell.titleLabel.text = departmentInfo.department;
    }
    else if (_boxType == PositionView)
    {
        BXTPostionInfo *positionInfo = _dataArray[indexPath.row];
        cell.titleLabel.frame = CGRectMake(15., 10., 160.f, 30);
        cell.titleLabel.text = positionInfo.role;
    }
    else if (_boxType == FloorInfoView)
    {
        BXTFloorInfo *floorInfo = _dataArray[indexPath.row];
        cell.titleLabel.frame = CGRectMake(15., 10., 160.f, 30);
        cell.titleLabel.text = floorInfo.area_name;
    }
    else if (_boxType == AreaInfoView)
    {
        BXTAreaInfo *areaInfo = _dataArray[indexPath.row];
        cell.titleLabel.frame = CGRectMake(15., 10., 160.f, 30);
        cell.titleLabel.text = areaInfo.place_name;
    }
    else if (_boxType == ShopInfoView)
    {
        cell.titleLabel.frame = CGRectMake(15., 10., 160.f, 30);
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
    else if (_boxType == FaultInfoView)
    {
        BXTFaultTypeInfo *faultInfo = _dataArray[indexPath.row];
        cell.titleLabel.frame = CGRectMake(15., 10., 160.f, 30);
        cell.titleLabel.text = faultInfo.faulttype;
    }
    else if (_boxType == GroupingView)
    {
        BXTGroupingInfo *groupInfo = _dataArray[indexPath.row];
        cell.titleLabel.frame = CGRectMake(15., 10., 160.f, 30);
        cell.titleLabel.text = groupInfo.subgroup;
    }
    else if (_boxType == SpecialOrderView)
    {
        NSDictionary *dic = _dataArray[indexPath.row];
        cell.titleLabel.frame = CGRectMake(15., 10., SCREEN_WIDTH-30, 30);
        cell.titleLabel.text = [dic objectForKey:@"collection"];
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    else if (_boxType == Other)
    {
        cell.titleLabel.frame = CGRectMake(15., 10., SCREEN_WIDTH-30, 30);
        cell.titleLabel.text = _dataArray[indexPath.row];
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
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
        [_delegate boxSelectedObj:departmentInfo.department selectedType:_boxType];
    }
    else if (_boxType == PositionView)
    {
        BXTPostionInfo *positionInfo = _dataArray[indexPath.row];
        [BXTGlobal setUserProperty:positionInfo withKey:U_POSITION];
        [_delegate boxSelectedObj:positionInfo.role selectedType:_boxType];
    }
    else if (_boxType == FloorInfoView)
    {
        BXTFloorInfo *floorInfo = _dataArray[indexPath.row];
        [BXTGlobal setUserProperty:floorInfo withKey:U_FLOOOR];
        [_delegate boxSelectedObj:floorInfo selectedType:_boxType];
    }
    else if (_boxType == AreaInfoView)
    {
        BXTAreaInfo *areaInfo = _dataArray[indexPath.row];
        [BXTGlobal setUserProperty:areaInfo withKey:U_AREA];
        [_delegate boxSelectedObj:areaInfo selectedType:_boxType];
    }
    else if (_boxType == ShopInfoView)
    {
        if ([_dataArray[indexPath.row] isKindOfClass:[NSString class]])
        {
            [_delegate boxSelectedObj:_dataArray[indexPath.row] selectedType:_boxType];
        }
        else
        {
            BXTShopInfo *shopInfo = _dataArray[indexPath.row];
            [BXTGlobal setUserProperty:shopInfo withKey:U_SHOP];
            [_delegate boxSelectedObj:shopInfo selectedType:_boxType];
        }
    }
    else if (_boxType == FaultInfoView)
    {
        BXTFaultTypeInfo *faultInfo = _dataArray[indexPath.row];
        [_delegate boxSelectedObj:faultInfo selectedType:_boxType];
    }
    else if (_boxType == GroupingView)
    {
        BXTGroupingInfo *groupInfo = _dataArray[indexPath.row];
        [_delegate boxSelectedObj:groupInfo selectedType:_boxType];
    }
    else if (_boxType == SpecialOrderView)
    {
        NSDictionary *dic = _dataArray[indexPath.row];
        [_delegate boxSelectedObj:dic selectedType:_boxType];
    }
    else if (_boxType == Other)
    {
        [_delegate boxSelectedObj:_dataArray[indexPath.row] selectedType:_boxType];
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
    else if (_boxType == FaultInfoView)
    {
        if (markID)
        {
            NSArray *arrResult = [_dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.fau_id = %@",markID]];
            if (arrResult.count)
            {
                BXTFaultTypeInfo *faultInfo = arrResult[0];
                index = [_dataArray indexOfObject:faultInfo];
                [self replaceMarkObj:index];
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
