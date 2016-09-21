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
#import "BXTSubgroupInfo.h"
#import "BXTAllDepartmentInfo.h"
#import "BXTPostionInfo.h"
#import "BXTSearchItemViewController.h"
#import "ANKeyValueTable.h"
#import "BXTProjectManageViewController.h"
#import "BXTChooseListViewController.h"
#import "BXTChangePositionViewController.h"

@interface BXTProjectCertificationViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

// 展现列表
@property (strong, nonatomic) UITableView    *tableView;
@property (strong, nonatomic) NSArray        *titleArray;
@property (strong, nonatomic) NSMutableArray *detailArray;

// 传递数组
@property (strong, nonatomic) NSMutableArray *transArray;
@property (strong, nonatomic) NSMutableArray *departmentArray;

// 选择列表
@property (nonatomic, strong) UIView         *selectBgView;
@property (nonatomic, strong) UITableView    *selectTableView;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *mulitSelectArray;
@property (nonatomic, assign) int            selectRow;

/** ---- 身份 - 员工、客户 ---- */
@property (assign, nonatomic) BOOL isCompanyType;
/** ---- 职位 - 是否报修者 ---- */
@property (assign, nonatomic) BOOL isRepairer;
/** ---- 客户 - 是否选择所属 ---- */
@property (assign, nonatomic) BOOL isSelectedTheOne;

@end

