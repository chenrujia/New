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
#import "BXTGlobal.h"
#import "BXTPublicSetting.h"

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
                    @"Cloumnar_shape",@"Notice",
                    @"News",
                    @"Notepad_Ok",
                    @"Feedback",
                    @"Cuetomer_service",
                    @"About_us", nil];
    titleNameArray = [NSMutableArray arrayWithObjects:@"接单",@"工单管理",@"绩效",@"通知",@"消息",@"审批",@"意见反馈",@"客服",@"关于我们", nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([BXTGlobal shareGlobal].orderIDs.count > 0)
    {
        [self comingNewRepairs];
    }
}

#pragma mark -
#pragma mark 初始化视图
- (void)createLogoView
{
    [super createLogoView];
    [logo_btn setTitle:@"华联天通苑店" forState:UIControlStateNormal];
    [shopBtn setImage:[UIImage imageNamed:@"Grabone"] forState:UIControlStateNormal];
    shop_label.text = @"实时抢单";
}

#pragma mark -
#pragma mark 事件处理
- (void)repairClick
{
    BXTReaciveOrdersViewController *reaciveVC = [[BXTReaciveOrdersViewController alloc] init];
    [self.navigationController pushViewController:reaciveVC animated:YES];
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
        case 2:
        {
            BXTAchievementsViewController *achievementsVC = [[BXTAchievementsViewController alloc] init];
            [self.navigationController pushViewController:achievementsVC animated:YES];
        }
            break;
        case 4:
        {
            BXTEvaluationListViewController *evalistVC = [[BXTEvaluationListViewController alloc] init];
            [self.navigationController pushViewController:evalistVC animated:YES];
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
