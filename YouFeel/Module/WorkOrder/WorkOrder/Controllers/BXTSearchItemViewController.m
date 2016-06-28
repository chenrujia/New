//
//  BXTSearchItemViewController.m
//  YouFeel
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTSearchItemViewController.h"
#import "ANKeyValueTable.h"
#import "BXTPlaceTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface BXTSearchItemViewController ()

//资源数据
@property (nonatomic, strong) NSArray             *dataSource;
@property (nonatomic, strong) BXTSelectItemView   *chooseItemView;

@end

@implementation BXTSearchItemViewController

- (void)userChoosePlace:(NSArray *)array isProgress:(BOOL)progress type:(SearchVCType)type block:(ChooseItem)itemBlock
{
    self.dataSource = array;
    self.isProgress = progress;
    self.searchType = type;
    self.selectItemBlock = itemBlock;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.searchType == PlaceSearchType)
    {
        [self navigationSetting:@"位置" andRightTitle:nil andRightImage:nil];
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
    self.commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.commitBtn.layer.cornerRadius = 4.f;
    
    CGRect viewRect = CGRectMake(0, KNAVIVIEWHEIGHT + 44.f + 50.f, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 44.f - 50.f - 68.f);
    CGRect tableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 44.f - 50.f - 68.f);
    self.chooseItemView = [[BXTSelectItemView alloc] initWithFrame:viewRect tableViewFrame:tableRect datasource:self.dataSource isProgress:self.isProgress type:self.searchType block:nil];
    self.chooseItemView.searchBarView = self.searchBarView;
    [self.view addSubview:self.chooseItemView];
}

- (void)alertViewContent:(NSString *)content
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:content message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertCtr addAction:cancelAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:content
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark 提交按钮
- (IBAction)commitClick:(id)sender
{
    if (self.chooseItemView.isOpen)
    {
        if (self.chooseItemView.mutableArray.count == 0)
        {
            return;
        }
        if (!self.chooseItemView.manualClassifyInfo && !self.chooseItemView.autoClassifyInfo && self.searchBarView.text.length == 0)
        {
            [self alertViewContent:@"请选择或输入所需信息"];
            return;
        }
        NSString *prefixName = @"";
        NSMutableArray *markArray = self.chooseItemView.marksArray[self.chooseItemView.lastIndexPath.section];
        NSMutableArray *tempArray = self.chooseItemView.mutableArray[self.chooseItemView.lastIndexPath.section];
        
        for (NSInteger i = 0; i < markArray.count; i++)
        {
            NSString *markStr = markArray[i];
            if ([markStr integerValue] == 1)
            {
                BXTBaseClassifyInfo *classifyInfo = tempArray[i];
                prefixName = [NSString stringWithFormat:@"%@%@",prefixName,classifyInfo.name];
            }
        }
        
        if (self.searchType == FaultSearchType && [self.chooseItemView.manualClassifyInfo.level integerValue] == 1)
        {
            [self alertViewContent:@"请选择具体的故障类型"];
            return;
        }
        self.selectItemBlock(self.chooseItemView.manualClassifyInfo,prefixName);
    }
    else
    {
        if (self.chooseItemView.searchTitlesArray.count > 0 && self.chooseItemView.autoClassifyInfo)
        {
            self.selectItemBlock(self.chooseItemView.autoClassifyInfo,self.chooseItemView.searchTitlesArray[self.chooseItemView.lastIndex]);
        }
        else
        {
            if (self.isProgress)
            {
                [self alertViewContent:@"请确定具体位置"];
                return;
            }
            if (self.searchBarView.text.length > 0)
            {
                self.selectItemBlock(nil,self.searchBarView.text);
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
    self.chooseItemView.isOpen = swt.isOn;
    if (self.chooseItemView.isOpen)
    {
        self.searchBarView.text = @"";
    }
    [self.chooseItemView.currentTable reloadData];
}

#pragma mark -
#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.autoSwitch.on = NO;
    self.chooseItemView.isOpen = NO;
    [self.chooseItemView.currentTable reloadData];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.chooseItemView.resultsArray removeAllObjects];
    [self.chooseItemView.searchTitlesArray removeAllObjects];
    [self.chooseItemView.resultMarksArray removeAllObjects];
    NSMutableArray *searchArray = [self.chooseItemView filterItemsWithData:self.dataSource searchString:searchText lastLevelTitle:@""];
    [self.chooseItemView.resultsArray addObjectsFromArray:searchArray];
    
    for (NSInteger i = 0; i < self.chooseItemView.resultsArray.count; i++)
    {
        [self.chooseItemView.resultMarksArray addObject:@"0"];
    }
    
    [self.chooseItemView.currentTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
