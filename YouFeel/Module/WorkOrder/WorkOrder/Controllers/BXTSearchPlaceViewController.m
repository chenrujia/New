//
//  BXTSearchPlaceViewController.m
//  YouFeel
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTSearchPlaceViewController.h"
#import "ANKeyValueTable.h"
#import "BXTPlaceTableViewCell.h"

#define YGREENCOLOR colorWithHexString(@"3cafff")
#define YBLACKCOLOR [UIColor blackColor]
#define YDOWNIMAGE  [UIImage imageNamed:@"wo_down_arrow"]
#define YUPIMAGE    [UIImage imageNamed:@"wo_up_arrow"]

@interface BXTSearchPlaceViewController ()

@property (nonatomic, assign) BOOL isOpen;
//资源数据
@property (nonatomic, strong) NSArray *dataSource;
//变动的数据
@property (nonatomic, strong) NSMutableArray *mutableArray;
//标记数组
@property (nonatomic, strong) NSMutableArray *marksArray;
//当前选择的区
@property (nonatomic, assign) NSInteger lastSection;
//当前选择的行
@property (nonatomic, assign) NSInteger lastIndex;
//筛选结果数组
@property (nonatomic, strong) NSMutableArray *resultsArray;
//筛选结果标记数组
@property (nonatomic, strong) NSMutableArray *resultMarksArray;
//手动选择的结果
@property (nonatomic, strong) BXTPlace *manualPlace;
//自动选择的结果
@property (nonatomic, strong) BXTPlace *autoPlace;

@end

@implementation BXTSearchPlaceViewController