@implementation BXTProjectCertificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"项目认证" andRightTitle:nil andRightImage:nil];
    
    self.titleArray = @[@"", @"身份"];
    self.detailArray = [[NSMutableArray alloc] initWithObjects:@"", @"请选择", nil];
    self.transArray = [[NSMutableArray alloc]  initWithObjects:self.transMyProject.shop_id, @"", nil];
    
    self.departmentArray = [[NSMutableArray alloc] init];
    
    //设置初始值，不要默认选中第0行
    self.selectRow = -1;
    self.mulitSelectArray = [[NSMutableArray alloc] init];
    
    [self showLoadingMBP:@"加载中..."];
    
    /**获取部门列表**/
    BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [fau_request listOFDepartmentWithPid:@""
                                  shopID:self.transMyProject.shop_id
                            identityType:@"1"];
    
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
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.backgroundColor = colorWithHexString(@"#5DAEF9");
    commitBtn.layer.cornerRadius = 5;
    @weakify(self);
    [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        NSLog(@"transArray ---- %@", self.transArray);
        if ([self.transArray containsObject:@""])
        {
            [MYAlertAction showAlertWithTitle:@"请填写完整" msg:nil chooseBlock:nil buttonsStatement:@"确定", nil];
        }
        else
        {
            [self showLoadingMBP:@"加载中..."];
            
            if (self.isCompanyType)
            {
                BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
                [fau_request authenticationApplyWithShopID:self.transMyProject.shop_id
                                                      type:@"1"
                                              departmentID:self.transArray[2]
                                                  dutyName:self.transArray[3]
                                                subgroupID:@""
                                           haveSubgroupIDs:@""
                                                  storesID:@""
                                              bindPlaceIDs:@""];
            }
            else
            {
                /**维修位置**/
                BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
                [fau_request modifyBindPlaceWithShopID:self.transMyProject.shop_id placeID:self.transArray[3]];
                
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
    
    if (indexPath.section == 0)
    {
        BXTProjectCertificationCell *cell = [BXTProjectCertificationCell cellWithTableView:tableView];
        
        cell.myProject = self.transMyProject;
        
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
    if (tableView == self.selectTableView)
    {
        NSString *selectRow  = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        //判断数组中有没有被选中行的行号,
        if ([self.mulitSelectArray containsObject:selectRow])
        {
            [self.mulitSelectArray removeObject:selectRow];
        }
        else
        {
            if (self.mulitSelectArray.count == 1)
            {
                [self.mulitSelectArray replaceObjectAtIndex:0 withObject:selectRow];
            }
            else
            {
                [self.mulitSelectArray addObject:selectRow];
            }
        }
        
        [tableView reloadData];
        
        return;
    }
    if (indexPath.section == 1)
    {
        [self createTableView];
    }
    
    // 员工
    if (self.isCompanyType)
    {
        if (indexPath.section == 2)
        {
            [self pushDepartmentViewController];
        }
        else if (indexPath.section == 3)
        {
            BXTChangePositionViewController *cpvc = [[BXTChangePositionViewController alloc] init];
            cpvc.transPosition = ^(NSString *transPosition) {
                NSLog(@"transPosition ---- %@", transPosition);
                
                [self.transArray replaceObjectAtIndex:3 withObject:transPosition];
                [self.detailArray replaceObjectAtIndex:3 withObject:transPosition];
                
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:cpvc animated:YES];
        }
    }
    else
    {
        if (indexPath.section == 2)
        {
            [self pushChooseListViewController];
        }
        else if (indexPath.section == 3)
        {
            if (self.isSelectedTheOne) {
                [self pushLocationViewController];
            }
            else {
                [MYAlertAction showAlertWithTitle:@"请选择所属" msg:nil chooseBlock:^(NSInteger buttonIdx) {
                } buttonsStatement:@"确定", nil];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pushChooseListViewController
{
    BXTChooseListViewController *chooseListVC = [[BXTChooseListViewController alloc] init];
    chooseListVC.typeOfPush = PushType_Department;
    chooseListVC.delegateSignal = [RACSubject subject];
    @weakify(self);
    [chooseListVC.delegateSignal subscribeNext:^(BXTStoresListsInfo *storeInfo) {
        @strongify(self);
        
        self.isSelectedTheOne = YES;
        
        [self.detailArray replaceObjectAtIndex:2 withObject:storeInfo.stores_name];
        [self.transArray replaceObjectAtIndex:2 withObject:storeInfo.storeID];
        
        [self.detailArray replaceObjectAtIndex:3 withObject:@"请选择"];
        [self.transArray replaceObjectAtIndex:3 withObject:@" "];
        
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:chooseListVC animated:YES];
}

- (void)pushLocationViewController
{
    BXTChooseListViewController *chooseListVC = [[BXTChooseListViewController alloc] init];
    chooseListVC.typeOfPush = PushType_Location;
    chooseListVC.transID = self.transArray[2];
    chooseListVC.delegateSignal = [RACSubject subject];
    @weakify(self);
    [chooseListVC.delegateSignal subscribeNext:^(BXTPlaceListInfo *storeInfo) {
        @strongify(self);
        
        [self.detailArray replaceObjectAtIndex:3 withObject:storeInfo.place_name];
        [self.transArray replaceObjectAtIndex:3 withObject:storeInfo.placeID];
        
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:chooseListVC animated:YES];
}

- (void)pushDepartmentViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
    BXTSearchItemViewController *searchVC = (BXTSearchItemViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTSearchItemViewController"];
    @weakify(self);
    [searchVC userChoosePlace:self.departmentArray isProgress:NO type:DepartmentSearchType block:^(BXTBaseClassifyInfo *classifyInfo,NSString *name) {
        @strongify(self);
        BXTAllDepartmentInfo *departmentInfo = (BXTAllDepartmentInfo *)classifyInfo;
        [self.detailArray replaceObjectAtIndex:2 withObject:departmentInfo.department];
        [self.transArray replaceObjectAtIndex:2 withObject:departmentInfo.departmentID];
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark -
#pragma mark - 方法
- (void)createTableView
{
    self.isSelectedTheOne = NO;
    
    self.selectArray = [[NSMutableArray alloc] initWithObjects:@"员工", @"客户", nil];
    
    self.selectBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.selectBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    self.selectBgView.tag = 102;
    [self.view addSubview:self.selectBgView];
    
    // selectTableView
    CGFloat tableViewH = self.selectArray.count * 50 + 10;
    if (self.selectArray.count >= 6)
    {
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
        
        // 选择身份  -  改变结构
        if (self.mulitSelectArray.count != 0)
        {
            [self adjustStructureTypeOFGroup];
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

- (void)adjustStructureTypeOFGroup
{
    self.isRepairer = NO;
    
    NSString *selected = [NSString stringWithFormat:@"%@", self.mulitSelectArray[0]];
    if ([selected integerValue] == 0)
    {
        self.isCompanyType = YES;
        self.titleArray = @[@"", @"身份", @"部门", @"职位"];
        self.detailArray = [[NSMutableArray alloc] initWithObjects:@"", @"员工", @"请选择", @"请选择", nil];
        self.transArray = [[NSMutableArray alloc]  initWithObjects:self.transMyProject.shop_id, @"员工", @"", @"", nil];
    }
    else
    {
        self.isCompanyType = NO;
        self.titleArray = @[@"", @"身份", @"所属", @"常用位置(选填)"];
        self.detailArray = [[NSMutableArray alloc] initWithObjects:@"", @"客户", @"请选择", @"请选择", nil];
        self.transArray = [[NSMutableArray alloc]  initWithObjects:self.transMyProject.shop_id, @"客户", @"", @" ", nil];
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
    
    if (type == DepartmentLists)
    {
        [BXTAllDepartmentInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"departmentID":@"id"};
        }];
        [self.departmentArray addObjectsFromArray:[BXTAllDepartmentInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    else if (type == AuthenticationApply)
    {
        if ([dic[@"returncode"] integerValue] == 0)
        {
            [BXTGlobal showText:@"项目认证申请成功" view:self.view completionBlock:^{
                if ([BXTGlobal shareGlobal].isLogin)
                {
                    for (UIViewController *temp in self.navigationController.viewControllers)
                    {
                        if ([temp isKindOfClass:[BXTProjectManageViewController class]])
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshBXTProjectManageViewController" object:nil];
                            [self.navigationController popToViewController:temp animated:YES];
                            return ;
                        }
                    }
                    
                    if (self.delegateSignal)
                    {
                        [self.delegateSignal sendNext:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginAgin" object:nil];
                }
            }];
        }
    }
    else if (type == AuthenticationModify)
    {
        if ([dic[@"returncode"] integerValue] == 0)
        {
            [BXTGlobal showText:@"项目认证修改成功" view:self.view completionBlock:^{
                for (UIViewController *temp in self.navigationController.viewControllers)
                {
                    if ([temp isKindOfClass:[BXTProjectManageViewController class]])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshBXTProjectManageViewController" object:nil];
                        [self.navigationController popToViewController:temp animated:YES];
                        return ;
                    }
                }
            }];
        }
    }
    else if (type == ModifyBindPlace && [dic[@"returncode"] integerValue] == 0)
    {
        [BXTGlobal showText:@"常用位置绑定成功" view:self.view completionBlock:^{
            [self showLoadingMBP:@"加载中..."];
            BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
            [fau_request authenticationApplyWithShopID:self.transMyProject.shop_id
                                                  type:@"2"
                                          departmentID:@""
                                              dutyName:@""
                                            subgroupID:@""
                                       haveSubgroupIDs:@""
                                              storesID:self.transArray[2]
                                          bindPlaceIDs:self.transArray[3]];
        }];
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
        if (_selectTableView)
        {
            [self.mulitSelectArray removeAllObjects];
            [_selectTableView removeFromSuperview];
            _selectTableView = nil;
        }
        [view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
