//
//  BXTNoticeInformViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTNoticeInformViewController.h"

@interface BXTNoticeInformViewController ()

@end

@implementation BXTNoticeInformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self navigationSetting:@"公告详情" andRightTitle:nil andRightImage:nil];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    webView.scalesPageToFit = YES;
    NSURL *urlStr = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
    [webView loadRequest:request];
    
    NSLog(@"%@", self.urlStr);
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
