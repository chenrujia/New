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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.pushType == PushType_Ads || self.pushType == PushType_Project) {
        [self navigationSetting:self.titleStr andRightTitle:nil andRightImage:nil];
    }
    else {
        [self navigationSetting:@"公告详情" andRightTitle:nil andRightImage:nil];
    }
    
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    NSString *urlStr = self.urlStr;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSLog(@"%@", self.urlStr);
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
