//
//  BXTSearchPlaceViewController.m
//  YouFeel
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTSearchPlaceViewController.h"
#import "ANKeyValueTable.h"
#import "BXTPlace.h"
#import "BXTPlaceTableViewCell.h"

#define YGREENCOLOR colorWithHexString(@"3cafff")
#define YBLACKCOLOR [UIColor blackColor]
#define YDOWNIMAGE  [UIImage imageNamed:@"wo_down_arrow"]
#define YUPIMAGE    [UIImage imageNamed:@"wo_up_arrow"]

@interface BXTSearchPlaceViewController ()

//资源数据
@property (nonatomic, strong) NSArray *dataSource;
//变动的数据
@property (nonatomic, strong) NSMutableArray *mutableArray;
//标记数组
@property (nonatomic, strong) NSMutableArray *marksArray;

@end

@implementation BXTSearchPlaceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维修位置" andRightTitle:nil andRightImage:nil];
    _commitBtn.layer.cornerRadius = 4.f;
    [_currentTable registerNib:[UINib nibWithNibName:@"BXTPlaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"RowCell"];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    self.mutableArray = mutableArray;
    NSMutableArray *markArray = [[NSMutableArray alloc] init];
    self.marksArray = markArray;

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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;
    }
    return 6.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
        return bv;
    }
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6.f)];
    return bv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 9)
    {
        return 12.f;
    }
    return 6.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 9)
    {
        UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12.f)];
        return bv;
    }
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6.f)];
    return bv;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *tempArray = _mutableArray[section];
    return tempArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RowCell" forIndexPath:indexPath];
    
    NSMutableArray *tempArray = _mutableArray[indexPath.section];
    BXTPlace *placeInfo = tempArray[indexPath.row];
    cell.name_left.constant = [placeInfo.level integerValue] * 15.f;
    [cell.nameLabel layoutIfNeeded];
    cell.nameLabel.text = placeInfo.place;
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
