//
//  BXTEquipmentFilesView.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTEquipmentFilesView.h"
#import "BXTEquipmentFilesCell.h"
#import "BXTTimeFilterViewController.h"
#import "BXTStandardViewController.h"
#import <MJRefresh.h>
#import "BXTMaintenanceViewController.h"
#import "BXTMaintenanceBookViewController.h"
#import "BXTMaintenceInfo.h"
#import "BXTInspectionInfo.h"
#import "BXTCheckProjectInfo.h"
#import "BXTSelectBoxView.h"

@interface BXTEquipmentFilesView () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate>

@property (nonatomic, strong) DOPDropDownMenu  *DDMenu;
@property (nonatomic, strong) BXTSelectBoxView *boxView;;
@property (nonatomic, assign) CGFloat          cellHeight;
@property (nonatomic, assign) NSInteger        count;
@property (nonatomic, assign) NSInteger        currentPage;
@property (nonatomic, strong) NSArray          *titleArray;
@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) UIView           *bgView;
@property (nonatomic, strong) NSMutableArray   *dataArray;
@property (nonatomic, strong) NSMutableArray   *ChoosTimeArray;
@property (nonatomic, strong) NSMutableArray   *maintencesArray;

@end

@implementation BXTEquipmentFilesView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    self.titleArray = @[@"全部", @"时间范围"];
    self.dataArray = [[NSMutableArray alloc] init];
    self.maintencesArray = [[NSMutableArray alloc] init];
    [self showLoadingMBP:@"数据加载中..."];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**请求维保档案**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request inspectionRecordListWithPagesize:@"5" page:@"1" deviceID:self.deviceID timestart:@"" timeover:@""];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求维保列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request maintenanceEquipmentList:self.deviceID];
    });
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshTable" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.currentPage = 1;
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request inspectionRecordListWithPagesize:@"5" page:@"1" deviceID:self.deviceID timestart:@"" timeover:@""];
    }];
    
    [self createUI];
}

- (void)createUI
{
    // 设备操作规范
    UIButton *topBtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    topBtnView.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [[topBtnView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTStandardViewController *sdvc = [[BXTStandardViewController alloc] init];
        [[self getNavigation] pushViewController:sdvc animated:YES];
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
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 40.f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    self.currentPage = 1;
    __block __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf getResource];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf getResource];
    }];
    
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
        @strongify(self);
        BOOL haveInspection = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstInspection"];
        if (haveInspection)
        {
            [self showList];
        }
        else
        {
            BXTStandardViewController *sdvc = [[BXTStandardViewController alloc] init];
            [[self getNavigation] pushViewController:sdvc animated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstInspection"];
        }
    }];
    [downBgView addSubview:MaintenanceBtn];
}

- (void)getResource
{
    [self showLoadingMBP:@"数据加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    
    if (self.ChoosTimeArray.count == 0)
    {
        [request inspectionRecordListWithPagesize:@"5" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage] deviceID:self.deviceID timestart:@"" timeover:@""];
    }
    else
    {
        [request inspectionRecordListWithPagesize:@"5" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage] deviceID:self.deviceID timestart:self.ChoosTimeArray[0] timeover:self.ChoosTimeArray[1]];
    }
}

#pragma mark -
#pragma mark 事件处理
- (void)showList
{
    self.bgView = [[UIView alloc] initWithFrame:ApplicationWindow.bounds];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.6f;
    _bgView.tag = 101;
    [ApplicationWindow addSubview:_bgView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.bgView removeFromSuperview];
        [self.boxView removeFromSuperview];
    }];
    [self.bgView addGestureRecognizer:tapGesture];
    
    self.boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"请选择维保项目" boxSelectedViewType:CheckProjectsView listDataSource:_maintencesArray markID:nil actionDelegate:self];
    [ApplicationWindow addSubview:_boxView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
    }];
}

