//
//  BXTShopsHomeViewController.m
//  BXT
//
//  Created by Jason on 15/9/16.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTShopsHomeViewController.h"
#import "BXTRepairViewController.h"
#import "BXTOrderManagerViewController.h"
#import "BXTExaminationViewController.h"
#import "BXTAboutUsViewController.h"
#import "BXTWorkOderViewController.h"
#import "BXTEvaluationListViewController.h"
#import "BXTHeadquartersInfo.h"
#import "BXTGlobal.h"

@interface BXTShopsHomeViewController ()

@end

@implementation BXTShopsHomeViewController

- (instancetype)initWithIsRepair:(BOOL)repair
{
    self = [super init];
    if (self)
    {
        self.isRepair = repair;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imgNameArray = [NSMutableArray arrayWithObjects:@"TooL",
                    @"Work_order_management",
                    @"Cloumnar_shape",@"Notice",
                    @"News",
                    @"Notepad_Ok",
                    @"Feedback",
                    @"Cuetomer_service",
                    @"About_us", nil];
    titleNameArray = [NSMutableArray arrayWithObjects:@"我要报修",@"工单管理",@"绩效",@"通知",@"消息",@"审批",@"意见反馈",@"客服",@"关于我们", nil];
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
    BXTWorkOderViewController *workOrderVC = [[BXTWorkOderViewController alloc] init];
    [self.navigationController pushViewController:workOrderVC animated:YES];
}

#pragma mark -
#pragma mark 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            BXTRepairViewController *repairVC = [[BXTRepairViewController alloc] initWithVCType:ShopsVCType];
            [self.navigationController pushViewController:repairVC animated:YES];
        }
            break;
        case 1:
        {
            BXTOrderManagerViewController *orderManagerVC = [[BXTOrderManagerViewController alloc] initWithControllerType:RepairType];
            [self.navigationController pushViewController:orderManagerVC animated:YES];
        }
            break;
        case 4:
        {
            BXTEvaluationListViewController *evalistVC = [[BXTEvaluationListViewController alloc] init];
            [self.navigationController pushViewController:evalistVC animated:YES];
        }
            break;
        case 5:
        {
            BXTExaminationViewController *examinationVC = [[BXTExaminationViewController alloc] init];
            [self.navigationController pushViewController:examinationVC animated:YES];
            break;
        }
        case 8:
        {
            BXTAboutUsViewController *aboutUs = [[BXTAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUs animated:YES];
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
