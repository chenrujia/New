//
//  BXTBaseViewController.m
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTHeaderFile.h"
#import "MBProgressHUD.h"
#import "BXTProjectManageViewController.h"

@interface BXTBaseViewController () <MBProgressHUDDelegate>

@end

@implementation BXTBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = colorWithHexString(@"eff3f6");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark -
#pragma mark 设置导航条
- (UIImageView *)navigationSetting:(NSString *)title
                     andRightTitle:(NSString *)right_title
                     andRightImage:(UIImage *)image
{
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNAVIVIEWHEIGHT)];
    naviView.tag = KNavViewTag;
    
    naviView.image = [[UIImage imageNamed:@"Nav_Bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.font = [UIFont systemFontOfSize:18.f];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = title;
    [naviView addSubview:navi_titleLabel];
    
    UINavigationController *navigation = self.navigationController;
    if (navigation.viewControllers.count > 1 || _isRepairList || _isNewWorkOrder)
    {
        UIButton *navi_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        navi_leftButton.frame = CGRectMake(0, 20, 44, 44);
        [navi_leftButton setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
        [navi_leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [naviView addSubview:navi_leftButton];
    }
    
    if (right_title == nil && image == nil) return nil;
    
    UIButton * nav_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nav_rightButton.frame = CGRectMake(SCREEN_WIDTH - 75, 20, 70, 44);
    if (image)
    {
        [nav_rightButton setImage:image forState:UIControlStateNormal];
    }
    else
    {
        [nav_rightButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [nav_rightButton setTitle:right_title forState:UIControlStateNormal];
    }
    [nav_rightButton setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [nav_rightButton addTarget:self action:@selector(navigationRightButton) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:nav_rightButton];
    
    return naviView;
}

- (void)navigationLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightButton
{
    
}

- (void)showMBP:(NSString *)text withBlock:(HaveHidden)block
{
    //把其余的都隐藏了
    [self hideMBP];
    _havedHidden = block;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.delegate = self;
    hud.removeFromSuperViewOnHide = YES;
    [self performSelector:@selector(hideMBP) withObject:nil afterDelay:2.f];
}

- (void)showLoadingMBP:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.delegate = self;
    hud.removeFromSuperViewOnHide = YES;
}

- (void)hideMBP
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (_havedHidden)
    {
        _havedHidden(YES);
        _havedHidden = nil;
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
}

- (NSString *)dataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (id)toArrayOrNSDictionary:(NSData *)jsonData
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil)
    {
        return jsonObject;
    }
    else
    {
        // 解析错误
        return nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
