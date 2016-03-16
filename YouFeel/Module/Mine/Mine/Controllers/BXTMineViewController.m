//
//  BXTMineViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMineViewController.h"
#import "BXTHeaderFile.h"
#import "BXTSettingTableViewCell.h"
#import "BXTMineCell.h"
#import "BXTMineIconCell.h"
#import "BXTFeebackInfo.h"
#import "UIImageView+WebCache.h"
#import "BXTUserInformViewController.h"
#import "BXTProjectInfromViewController.h"
#import "BXTFeedbackViewController.h"
#import "BXTSettingViewController.h"
#import "BXTCommentListViewController.h"

@interface BXTMineViewController () <UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *feebackSource;

@end

@implementation BXTMineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTRepairButtonOther" object:nil];
}

- (void)dealloc
{
    LogBlue(@"设置界面释放了！！！！！！");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"我的" andRightTitle:nil andRightImage:nil];
    [self initContentViews];
    
    self.feebackSource = [NSMutableArray array];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RequestFeeback" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self loadDataSoure];
    }];
    [self loadDataSoure];
}

- (void)loadDataSoure
{
    [self showLoadingMBP:@"请稍等..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request feedbackCommentList];
}

#pragma mark -
#pragma mark 初始化视图
- (void)initContentViews
{
    self.iconArray = [[NSArray alloc] initWithObjects:@"mine_tools", @"mine_pen", @"mine_cog", nil];
    self.titleArray = [[NSArray alloc] initWithObjects:@"项目信息", @"意见反馈", @"设置", nil];
    
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - KTABBARHEIGHT) style:UITableViewStyleGrouped];
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    self.currentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.currentTableView];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HEADERIMAGE" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.currentTableView reloadData];
    }];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 8.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 100.f;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BXTMineIconCell *cell = [BXTMineIconCell cellWithTableView:tableView];
        
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[BXTGlobal getUserProperty:U_HEADERIMAGE]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        cell.nameView.text = [BXTGlobal getUserProperty:U_NAME];
        cell.phoneView.text = [BXTGlobal getUserProperty:U_MOBILE];
        
        return cell;
    }
    
    BXTMineCell *mineCell = [BXTMineCell cellWithTableView:tableView];
    
    mineCell.iconView.image = [UIImage imageNamed:self.iconArray[indexPath.section-1]];
    mineCell.titleView.text =  self.titleArray[indexPath.section-1];
    mineCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return mineCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            BXTUserInformViewController *uivc = [[BXTUserInformViewController alloc] init];
            uivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:uivc animated:YES];
            break;
        }
        case 1:
        {
            BXTProjectInfromViewController *pivc = [[BXTProjectInfromViewController alloc] init];
            pivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pivc animated:YES];
            break;
        }
        case 2:
        {
            if (_feebackSource.count > 0)
            {
                BXTCommentListViewController *fbvc = [[BXTCommentListViewController alloc] initWithNibName:@"BXTCommentListViewController" bundle:nil dataSource:_feebackSource];
                fbvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fbvc animated:YES];
            }
            else
            {
                BXTFeedbackViewController *fbvc = [[BXTFeedbackViewController alloc] init];
                fbvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fbvc animated:YES];
            }
            break;
        }
        case 3:
        {
            BXTSettingViewController *stvc = [[BXTSettingViewController alloc] init];
            stvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stvc animated:YES];
            break;
        }
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    LogRed(@"dic......%@",dic);
    NSArray *data = [dic objectForKey:@"data"];
    [BXTFeebackInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"feebackID":@"id"};
    }];
    [BXTCommentInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"commentID":@"id"};
    }];
    [_feebackSource addObjectsFromArray:[BXTFeebackInfo mj_objectArrayWithKeyValuesArray:data]];
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
