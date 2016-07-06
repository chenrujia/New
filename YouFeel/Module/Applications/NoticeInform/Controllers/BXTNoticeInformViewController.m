//
//  BXTNoticeInformViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTNoticeInformViewController.h"

@interface BXTNoticeInformViewController () <UIWebViewDelegate>

@end

@implementation BXTNoticeInformViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = colorWithHexString(@"eff3f6");
    
    
    [self navigationSetting:self.titleStr andRightTitle:nil andRightImage:nil];
    
    
    [BXTGlobal showLoadingMBP:@"加载中..."];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    NSString *urlStr = self.urlStr;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSLog(@"%@", urlStr);
}

- (void)navigationLeftButton
{
    if (self.delegateSignal)
    {
        [self.delegateSignal sendNext:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 设置导航条
- (UIImageView *)navigationSetting:(NSString *)title
                     andRightTitle:(NSString *)right_title
                     andRightImage:(UIImage *)image
{
    // naviView
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNAVIVIEWHEIGHT)];
    naviView.tag = KNavViewTag;
    NSString *naviImageStr = @"Nav_Bar";
    if (self.pushType == PushType_OA)
    {
        naviImageStr = @"Nav_Bar_OA";
    }
    naviView.image = [[UIImage imageNamed:naviImageStr] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    
    // navi_titleLabel
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.font = [UIFont systemFontOfSize:18.f];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = title;
    [naviView addSubview:navi_titleLabel];
    
    
    // navi_left
    UIButton *navi_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(0, 20, 44, 44);
    NSString *leftBtnImageStr = @"arrowBack";
    if (self.pushType == PushType_OA) {
        rect = CGRectMake(10, 20, 60, 44);
        leftBtnImageStr = @"shut_down";
    }
    navi_leftButton.frame = rect;
    [navi_leftButton setImage:[UIImage imageNamed:leftBtnImageStr] forState:UIControlStateNormal];
    [navi_leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:navi_leftButton];
    
    
    // nav_right
    if (right_title == nil && image == nil) {
        return nil;
    }
    
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

#pragma mark -
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [BXTGlobal hideMBP];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [BXTGlobal hideMBP];
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
