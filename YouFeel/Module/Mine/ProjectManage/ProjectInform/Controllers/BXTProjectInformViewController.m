//
//  BXTProjectInformViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTProjectInformViewController.h"
#import "BXTProjectInformTitleCell.h"
#import "BXTProjectInformContentCell.h"
#import "BXTProjectInformAuthorCell.h"

@interface BXTProjectInformViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation BXTProjectInformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"项目详情" andRightTitle:nil andRightImage:nil];
    
    self.dataArray = @[@[@"项目名", @"详情"],
                       @[@"常用位置"],
                       @[@"审核人"] ];
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    CGFloat btnW = (SCREEN_WIDTH - 2 * 15 - 30) / 2;
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(15, 10, btnW, 50);
    [changeBtn setTitle:@"修改信息" forState:UIControlStateNormal];
    changeBtn.backgroundColor = colorWithHexString(@"#5DAEF9");
    changeBtn.layer.cornerRadius = 5;
    [[changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    [footerView addSubview:changeBtn];
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(15 + btnW + 30, 10, btnW, 50);
    [switchBtn setTitle:@"切换至" forState:UIControlStateNormal];
    [switchBtn setTitleColor:colorWithHexString(@"#5DAEF9") forState:UIControlStateNormal];
    switchBtn.layer.borderWidth = 1;
    switchBtn.layer.borderColor = [colorWithHexString(@"#5DAEF9") CGColor];
    switchBtn.layer.cornerRadius = 5;
    [[switchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    [footerView addSubview:switchBtn];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        BXTProjectInformAuthorCell *cell = [BXTProjectInformAuthorCell cellWithTableView:tableView];
        
        
        return cell;
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        BXTProjectInformContentCell *cell = [BXTProjectInformContentCell cellWithTableView:tableView];
        
        
        return cell;
    }
    
    
    BXTProjectInformTitleCell *cell = [BXTProjectInformTitleCell cellWithTableView:tableView];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 140;
    }
    if (indexPath.section == 2) {
        return 117;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
