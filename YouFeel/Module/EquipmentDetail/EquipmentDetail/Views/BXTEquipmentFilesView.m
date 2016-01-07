//
//  BXTEquipmentFilesView.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTEquipmentFilesView.h"
#import "BXTEquipmentFilesCell.h"
#import "BXTMaintenanceDetailViewController.h"
#import "UIView+Nav.h"

@interface BXTEquipmentFilesView () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) DOPDropDownMenu *DDMenu;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation BXTEquipmentFilesView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    self.titleArray = @[@"基本信息", @"厂家信息", @"设备参数", @"设备负责人"];
    self.dataArray = @[@"基本信息", @"厂家信息", @"设备参数", @"设备负责人"];
    
    [self createUI];
}

- (void)createUI
{
    // 设备操作规范
    UIButton *topBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    topBtnView.backgroundColor = [UIColor whiteColor];
    [[topBtnView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"设备操作规范");
    }];
    [self addSubview:topBtnView];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 150, 30)];
    titleView.text = @"设备操作规范";
    titleView.textColor = colorWithHexString(@"#333333");
    titleView.font = [UIFont systemFontOfSize:15];
    [topBtnView addSubview:titleView];
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 15, 9, 15)];
    arrowView.image = [UIImage imageNamed:@"Arrow-right"];
    [topBtnView addSubview:arrowView];
    
    // 添加下拉菜单
    self.DDMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 55) andHeight:44];
    self.DDMenu.delegate = self;
    self.DDMenu.dataSource = self;
    self.DDMenu.layer.borderWidth = 0.5;
    self.DDMenu.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    [self addSubview:self.DDMenu];
    [self.DDMenu selectDefalutIndexPath];
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.DDMenu.frame), SCREEN_WIDTH, self.frame.size.height-CGRectGetMaxY(self.DDMenu.frame)-66) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    // 新建工单
    UIView *downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-66, SCREEN_WIDTH, 66)];
    downBgView.backgroundColor = colorWithHexString(@"#DFE0E1");
    [self addSubview:downBgView];
    
    UIButton *MaintenanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 13, SCREEN_WIDTH-80, 40)];
    MaintenanceBtn.backgroundColor = [UIColor whiteColor];
    [MaintenanceBtn setTitle:@"维保作业" forState:UIControlStateNormal];
    [MaintenanceBtn setTitleColor:colorWithHexString(@"#3AB0FE") forState:UIControlStateNormal];
    MaintenanceBtn.layer.cornerRadius = 5;
    [[MaintenanceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"维保作业");
    }];
    [downBgView addSubview:MaintenanceBtn];
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource & DOPDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return self.titleArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return self.titleArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    NSLog(@"第三方士大夫士大夫");
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    BXTEquipmentFilesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEquipmentFilesCell" owner:nil options:nil] lastObject];
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    self.cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTMaintenanceDetailViewController *maintenanceVC = [storyboard instantiateViewControllerWithIdentifier:@"BXTMaintenanceDetailViewController"];
    [maintenanceVC dataWithRepairID:@"149"];
    [[self navigation] pushViewController:maintenanceVC animated:YES];
}

@end
