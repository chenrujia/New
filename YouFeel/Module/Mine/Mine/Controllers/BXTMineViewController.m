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
#import "UIImageView+WebCache.h"

#import "BXTUserInformViewController.h"
#import "BXTProjectInfromViewController.h"
#import "BXTFeedbackViewController.h"
#import "BXTSettingViewController.h"

@interface BXTMineViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *currentTableView;

@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation BXTMineViewController

- (void)dealloc
{
    LogBlue(@"设置界面释放了！！！！！！");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"我的" andRightTitle:nil andRightImage:nil];
    
    [self initContentViews];
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
    return 10.f;
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
    return 60.f;
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
    BXTUserInformViewController *uivc = [[BXTUserInformViewController alloc] init];
    BXTProjectInfromViewController *pivc = [[BXTProjectInfromViewController alloc] init];
    BXTFeedbackViewController *fbvc = [[BXTFeedbackViewController alloc] init];
    BXTSettingViewController *stvc = [[BXTSettingViewController alloc] init];
    uivc.hidesBottomBarWhenPushed = YES;
    pivc.hidesBottomBarWhenPushed = YES;
    fbvc.hidesBottomBarWhenPushed = YES;
    stvc.hidesBottomBarWhenPushed = YES;
    
    switch (indexPath.section)
    {
        case 0: [self.navigationController pushViewController:uivc animated:YES]; break;
        case 1: [self.navigationController pushViewController:pivc animated:YES]; break;
        case 2: [self.navigationController pushViewController:fbvc animated:YES]; break;
        case 3: [self.navigationController pushViewController:stvc animated:YES]; break;
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
