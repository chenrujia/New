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
    
    [self navigationSetting:@"审批" andRightTitle:nil andRightImage:nil];
    [self createImageView];
}

#pragma mark -
#pragma mark 初始化视图
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

- (void)createImageView
{
    UIImage *image = nil;
    if (IS_IPHONE6P)
    {
        image = [UIImage imageNamed:@"shenpiplus"];
    }
    else if (IS_IPHONE6)
    {
        image = [UIImage imageNamed:@"shenpi6"];
    }
    else if (IS_IPHONE5)
    {
        image = [UIImage imageNamed:@"shenpi5"];
    }
    else
    {
        image = [UIImage imageNamed:@"shenpi"];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0,KNAVIVIEWHEIGHT + 30.f, image.size.width, image.size.height);
    imageView.center = CGPointMake(SCREEN_WIDTH/2.f, imageView.center.y);
    [self.view addSubview:imageView];
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openBtn.frame = CGRectMake(20,CGRectGetMaxY(imageView.frame) + 40, SCREEN_WIDTH - 40, 50.f);
    [openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
    [openBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [openBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    openBtn.layer.masksToBounds = YES;
    openBtn.layer.cornerRadius = 6.f;
    @weakify(self);
    [[openBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", @"4008937878"];
        UIWebView *callWeb = [[UIWebView alloc] init];
        [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
        [self.view addSubview:callWeb];
    }];
    [self.view addSubview:openBtn];
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource
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
