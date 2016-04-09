//
//  BXTProjectCertificationViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectCertificationViewController.h"
#import "BXTProjectCertificationCell.h"
#import "BXTUserInformCell.h"
#import "BXTSubgroup.h"
#import "BXTAllDepartmentInfo.h"
#import "BXTPostionInfo.h"
#import "BXTSearchPlaceViewController.h"
#import "ANKeyValueTable.h"

@interface BXTProjectCertificationViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

// 展现列表
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableArray *detailArray;

// 传递数组
@property (strong, nonatomic) NSMutableArray *transArray;
@property (strong, nonatomic) NSMutableArray *departmentArray;

// 选择列表
@property (nonatomic, strong) UIView *selectBgView;
@property (nonatomic, strong) UITableView *selectTableView;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *mulitSelectArray;
@property (nonatomic, assign) int selectRow;
@property (nonatomic, assign) int showSelectedRow;

@property (assign, nonatomic) BOOL isCompanyType;

// 存值参数
@property (nonatomic, strong) NSMutableArray *positionArray;
@property (nonatomic, strong) NSMutableArray *positionIDArray;
@property (nonatomic, strong) NSMutableArray *subgroupArray;
@property (nonatomic, strong) NSMutableArray *subgroupIDArray;

@end

@implementation BXTProjectCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"项目认证" andRightTitle:nil andRightImage:nil];
    
    self.titleArray = @[@"", @"机构类型"];
    self.detailArray = [[NSMutableArray alloc] initWithObjects:@"", @"请选择", nil];
    self.transArray = [[NSMutableArray alloc]  initWithObjects:self.transProject.shop_id, @"", nil];
    
    self.departmentArray = [[NSMutableArray alloc] init];
    self.positionArray = [[NSMutableArray alloc] init];
    self.positionIDArray = [[NSMutableArray alloc] init];
    self.subgroupArray = [[NSMutableArray alloc] init];
    self.subgroupIDArray = [[NSMutableArray alloc] init];
    
    //设置初始值，不要默认选中第0行
    self.selectRow = -1;
    self.mulitSelectArray = [[NSMutableArray alloc] init];
    
    
    [self showLoadingMBP:@"努力加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**请求故障类型列表**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request listOFSubgroup];
    });
    dispatch_async(concurrentQueue, ^{
        /**获取职位列表接口**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request listOFDutyWithDutyType:@""];
    });
    dispatch_async(concurrentQueue, ^{
        /**获取部门列表**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request listOFDepartmentWithPid:@""];
    });
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT-70) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake((SCREEN_WIDTH - 180) / 2, 10, 180, 50);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.backgroundColor = colorWithHexString(@"#5DAEF9");
    commitBtn.layer.cornerRadius = 5;
    @weakify(self);
    [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        NSLog(@"transArray ---- %@", self.transArray);
        if ([self.transArray containsObject:@""]) {
            [MYAlertAction showAlertWithTitle:@"请填写完整" msg:nil chooseBlock:nil buttonsStatement:@"确定", nil];
        }
        else {
            [self showLoadingMBP:@"努力加载中..."];
            BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
            
            if (self.isCompanyType) {
                [fau_request authenticationApplyWithShopID:self.transProject.shop_id
                                                      type:@"1"
                                              departmentID:self.transArray[2]
                                                    dutyID:self.transArray[3]
                                                subgroupID:self.transArray[4]
                                           haveSubgroupIDs:self.transArray[5]
                                                  storesID:@""];
            }
            else {
                [fau_request authenticationApplyWithShopID:self.transProject.shop_id
                                                      type:@"2"
                                              departmentID:@""
                                                    dutyID:@""
                                                subgroupID:@""
                                           haveSubgroupIDs:@""
                                                  storesID:self.transArray[2]];
            }
        }
    }];
    [footerView addSubview:commitBtn];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.selectTableView)
    {
        return 1;
    }
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.selectTableView)
    {
        return self.selectArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView)
    {
        static NSString *cellID = @"cellSelect";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        //字符串
        NSString *selectRow = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        //数组中包含当前行号，设置对号
        if ([self.mulitSelectArray containsObject:selectRow])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = self.selectArray[indexPath.row];
        
        return cell;
    }
    
    
    if (indexPath.section == 0) {
        BXTProjectCertificationCell *cell = [BXTProjectCertificationCell cellWithTableView:tableView];
        
        cell.myProject = self.transProject;
        
        return cell;
    }
    
    
    BXTUserInformCell *cell = [BXTUserInformCell cellWithTableView:tableView];
    
    cell.titleView.text = self.titleArray[indexPath.section];
    cell.detailView.text = self.detailArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectTableView) {
        NSString *selectRow  = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        
        if (self.showSelectedRow == 1 || self.showSelectedRow == 4) {        // 单选
            //判断数组中有没有被选中行的行号,
            if ([self.mulitSelectArray containsObject:selectRow]) {
                [self.mulitSelectArray removeObject:selectRow];
            }
            else {
                if (self.mulitSelectArray.count == 1) {
                    [self.mulitSelectArray replaceObjectAtIndex:0 withObject:selectRow];
                } else {
                    [self.mulitSelectArray addObject:selectRow];
                }
            }
        }
        else {      // 多选
            if ([self.mulitSelectArray containsObject:selectRow]) {
                [self.mulitSelectArray removeObject:selectRow];
            }
            else {
                [self.mulitSelectArray addObject:selectRow];
            }
        }
        
        [tableView reloadData];
        return;
    }
    
    
    if (indexPath.section == 1) {
        [self createTableViewWithIndex:indexPath.section];
    }
    
    // 项目管理公司
    if (self.isCompanyType) {
        if (indexPath.section == 2) {
            [self pushDepartmentViewController];
        }
        else if (indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5) {
            [self createTableViewWithIndex:indexPath.section];
        }
    }
    else {
        if (indexPath.section == 2) {
            
        }
        else if (indexPath.section == 3) {
            [self pushLocationViewController];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pushLocationViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTSearchPlaceViewController *searchVC = (BXTSearchPlaceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTSearchPlaceViewController"];
    NSArray *dataSource = [[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE];
    @weakify(self);
    [searchVC userChoosePlace:dataSource block:^(BXTPlaceInfo *placeInfo) {
        @strongify(self);
        MJExtensionLog(@"---------- placeInfo:%@", placeInfo.place);
        [self.detailArray replaceObjectAtIndex:3 withObject:placeInfo.place];
        [self.transArray replaceObjectAtIndex:3 withObject:placeInfo.placeID];
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)pushDepartmentViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTSearchPlaceViewController *searchVC = (BXTSearchPlaceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTSearchPlaceViewController"];
    @weakify(self);
    [searchVC userChoosePlace:self.departmentArray block:^(BXTAllDepartmentInfo *departmentInfo) {
        @strongify(self);
        MJExtensionLog(@"---------- placeInfo:%@", departmentInfo.department);
        [self.detailArray replaceObjectAtIndex:2 withObject:departmentInfo.department];
        [self.transArray replaceObjectAtIndex:2 withObject:departmentInfo.departmentID];
        [self.tableView reloadData];
    }];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark -
#pragma mark - 方法
- (void)createTableViewWithIndex:(NSInteger)index
{
    self.showSelectedRow = 0;
    if (index == 1) {
        self.selectArray = [[NSMutableArray alloc] initWithObjects:@"项目管理公司", @"客户组", nil];
        self.showSelectedRow = 1;
    }
    else if (index == 3) {
        self.selectArray = self.positionArray;
        self.showSelectedRow = 4;
    }
    else if (index == 4) {
        self.selectArray = self.subgroupArray;
        self.showSelectedRow = 4;
    }
    else if (index == 5) {
        self.selectArray = self.subgroupArray;
        self.showSelectedRow = 5;
    }
    
    self.selectBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.selectBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    self.selectBgView.tag = 102;
    [self.view addSubview:self.selectBgView];
    
    
    // selectTableView
    CGFloat tableViewH = self.selectArray.count * 50 + 10;
    if (self.selectArray.count >= 6) {
        tableViewH = 6 * 50 + 10;
    }
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - tableViewH-50, SCREEN_WIDTH, tableViewH) style:UITableViewStylePlain];
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    [self.view addSubview:self.selectTableView];
    
    
    // toolView
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"#EEF3F6");
    [self.selectBgView addSubview:toolView];
    
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        // 选择机构类型  -  改变结构
        if (index == 1) {
            [self adjustStructureType];
        }
        
        if (index == 3) {
            NSString *selectRow = self.mulitSelectArray[0];
            [self.detailArray replaceObjectAtIndex:index withObject:self.positionArray[[selectRow integerValue]]];
            [self.transArray replaceObjectAtIndex:index withObject:self.positionIDArray[[selectRow integerValue]]];
            [self.tableView reloadData];
        }
        else if (index == 4) {
            NSString *selectRow = self.mulitSelectArray[0];
            [self.detailArray replaceObjectAtIndex:index withObject:self.subgroupArray[[selectRow integerValue]]];
            [self.transArray replaceObjectAtIndex:index withObject:self.subgroupIDArray[[selectRow integerValue]]];
            [self.tableView reloadData];
        }
        else if (index == 5) {
            NSString *finalStr =@"";
            NSString *finalNumStr = @"";
            for (id object in self.mulitSelectArray) {
                finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"%@ ", self.selectArray[[object intValue]]]];
                finalNumStr = [finalNumStr stringByAppendingString:[NSString stringWithFormat:@"%@,", self.subgroupIDArray[[object intValue]]]];
            }
            if (finalNumStr.length >= 1) {
                finalNumStr = [finalNumStr substringToIndex:finalNumStr.length - 1];
            }
            
            // 赋值
            if (![BXTGlobal isBlankString:finalStr])
            {
                [self.detailArray replaceObjectAtIndex:index withObject:finalStr];
                [self.transArray replaceObjectAtIndex:index withObject:finalNumStr];
                [self.tableView reloadData];
            }
        }
        
        
        // 清除
        [self.mulitSelectArray removeAllObjects];
        [_selectTableView removeFromSuperview];
        _selectTableView = nil;
        [self.selectBgView removeFromSuperview];
    }];
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
}

- (void)adjustStructureType
{
    NSString *selected = [NSString stringWithFormat:@"%@", self.mulitSelectArray[0]];
    if ([selected integerValue] == 0) {
        self.isCompanyType = YES;
        self.titleArray = @[@"", @"机构类型", @"部门", @"职位", @"本职专业", @"其他技能"];
        self.detailArray = [[NSMutableArray alloc] initWithObjects:@"", @"项目管理公司", @"请选择", @"请选择", @"请选择", @"请选择", nil];
        self.transArray = [[NSMutableArray alloc]  initWithObjects:self.transProject.shop_id, @"项目管理公司", @"", @"", @"", @"", nil];
    }
    else {
        self.isCompanyType = NO;
        self.titleArray = @[@"", @"机构类型", @"所属", @"常用位置"];
        self.detailArray = [[NSMutableArray alloc] initWithObjects:@"", @"客户组", @"请选择", @"请选择", nil];
        self.transArray = [[NSMutableArray alloc]  initWithObjects:self.transProject.shop_id, @"客户组", @"", @"", nil];
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    
    if (type == SubgroupLists)
    {
        NSMutableArray *subgroupArray = [[NSMutableArray alloc] init];
        [BXTSubgroup mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"subgroupID":@"id"};
        }];
        [subgroupArray addObjectsFromArray:[BXTSubgroup mj_objectArrayWithKeyValuesArray:data]];
        
        for (BXTSubgroup *subgroupInfo in subgroupArray) {
            [self.subgroupArray addObject:subgroupInfo.subgroup];
            [self.subgroupIDArray addObject:subgroupInfo.subgroupID];
        }
    }
    else if (type == DepartmentLists)
    {
        [BXTAllDepartmentInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"departmentID":@"id"};
        }];
        [self.departmentArray addObjectsFromArray:[BXTAllDepartmentInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    else if (type == DutyLists)
    {
        [BXTPostionInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"role_id":@"id"};
        }];
        
        NSMutableArray *dataSource = [[NSMutableArray alloc] init];
        [dataSource addObjectsFromArray:[BXTPostionInfo mj_objectArrayWithKeyValuesArray:data]];
        
        for (BXTPostionInfo *postion in dataSource) {
            [self.positionArray addObject:postion.duty_name];
            [self.positionIDArray addObject:postion.role_id];
        }
    }
    else if (type == AuthenticationApply)
    {
        if (dic[@"returncode"] == 0) {
            [BXTGlobal showText:@"项目认证申请成功" view:self.view completionBlock:^{
                if (self.delegateSignal) {
                    [self.delegateSignal sendNext:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 102)
    {
        if (_selectTableView) {
            [self.mulitSelectArray removeAllObjects];
            [_selectTableView removeFromSuperview];
            _selectTableView = nil;
        }
        [view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
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
