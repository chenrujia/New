//
//  BXTRepairHomeViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairHomeViewController.h"
#import "BXTReaciveOrdersViewController.h"
#import "BXTOrderManagerViewController.h"
#import "BXTGrabOrderViewController.h"
#import "BXTAchievementsViewController.h"
#import "BXTEvaluationListViewController.h"
#import "BXTRepairWordOrderViewController.h"
#import "BXTGlobal.h"
#import "BXTPublicSetting.h"
#import "BXTMessageListViewController.h"

@interface BXTRepairHomeViewController ()

@end

@implementation BXTRepairHomeViewController

- (instancetype)initWithIsRepair:(BOOL)repair
{
    self = [super init];
    if (self)
    {
        self.isRepair = repair;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comingNewRepairs) name:@"NewRepairComing" object:nil];

    imgNameArray = [NSMutableArray arrayWithObjects:@"orders",
                    @"Work_order_management",
                    @"snotepad_ok",
                    @"cloumnar_shape",
                    @"Notice",
                    @"News",
                    @"Feedback",
                    @"Cuetomer_service",
                    @"About_us", nil];
    titleNameArray = [NSMutableArray arrayWithObjects:@"接单",@"工单管理",@"审批",@"绩效",@"消息",@"会话",@"反馈",@"客服",@"关于", nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([BXTGlobal shareGlobal].orderIDs.count > 0)
    {
        [self comingNewRepairs];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
    [logo_btn setTitle:companyInfo.name forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark 事件处理
- (void)repairClick
{
    BXTRepairWordOrderViewController *workOrderVC = [[BXTRepairWordOrderViewController alloc] init];
    [self.navigationController pushViewController:workOrderVC animated:YES];
}

- (void)comingNewRepairs
{
    LogBlue(@"2count......%lu",(unsigned long)[BXTGlobal shareGlobal].orderIDs.count);
    BXTGrabOrderViewController *grabOrderVC = [[BXTGrabOrderViewController alloc] init];
    [self.navigationController pushViewController:grabOrderVC animated:YES];
}

#pragma mark -
#pragma mark 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] init];
            [self.navigationController pushViewController:reaciveVC animated:YES];
        }
            break;
        case 1:
        {
            BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] initWithControllerType:MaintenanceManType];
            [self.navigationController pushViewController:orderManagerVC animated:YES];
        }
            break;
        case 3:
        {
            BXTAchievementsViewController *achievementsVC = [[BXTAchievementsViewController alloc] init];
            [self.navigationController pushViewController:achievementsVC animated:YES];
        }
            break;
        case 4:
        {
            BXTMessageListViewController *messageVC = [[BXTMessageListViewController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        default:
            break;
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
