//
//  BXTMailListViewController.m
//  YouFeel
//
//  Created by Jason on 15/12/24.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTMailListViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTMailListCell.h"
#import "BXTPersonFromViewController.h"

@interface BXTMailListViewController () <UITableViewDataSource,  UITableViewDelegate, UISearchBarDelegate>
{
    UIImageView *arrow;
    
}

@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableView *tableView_search;
@property(nonatomic, strong) UIView *bgView;

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic, strong) NSArray *headerTitleArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) NSMutableArray *isShowArray;

@end

@implementation BXTMailListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"通讯录" andRightTitle:nil andRightImage:nil];
    
    self.titleArray = [[NSMutableArray alloc] initWithArray:@[@[],  @[@"设备型号", @"设备分类", @"设备品牌", @"安装位置", @"服务区域", @"接管日期", @"启用日期"], @[@"品牌", @"厂家", @"地址", @"联系人", @"联系电话"], @[@"设备参数"], @[@"负责人"]]];
    
    [self createUI];
}

#pragma mark -
#pragma mark - 创建UI
- (void)createUI
{
    self.dataArray = [[NSMutableArray alloc] init];
    self.headerTitleArray = @[@"", @"部门一", @"部门二", @"部门三", @"部门四"];
    self.detailArray = [[NSMutableArray alloc] init];
    self.isShowArray = [[NSMutableArray alloc] init];
    for (int i=0; i<=self.headerTitleArray.count-1; i++)
    {
        [self.isShowArray addObject:@"0"];
    }
    [self.isShowArray replaceObjectAtIndex:1 withObject:@"1"];
    
    // UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 55)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    [self.view addSubview:self.searchBar];
    
    // UITableView - tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.searchBar.frame) - KTABBARHEIGHT - 6) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // UITableView - headerView - section 0
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 50)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    self.bgView.layer.borderWidth = 0.5;
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headerTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        NSArray *numArray = self.titleArray[section];
        return numArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BXTMailListCell *cell = [BXTMailListCell cellWithTableView:tableView];
//    
////    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    [[cell.messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"发短信 - message");
//    }];
//    [[cell.phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"打电话 - call");
//    }];
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"headerTitle";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // TODO: -----------------  调试  -----------------
    if (section == 0)
    {
        UIButton *firstGroup = [self createShowButton:CGRectMake(15, 10, 80, 30) title:@"组织机构"];
        [[firstGroup rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            self.titleArray = [[NSMutableArray alloc] initWithArray:@[@[],  @[@"设备型号", @"设备分类", @"设备品牌", @"安装位置", @"服务区域", @"接管日期", @"启用日期"], @[@"品牌", @"厂家", @"地址", @"联系人", @"联系电话"], @[@"设备参数"], @[@"负责人"]]];
            self.headerTitleArray = @[@"", @"部门一", @"部门二", @"部门三", @"部门四"];
            [self.tableView reloadData];
        }];
        
        return self.bgView;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = section;
    btn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    btn.layer.borderWidth = 0.5;
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 改变组的显示状态
        if ([self.isShowArray[btn.tag] isEqualToString:@"1"]) {
            [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"0"];
        } else  {
            [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"1"];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
        
        // TODO: -----------------  调试2  -----------------
        if (section == 3) {
            self.titleArray = [[NSMutableArray alloc] initWithArray:@[@[],  @[@"设备型号", @"设备分类", @"设备品牌", @"安装位置", @"服务区域", @"接管日期", @"启用日期"], @[@"品牌", @"厂家", @"地址", @"联系人", @"联系电话"]]];
            self.headerTitleArray = @[@"", @"部门一", @"部门二"];
            
            UIButton *newGroup = [self createShowButton:CGRectMake(105, 10, 80, 30) title:@"部门三"];
            
            [self.tableView reloadData];
        }
    }];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 14.5, 100, 21)];
    title.text = self.headerTitleArray[section];
    title.textColor = colorWithHexString(@"#666666");
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:15];
    [btn addSubview:title];
    
    arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 21, 15, 8)];
    arrow.image = [UIImage imageNamed:@"down_arrow_gray"];
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        arrow.image = [UIImage imageNamed:@"up_arrow_gray"];
    }
    [btn addSubview:arrow];
    
    
    return btn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击事件");

    BXTPersonFromViewController *pivc = [[BXTPersonFromViewController alloc] init];
    [self.navigationController pushViewController:pivc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchArray removeAllObjects];
    [self.tableView_search reloadData];
    NSLog(@"should begin");
    
    //    self.tableView.hidden = YES;
    //    self.tableView_search.hidden = NO;
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    NSLog(@"did begin");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"did end");
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

#pragma mark -
#pragma mark - 自定义方法
- (UIButton *)createShowButton:(CGRect)frame title:(NSString *)title
{
    UIButton *groupBtn = [[UIButton alloc] initWithFrame:frame];
    [groupBtn setTitle:title forState:UIControlStateNormal];
    groupBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [groupBtn setTitleColor:colorWithHexString(@"#999999") forState:UIControlStateNormal];
    groupBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    groupBtn.layer.borderWidth = 0.5;
    groupBtn.layer.cornerRadius = 15;
    [self.bgView addSubview:groupBtn];
    
    return groupBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
