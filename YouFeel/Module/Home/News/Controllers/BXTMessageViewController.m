//
//  BXTMessageViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/31.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMessageViewController.h"
#import "BXTHeaderForVC.h"
#import "SegmentView.h"
#import "BXTMessageView.h"

@interface BXTMessageViewController ()<UIScrollViewDelegate>

@end

@implementation BXTMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"消息" andRightTitle:nil andRightImage:nil];
    BXTMessageView *messageView = [[BXTMessageView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    [self.view addSubview:messageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
