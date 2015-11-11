//
//  BXTExaminationViewController.m
//  BXT
//
//  Created by Jason on 15/10/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTExaminationViewController.h"
#import "BXTHeaderForVC.h"
#import "DOPDropDownMenu.h"

#define NavBarHeight 105.f

@interface BXTExaminationViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    NSMutableArray *launchArray;
    NSMutableArray *examineArray;
}
@end

@implementation BXTExaminationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting];
    [self createDOP];
}

#pragma mark -
#pragma mark 初始化视图
- (void)navigationSetting
{
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBarHeight)];
    if ([BXTGlobal shareGlobal].isRepair)
    {
        naviView.image = [[UIImage imageNamed:@"Nav_Bars"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    }
    else
    {
        naviView.image = [[UIImage imageNamed:@"Nav_Bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    }    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UIButton * nav_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];
    nav_leftButton.backgroundColor = [UIColor clearColor];
    [nav_leftButton setImage:[UIImage imageNamed:@"Aroww_left"] forState:UIControlStateNormal];
    [nav_leftButton setImage:[UIImage imageNamed:@"Aroww_left_selected"] forState:UIControlStateNormal];
    [nav_leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:nav_leftButton];
    
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.backgroundColor = [UIColor clearColor];
    navi_titleLabel.font = [UIFont systemFontOfSize:18];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = [NSString stringWithFormat:@"审批"];
    [naviView addSubview:navi_titleLabel];
}

- (void)createDOP
{
    launchArray = [NSMutableArray arrayWithObjects:@"我发起的",@"未审批",@"已审批", nil];
    examineArray = [NSMutableArray arrayWithObjects:@"我审批的",@"未审批",@"已审批", nil];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
}

#pragma mark -
#pragma mark 代理
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0)
    {
        return launchArray.count;
    }
    else
    {
        return examineArray.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        return launchArray[indexPath.row];
    }
    else
    {
        return examineArray[indexPath.row];
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