#pragma mark -
#pragma mark getDataResource
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    [self.bgView removeFromSuperview];
    [self.boxView removeFromSuperview];
    BXTMaintenceInfo *maintenceInfo = obj;
    BXTMaintenanceViewController *mainVC = [[BXTMaintenanceViewController alloc] initWithNibName:@"BXTMaintenanceViewController" bundle:nil maintence:maintenceInfo deviceID:self.deviceID];
    mainVC.isUpdate = NO;
    [[self getNavigation] pushViewController:mainVC animated:YES];
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
    self.currentPage = 1;
    
    if (self.count != 0)
    {
        if (indexPath.row == 0)
        {
            [self.ChoosTimeArray removeAllObjects];
            
            [self showLoadingMBP:@"数据加载中..."];
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request inspectionRecordListWithPagesize:@"5" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage] deviceID:self.deviceID timestart:@"" timeover:@""];
        }
        else
        {
            BXTTimeFilterViewController *tfvc = [[BXTTimeFilterViewController alloc] init];
            tfvc.delegateSignal = [RACSubject subject];
            @weakify(self);
            [tfvc.delegateSignal subscribeNext:^(NSArray *timeArray) {
                @strongify(self);
                
                self.ChoosTimeArray = [[NSMutableArray alloc] initWithArray:timeArray];
                
                [self showLoadingMBP:@"数据加载中..."];
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request inspectionRecordListWithPagesize:@"5" page:[NSString stringWithFormat:@"%ld", (long)self.currentPage] deviceID:self.deviceID timestart:timeArray[0] timeover:timeArray[1]];
            }];
            [[self getNavigation] pushViewController:tfvc animated:YES];
        }
    }
    self.count++;
}

#pragma mark -
#pragma mark tableView代理方法
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
    BXTEquipmentFilesCell *cell = [BXTEquipmentFilesCell cellWithTableView:tableView];
    cell.inspectionList = self.dataArray[indexPath.section];
    
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
    BXTMaintenceInfo *mainInfo = _dataArray[indexPath.section];
    BXTMaintenanceBookViewController *bookVC = [[BXTMaintenanceBookViewController alloc] initWithNibName:@"BXTMaintenanceBookViewController" bundle:nil deviceID:mainInfo.maintenceID];
    [[self getNavigation] pushViewController:bookVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    LogRed(@"dic.....%@",dic);
    if (type == Inspection_Record_List)
    {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (_currentPage == 1)
        {
            [_dataArray removeAllObjects];
        }
    }
    
    for (NSDictionary *dictionary in data)
    {
        DCObjectMapping *maintenceID = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"maintenceID" onClass:[BXTMaintenceInfo class]];
        DCParserConfiguration *maintenceConfig = [DCParserConfiguration configuration];
        [maintenceConfig addObjectMapping:maintenceID];
        DCKeyValueObjectMapping *maintenceParser = [DCKeyValueObjectMapping mapperForClass:[BXTMaintenceInfo class]  andConfiguration:maintenceConfig];
        BXTMaintenceInfo *maintence = [maintenceParser parseDictionary:dictionary];
        
        NSMutableArray *inspectionArray = [NSMutableArray array];
        NSArray *inspections = [dictionary objectForKey:@"inspection_info"];
        for (NSDictionary *placeDic in inspections)
        {
            DCArrayMapping *inspectionMapper = [DCArrayMapping mapperForClassElements:[BXTCheckProjectInfo class] forAttribute:@"check_arr" onClass:[BXTInspectionInfo class]];
            DCParserConfiguration *inspectionConfig = [DCParserConfiguration configuration];
            [inspectionConfig addArrayMapper:inspectionMapper];
            DCKeyValueObjectMapping *inspectionParser = [DCKeyValueObjectMapping mapperForClass:[BXTInspectionInfo class]  andConfiguration:inspectionConfig];
            BXTInspectionInfo *inspection = [inspectionParser parseDictionary:placeDic];
            [inspectionArray addObject:inspection];
        }
        maintence.inspection_info = inspectionArray;
        
        if (type == MaintenanceEquipmentList)
        {
            [_maintencesArray addObject:maintence];
        }
        else if (type == Inspection_Record_List)
        {
            [_dataArray addObject:maintence];
        }
    }
    [_tableView reloadData];
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

@end
