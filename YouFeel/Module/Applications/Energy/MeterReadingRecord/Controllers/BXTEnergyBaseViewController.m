//
//  BXTEnergyBaseViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyBaseViewController.h"

@interface BXTEnergyBaseViewController ()

@end

@implementation BXTEnergyBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = colorWithHexString(@"#E36760");
}

#pragma mark -
#pragma mark 设置导航条
- (void)navigationSetting:(NSString *)title
           andRightTitle1:(NSString *)right_title1
           andRightImage1:(UIImage *)image1
           andRightTitle2:(NSString *)right_title2
           andRightImage2:(UIImage *)image2
{
    // navView
    UIView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNAVIVIEWHEIGHT)];
    navView.backgroundColor = [UIColor clearColor];
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [navView addSubview:titleLabel];
    
    
    // leftButton
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 20, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftButton];
    
    
    if (!(image1 || right_title1)) {
        return;
    }
    // rightButton1
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setFrame:CGRectMake(SCREEN_WIDTH - 64.f - 5.f, 20, 64.f, 44.f)];
    if (image1) {
        rightButton1.frame = CGRectMake(SCREEN_WIDTH - 44.f - 5.f, 20, 44.f, 44.f);
        [rightButton1 setImage:image1 forState:UIControlStateNormal];
    } else {
        [rightButton1 setTitle:right_title1 forState:UIControlStateNormal];
    }
    rightButton1.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [rightButton1 addTarget:self action:@selector(navigationRightButton1) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightButton1];
    
    
    if (!(image2 || right_title2)) {
        return;
    }
    // rightButton2
    UIButton *rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setFrame:CGRectMake(CGRectGetMinX(rightButton1.frame) - 65, 20, 64.f, 44.f)];
    if (image2) {
        [rightButton2 setImage:image2 forState:UIControlStateNormal];
    } else {
        [rightButton2 setTitle:right_title2 forState:UIControlStateNormal];
    }
    rightButton2.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [rightButton2 addTarget:self action:@selector(navigationRightButton2) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightButton2];
}

- (void)navigationLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightButton1
{
    
}

- (void)navigationRightButton2
{
    
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