- (void)userChoosePlaceInfo:(ChoosePlace)place
{
    self.selectPlace = place;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维修位置" andRightTitle:nil andRightImage:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isOpen = YES;
    _commitBtn.layer.cornerRadius = 4.f;
    [_currentTable registerNib:[UINib nibWithNibName:@"BXTPlaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"RowCell"];
    _currentTable.rowHeight = 50.f;
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    self.mutableArray = mutableArray;
    NSMutableArray *markArray = [[NSMutableArray alloc] init];
    self.marksArray = markArray;
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    self.resultsArray = resultArray;
    NSMutableArray *resultMarkArray = [[NSMutableArray alloc] init];
    self.resultMarksArray = resultMarkArray;

    NSArray *array = [[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE];
    for (BXTPlace *place in array)
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:place, nil];
        [_mutableArray addObject:tempArray];
        NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
        [_marksArray addObject:emptyArray];
    }
    self.dataSource = array;
    [_currentTable reloadData];
}

- (IBAction)commitClick:(id)sender
{
    if (_isOpen)
    {
        _selectPlace(_manualPlace);
    }
    else
    {
        _selectPlace(_autoPlace);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchValueChanged:(id)sender
{
    UISwitch *swt = sender;
    _isOpen = swt.isOn;
    [_currentTable reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_resultsArray removeAllObjects];
    [_resultMarksArray removeAllObjects];
    NSMutableArray *searchArray = [self filterItemsWithData:_dataSource searchString:searchText];
    [_resultsArray addObjectsFromArray:searchArray];
    for (NSInteger i = 0; i < _resultsArray.count; i++)
    {
        [_resultMarksArray addObject:@"0"];
    }
    [_currentTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12.f)];
    return bv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 9)
    {
        return 12.f;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 9)
    {
        UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12.f)];
        return bv;
    }
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
    return bv;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isOpen)
    {
        return _dataSource.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isOpen)
    {
        NSMutableArray *tempArray = _mutableArray[section];
        return tempArray.count;
    }
    return _resultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RowCell" forIndexPath:indexPath];
    BXTPlace *placeInfo;
    if (_isOpen)
    {
        NSMutableArray *tempArray = _mutableArray[indexPath.section];
        placeInfo = tempArray[indexPath.row];
        cell.name_left.constant = [placeInfo.level integerValue] * 15.f;
        //是否显示箭头
        cell.arrowImage.hidden = placeInfo.lists.count == 0 ? YES : NO;
        NSMutableArray *markArray = _marksArray[indexPath.section];
        if (markArray.count > indexPath.row)
        {
            //颜色变换
            cell.nameLabel.textColor = [markArray[indexPath.row] integerValue] ? YGREENCOLOR : YBLACKCOLOR;
            //上下箭头变换
            cell.arrowImage.image = [markArray[indexPath.row] integerValue] ? YUPIMAGE : YDOWNIMAGE;
        }
        else
        {
            cell.nameLabel.textColor = YBLACKCOLOR;
        }
    }
    else
    {
        placeInfo = _resultsArray[indexPath.row];
        cell.name_left.constant = 15.f;
        cell.arrowImage.hidden = YES;
        //颜色变换
        cell.nameLabel.textColor = [_resultMarksArray[indexPath.row] integerValue] ? YGREENCOLOR : YBLACKCOLOR;
    }
    [cell.nameLabel layoutIfNeeded];
    cell.nameLabel.text = placeInfo.place;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //搜索结果的标记
    if (!_isOpen)
    {
        if (_lastIndex != indexPath.row)
        {
            [_resultMarksArray replaceObjectAtIndex:_lastIndex withObject:@"0"];
        }
        BXTPlace *placeInfo = _resultsArray[indexPath.row];
        _autoPlace = placeInfo;
        [_resultMarksArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        _lastIndex = indexPath.row;
        [tableView reloadData];
        return;
    }
    
    //如果两次选择的不一样，则收起上次的选择
    if (_lastSection != indexPath.section)
    {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:_lastSection];
        [self refreshTableForRemove:lastIndexPath];
        NSMutableArray *markArray = _marksArray[lastIndexPath.section];
        if (markArray.count > 0)
        {
            [markArray replaceObjectAtIndex:0 withObject:@"0"];
        }
        [_currentTable reloadData];
    }
    _lastSection = indexPath.section;
    
    //改变标记数组的状态值
    NSMutableArray *markArray = _marksArray[indexPath.section];
    if (markArray.count < indexPath.row)
    {
        for (NSInteger i = 0; i < indexPath.row - markArray.count; i++)
        {
            [markArray addObject:@"0"];
        }
        [markArray addObject:@"1"];
        [self refreshTableForAdd:indexPath];
    }
    else if (markArray.count == indexPath.row)
    {
        [markArray addObject:@"1"];
        [self refreshTableForAdd:indexPath];
    }
    else
    {
        if ([markArray[indexPath.row] integerValue])
        {
            [markArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
            [self refreshTableForRemove:indexPath];
        }
        else
        {
            [markArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [self refreshTableForAdd:indexPath];
        }
    }
}

- (void)refreshTableForAdd:(NSIndexPath *)indexPath
{
    //如果placeInfe的lists有数据，则取出相应的数据，添加到tempArray数组里面
    NSMutableArray *tempArray = _mutableArray[indexPath.section];
    BXTPlace *placeInfo = tempArray[indexPath.row];
    self.manualPlace = placeInfo;
    if (placeInfo.lists.count > 0)
    {
        [tempArray addObjectsFromArray:placeInfo.lists];
    }
    //不管有没有下级都要刷新
    [_currentTable reloadData];
}

- (void)refreshTableForRemove:(NSIndexPath *)indexPath
{
    //如果placeInfe的lists有数据，则取出相应的数据，添加到tempArray数组里面
    NSMutableArray *tempArray = _mutableArray[indexPath.section];
    BXTPlace *placeInfo = tempArray[indexPath.row];
    if (placeInfo.lists.count > 0)
    {
        //改变标记数组的状态值
        NSMutableArray *markArray = _marksArray[indexPath.section];
        NSMutableArray *items = [self searchItemsWithPlace:placeInfo theIndexPath:indexPath];
        for (BXTPlace *tempPlace in items)
        {
            NSInteger index = [tempArray indexOfObject:tempPlace];
            if (markArray.count > index)
            {
                [markArray replaceObjectAtIndex:index withObject:@"0"];
            }
        }
        [tempArray removeObjectsInArray:items];
    }
    [_currentTable reloadData];
}

- (NSMutableArray *)searchItemsWithPlace:(BXTPlace *)placeInfo theIndexPath:(NSIndexPath *)indexPath
{
    //存需要删除的数据
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = _mutableArray[indexPath.section];
    NSMutableArray *markArray = _marksArray[indexPath.section];
    for (BXTPlace *place in placeInfo.lists)
    {
        [mutableArray addObject:place];
        NSInteger index = [tempArray indexOfObject:place];
        //判断此项是否展开
        if (markArray.count > index && [markArray[index] integerValue] && place.lists.count > 0)
        {
            NSMutableArray *array = [self searchItemsWithPlace:place theIndexPath:indexPath];
            [mutableArray addObjectsFromArray:array];
        }
    }
    return mutableArray;
}

- (NSMutableArray *)filterItemsWithData:(NSArray *)array searchString:(NSString *)searchStr
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (BXTPlace *placeInfo in array)
    {
        if ([placeInfo.place containsString:searchStr])
        {
            [mutableArray addObject:placeInfo];
        }
        if (placeInfo.lists.count > 0)
        {
            NSMutableArray *tempArray = [self filterItemsWithData:placeInfo.lists searchString:searchStr];
            [mutableArray addObjectsFromArray:tempArray];
        }
    }

    return mutableArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
