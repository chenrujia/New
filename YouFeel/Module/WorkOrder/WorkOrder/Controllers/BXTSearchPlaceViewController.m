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
#import "UITableView+FDTemplateLayoutCell.h"

#define YGREENCOLOR colorWithHexString(@"3cafff")
#define YBLACKCOLOR [UIColor blackColor]
#define YDOWNIMAGE  [UIImage imageNamed:@"wo_down_arrow"]
#define YUPIMAGE    [UIImage imageNamed:@"wo_up_arrow"]

@interface BXTSearchPlaceViewController ()

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

@end

@implementation BXTSearchPlaceViewController

- (void)userChoosePlace:(NSArray *)array type:(SearchVCType)type block:(ChoosePlace)place
{
    self.dataSource = array;
    self.searchType = type;
    self.selectPlace = place;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.searchType == PlaceSearchType)
    {
        [self navigationSetting:@"维修位置" andRightTitle:nil andRightImage:nil];
        self.searchBarView.placeholder = @"查找或输入位置";
    }
    else if (self.searchType == FaultSearchType)
    {
        [self navigationSetting:@"故障类型" andRightTitle:nil andRightImage:nil];
        self.searchBarView.placeholder = @"查找或输入故障类型";
    }
    else if (self.searchType == DepartmentSearchType)
    {
        [self navigationSetting:@"部门" andRightTitle:nil andRightImage:nil];
        self.searchBarView.placeholder = @"查找或输入部门";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.isOpen = YES;
    self.commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.commitBtn.layer.cornerRadius = 4.f;
    [self.currentTable registerNib:[UINib nibWithNibName:@"BXTPlaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"RowCell"];
    if (IS_IOS_8)
    {
        [self.currentTable setEstimatedRowHeight:50.f];
    }
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    self.mutableArray = mutableArray;
    NSMutableArray *markArray = [[NSMutableArray alloc] init];
    self.marksArray = markArray;
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    self.resultsArray = resultArray;
    NSMutableArray *resultMarkArray = [[NSMutableArray alloc] init];
    self.resultMarksArray = resultMarkArray;
    NSMutableArray *titlesArray = [[NSMutableArray alloc] init];
    self.searchTitlesArray = titlesArray;
    
    for (NSInteger i = 0; i < self.dataSource.count; i++)
    {
        BXTBaseClassifyInfo *classifyInfo = self.dataSource[i];
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:classifyInfo, nil];
        [self.mutableArray addObject:tempArray];
        if (self.searchType == FaultSearchType && [classifyInfo.itemID isEqualToString:self.faultTypeID])
        {
            NSMutableArray *emptyArray = [[NSMutableArray alloc] initWithObjects:@"1", nil];
            [self.marksArray addObject:emptyArray];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            self.lastIndexPath = indexPath;
            [self refreshTableForAdd:indexPath refreshNow:NO];
        }
        else
        {
            NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
            [self.marksArray addObject:emptyArray];
        }
    }
    
    [self.currentTable reloadData];
}

#pragma mark -
#pragma mark 提交按钮
- (IBAction)commitClick:(id)sender
{
    if (self.isOpen)
    {
        if (self.mutableArray.count == 0)
        {
            return;
        }
        NSString *prefixName = @"";
        NSMutableArray *markArray = self.marksArray[self.lastIndexPath.section];
        NSMutableArray *tempArray = self.mutableArray[self.lastIndexPath.section];
        
        for (NSInteger i = 0; i < markArray.count; i++)
        {
            NSString *markStr = markArray[i];
            if ([markStr integerValue] == 1)
            {
                BXTBaseClassifyInfo *classifyInfo = tempArray[i];
                prefixName = [NSString stringWithFormat:@"%@%@",prefixName,classifyInfo.name];
            }
        }
        
        if (self.searchType == FaultSearchType && [self.manualClassifyInfo.level integerValue] == 1)
        {
            if (IS_IOS_8)
            {
                UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"请选择具体的故障类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertCtr addAction:cancelAction];
                [self presentViewController:alertCtr animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择具体的故障类型"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            return;
        }
        self.selectPlace(self.manualClassifyInfo,prefixName);
    }
    else
    {
        if (self.searchTitlesArray.count > 0 && self.autoClassifyInfo)
        {
            self.selectPlace(self.autoClassifyInfo,self.searchTitlesArray[self.lastIndex]);
        }
        else
        {
            if (self.searchBarView.text.length > 0)
            {
                self.selectPlace(nil,self.searchBarView.text);
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 开关
- (IBAction)switchValueChanged:(id)sender
{
    UISwitch *swt = sender;
    self.isOpen = swt.isOn;
    if (self.isOpen)
    {
        self.searchBarView.text = @"";
    }
    [self.currentTable reloadData];
}

#pragma mark -
#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.autoSwitch.on = NO;
    self.isOpen = NO;
    [self.currentTable reloadData];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.resultsArray removeAllObjects];
    [self.searchTitlesArray removeAllObjects];
    [self.resultMarksArray removeAllObjects];
    NSMutableArray *searchArray = [self filterItemsWithData:self.dataSource searchString:searchText lastLevelTitle:@""];
    [self.resultsArray addObjectsFromArray:searchArray];
    
    for (NSInteger i = 0; i < self.resultsArray.count; i++)
    {
        [self.resultMarksArray addObject:@"0"];
    }
    
    [self.currentTable reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource
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
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
    return bv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = nil;
    if (self.isOpen)
    {
        NSMutableArray *tempArray = self.mutableArray[indexPath.section];
        BXTBaseClassifyInfo *classifyInfo = tempArray[indexPath.row];
        content = classifyInfo.name;
    }
    else
    {
        content = self.searchTitlesArray[indexPath.row];
    }
    CGSize size = MB_MULTILINE_TEXTSIZE(content, [UIFont systemFontOfSize:17.f], CGSizeMake(SCREEN_WIDTH - 75.f, 500.f), NSLineBreakByWordWrapping);
    return size.height + 30.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isOpen)
    {
        return self.dataSource.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen)
    {
        NSMutableArray *tempArray = self.mutableArray[section];
        return tempArray.count;
    }
    return self.resultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTPlaceTableViewCell *cell = (BXTPlaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RowCell" forIndexPath:indexPath];
    NSString *content = nil;
    if (self.isOpen)
    {
        NSMutableArray *tempArray = self.mutableArray[indexPath.section];
        BXTBaseClassifyInfo *classifyInfo = tempArray[indexPath.row];
        content = classifyInfo.name;
        cell.name_left.constant = [classifyInfo.level integerValue] * 15.f;
        //是否显示箭头
        cell.arrowImage.hidden = classifyInfo.lists.count == 0 ? YES : NO;
        
        NSMutableArray *markArray = self.marksArray[indexPath.section];
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
            cell.arrowImage.image = YDOWNIMAGE;
        }
    }
    else
    {
        content = self.searchTitlesArray[indexPath.row];
        cell.name_left.constant = 15.f;
        cell.arrowImage.hidden = YES;
        //颜色变换
        cell.nameLabel.textColor = [self.resultMarksArray[indexPath.row] integerValue] ? YGREENCOLOR : YBLACKCOLOR;
    }
    cell.nameLabel.text = content;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //搜索结果的标记
    if (!self.isOpen)
    {
        if (self.lastIndex != indexPath.row)
        {
            [self.resultMarksArray replaceObjectAtIndex:self.lastIndex withObject:@"0"];
        }
        BXTBaseClassifyInfo *classifyInfo = self.resultsArray[indexPath.row];
        self.autoClassifyInfo = classifyInfo;
        [self.resultMarksArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        self.lastIndex = indexPath.row;
        [tableView reloadData];
        return;
    }
    
    //如果两次选择的section不一样，则收起上次的选择
    if (self.lastIndexPath.section != indexPath.section)
    {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.lastIndexPath.section];
        [self refreshTableForRemove:lastIndexPath];
        NSMutableArray *markArray = self.marksArray[lastIndexPath.section];
        [markArray removeAllObjects];
        [tableView reloadData];
    }
    
    //改变标记数组的状态值
    NSMutableArray *markArray = self.marksArray[indexPath.section];
    if (markArray.count < indexPath.row)
    {
        for (NSInteger i = 0; i < indexPath.row - markArray.count; i++)
        {
            [markArray addObject:@"0"];
        }
        [self singleSelectionWithArray:markArray indexPath:indexPath];
        [markArray addObject:@"1"];
        [self refreshTableForAdd:indexPath refreshNow:YES];
    }
    else if (markArray.count == indexPath.row)
    {
        [self singleSelectionWithArray:markArray indexPath:indexPath];
        [markArray addObject:@"1"];
        [self refreshTableForAdd:indexPath refreshNow:YES];
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
            NSInteger count = [self singleSelectionWithArray:markArray indexPath:indexPath];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row - count inSection:indexPath.section];
            //如果两次选择的level一致，则取消上次点击的选中状态。
            NSMutableArray *tempArray = self.mutableArray[self.lastIndexPath.section];
            BXTBaseClassifyInfo *lastClassifyInfo = tempArray[self.lastIndexPath.row];
            if (indexPath.row > self.lastIndexPath.row)
            {
                BXTBaseClassifyInfo *currentClassifyInfo = tempArray[newIndexPath.row];
                if ([lastClassifyInfo.level isEqualToString:currentClassifyInfo.level])
                {
                    [markArray replaceObjectAtIndex:self.lastIndexPath.row withObject:@"0"];
                }
                [markArray replaceObjectAtIndex:newIndexPath.row withObject:@"1"];
                [self refreshTableForAdd:newIndexPath refreshNow:YES];
                self.lastIndexPath = newIndexPath;
                return;
            }
            else
            {
                BXTBaseClassifyInfo *currentClassifyInfo = tempArray[indexPath.row];
                if ([lastClassifyInfo.level isEqualToString:currentClassifyInfo.level])
                {
                    [markArray replaceObjectAtIndex:self.lastIndexPath.row withObject:@"0"];
                }
                [markArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
                [self refreshTableForAdd:indexPath refreshNow:YES];
            }
        }
    }
    
    self.lastIndexPath = indexPath;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBarView resignFirstResponder];
}

#pragma mark -
#pragma mark 自定义方法
- (void)refreshTableForAdd:(NSIndexPath *)indexPath refreshNow:(BOOL)refresh
{
    //如果placeInfe的lists有数据，则取出相应的数据，添加到tempArray数组里面
    NSMutableArray *tempArray = self.mutableArray[indexPath.section];
    BXTBaseClassifyInfo *classifyInfo = tempArray[indexPath.row];
    //改变标记数组的状态值
    NSMutableArray *markArray = self.marksArray[indexPath.section];
    self.manualClassifyInfo = classifyInfo;
    if (classifyInfo.lists.count > 0)
    {
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                               NSMakeRange(indexPath.row + 1,[classifyInfo.lists count])];
        [tempArray insertObjects:classifyInfo.lists atIndexes:indexes];
        NSMutableArray *data = [NSMutableArray array];
        NSInteger i = 0;
        while (i < classifyInfo.lists.count)
        {
            [data addObject:@"0"];
            ++i;
        }
        [markArray insertObjects:data atIndexes:indexes];
    }
    if (refresh)
    {
        //不管有没有下级都要刷新
        [self.currentTable reloadData];
    }
}

- (NSInteger)refreshTableForRemove:(NSIndexPath *)indexPath
{
    //如果placeInfe的lists有数据，则删除里面的数据
    NSMutableArray *tempArray = self.mutableArray[indexPath.section];
    BXTBaseClassifyInfo *classifyInfo = tempArray[indexPath.row];
    NSInteger i = 0;
    if (classifyInfo.lists.count > 0)
    {
        //改变标记数组的状态值
        NSMutableArray *markArray = self.marksArray[indexPath.section];
        NSArray *items = [self searchItemsWithPlace:classifyInfo indexPath:indexPath];
        for (BXTBaseClassifyInfo *tempClassifyInfo in items)
        {
            NSInteger index = [tempArray indexOfObject:tempClassifyInfo];
            if (markArray.count > index)
            {
                i++;
                [markArray removeObjectAtIndex:index];
            }
        }
        [tempArray removeObjectsInArray:items];
    }
    [self.currentTable reloadData];
    return i;
}

//过滤出需要删除的数据数组
- (NSArray *)searchItemsWithPlace:(BXTBaseClassifyInfo *)classifyInfo indexPath:(NSIndexPath *)indexPath
{
    //存放需要删除的数据
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = self.mutableArray[indexPath.section];
    NSMutableArray *markArray = self.marksArray[indexPath.section];
    
    for (BXTBaseClassifyInfo *tempClassifyInfo in classifyInfo.lists)
    {
        [mutableArray addObject:tempClassifyInfo];
        NSInteger index = [tempArray indexOfObject:tempClassifyInfo];
        //判断此项是否展开
        if (markArray.count > index && [markArray[index] integerValue] && tempClassifyInfo.lists.count > 0)
        {
            NSArray *array = [self searchItemsWithPlace:tempClassifyInfo indexPath:indexPath];
            array = [[array reverseObjectEnumerator] allObjects];
            [mutableArray addObjectsFromArray:array];
        }
    }
    mutableArray = (NSMutableArray *)[[mutableArray reverseObjectEnumerator] allObjects];
    
    return mutableArray;
}

//过滤出复合筛选字符串的数据
- (NSMutableArray *)filterItemsWithData:(NSArray *)array searchString:(NSString *)searchStr lastLevelTitle:(NSString *)lastTitle
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (BXTBaseClassifyInfo *classifyInfo in array)
    {
        NSString *title = [NSString stringWithFormat:@"%@%@",lastTitle,classifyInfo.name];
        if ([classifyInfo.name containsString:searchStr])
        {
            [mutableArray addObject:classifyInfo];
            [self.searchTitlesArray addObject:title];
        }
        if (classifyInfo.lists.count > 0)
        {
            NSMutableArray *tempArray = [self filterItemsWithData:classifyInfo.lists searchString:searchStr lastLevelTitle:title];
            [mutableArray addObjectsFromArray:tempArray];
        }
    }
    
    return mutableArray;
}

//当点击item时，要收起此区域下与此item等级一致的菜单 count:筛选出来的要删除的个数
- (NSInteger)singleSelectionWithArray:(NSMutableArray *)markArray indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tempArray = self.mutableArray[indexPath.section];
    BXTBaseClassifyInfo *selectClassifyInfo = tempArray[indexPath.row];
    NSInteger count = 0;
    
    for (NSInteger i = 0; i < tempArray.count; i++)
    {
        BXTBaseClassifyInfo *classifyInfo = tempArray[i];
        if ([classifyInfo.level integerValue] == [selectClassifyInfo.level integerValue])
        {
            if (markArray.count >= i + 1 && [markArray[i] integerValue] && classifyInfo.lists.count > 0)
            {
                count = [self packUpWithArray:markArray index:i];
            }
        }
    }
    
    return count;
}

//收起对应的下级列表
- (NSInteger)packUpWithArray:(NSMutableArray *)markArray index:(NSInteger)index
{
    [markArray replaceObjectAtIndex:index withObject:@"0"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:self.lastIndexPath.section];
    NSInteger count = [self refreshTableForRemove:indexPath];
    return count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
