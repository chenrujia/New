//
//  BXTDailyOrderFilterViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/18.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDOFilterViewController.h"
#import "BXTEPFilterCell.h"
#import "BXTSubgroupInfo.h"
#import "BXTRepairStateInfo.h"

@interface BXTDOFilterViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *transArray;
@property (nonatomic, strong) UIView *selectBgView;
@property (nonatomic, strong) UITableView *selectTableView;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *mulitSelectArray;
@property (nonatomic, assign) int selectRow;
@property (nonatomic, assign) NSInteger showSelectedRow;

// 存值参数
@property (nonatomic, strong) NSMutableArray *subgroupArray;
@property (nonatomic, strong) NSMutableArray *subgroupIDArray;
@property (nonatomic, strong) NSMutableArray *repairStateArray;
@property (nonatomic, strong) NSMutableArray *repairStateIDArray;

@end

@implementation BXTDOFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationSetting:@"筛选" andRightTitle:nil andRightImage:nil];
    
    self.titleArray = @[@"时间范围", @"专业分组", @"工单分类"];
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"待完善", @"待完善", @"待完善", nil];
    self.transArray = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil];
    
    self.subgroupArray = [[NSMutableArray alloc] init];
    self.subgroupIDArray = [[NSMutableArray alloc] init];
    self.repairStateArray = [[NSMutableArray alloc] init];
    self.repairStateIDArray = [[NSMutableArray alloc] init];
    
    
    //设置初始值，不要默认选中第0行
    self.selectRow = -1;
    self.mulitSelectArray = [[NSMutableArray alloc] init];
    
    
    [self showLoadingMBP:@"数据加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**专业分组**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request listOFSubgroup];
    });
    dispatch_async(concurrentQueue, ^{
        /**工单分类**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request repairStates];
    });
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(20, 30, SCREEN_WIDTH - 40, 50.f);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 4.f;
    @weakify(self);
    [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        int count = 0;
        for (NSString *str in self.dataArray) {
            if ([str isEqualToString:@"待完善"]) {
                count++;
            }
        }
        
        if (count != self.dataArray.count) {
            [BXTGlobal showText:@"填写完成" view:self.view completionBlock:^{
                if (self.delegateSignal) {
                    [self.delegateSignal sendNext:self.transArray];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        else {
            [MYAlertAction showAlertWithTitle:@"温馨提示" msg:@"请填写筛选条件" chooseBlock:^(NSInteger buttonIdx) {
                
            } buttonsStatement:@"确定", nil];
        }
    }];
    
    [footerView addSubview:doneBtn];
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
    
    static NSString *cellID = @"cell";
    BXTEPFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEPFilterCell" owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.titleView.text = self.titleArray[indexPath.section];
    cell.detailView.text = self.dataArray[indexPath.section];
    
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
        
        if (self.showSelectedRow != 1) {  // 单选
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
        else {  // 多选
            //判断数组中有没有被选中行的行号,
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
    
    
    [self createTableViewWithIndex:indexPath.section];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - 方法
- (void)createTableViewWithIndex:(NSInteger)index
{
    self.showSelectedRow = index;
    if (index == 0) {
        self.selectArray = [[NSMutableArray alloc] initWithObjects:@"全部", @"今天", @"本周", @"本月",@"本年", nil];
    }
    else if (index == 1) {
        self.selectArray = self.subgroupArray;
    }
    else if (index == 2) {
        self.selectArray = self.repairStateArray;
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
        
        NSString *finalStr =@"";
        NSString *finalNumStr = @"";
        for (id object in self.mulitSelectArray) {
            finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@" %@", self.selectArray[[object intValue]]]];
            
            if (index == 0) {
                finalNumStr = [finalNumStr stringByAppendingString:[NSString stringWithFormat:@"%@,", object]];
            }
            else if (index == 1) {
                finalNumStr = [finalNumStr stringByAppendingString:[NSString stringWithFormat:@"%@,", self.subgroupIDArray[[object intValue]]]];
            }
            else if (index == 2) {
                finalNumStr = [finalNumStr stringByAppendingString:[NSString stringWithFormat:@"%@,", self.repairStateIDArray[[object intValue]]]];
            }
        }
        if (finalNumStr.length >= 1) {
            finalNumStr = [finalNumStr substringToIndex:finalNumStr.length - 1];
        }
        
        // 赋值
        if (![BXTGlobal isBlankString:finalStr])
        {
            [self.dataArray replaceObjectAtIndex:index withObject:finalStr];
            [self.transArray replaceObjectAtIndex:index withObject:finalNumStr];
            [self.tableView reloadData];
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

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == SubgroupLists && data.count > 0)
    {
        NSMutableArray *subgroupArray = [[NSMutableArray alloc] init];
        [BXTSubgroupInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"subgroupID":@"id"};
        }];
        [subgroupArray addObjectsFromArray:[BXTSubgroupInfo mj_objectArrayWithKeyValuesArray:data]];
        
        for (BXTSubgroupInfo *subgroupInfo in subgroupArray) {
            [self.subgroupArray addObject:subgroupInfo.subgroup];
            [self.subgroupIDArray addObject:subgroupInfo.subgroupID];
        }
        
    }
    else if (type == RepairState && data.count > 0)
    {
        NSMutableArray *repairStateArray = [[NSMutableArray alloc] init];
        [BXTRepairStateInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"repairStateID":@"id"};
        }];
        [repairStateArray addObjectsFromArray:[BXTRepairStateInfo mj_objectArrayWithKeyValuesArray:data]];
        
        for (BXTRepairStateInfo *repairStateInfo in repairStateArray) {
            [self.repairStateArray addObject:repairStateInfo.param_value];
            [self.repairStateIDArray addObject:repairStateInfo.param_key];
        }
    }
    
    [self.selectTableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
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
