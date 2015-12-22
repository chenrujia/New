//
//  BXTLoadingViewController.m
//  YouFeel
//
//  Created by Jason on 15/12/22.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTLoadingViewController.h"
#import "BXTPublicSetting.h"

@interface BXTLoadingViewController ()

@end

@implementation BXTLoadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *tempValue = @"Default_iphone4";
    if (IS_IPHONE6P)
    {
        tempValue = @"Default_plus";
    }
    else if (IS_IPHONE6)
    {
        tempValue = @"Default_iphone6";
    }
    else if (IS_IPHONE5)
    {
        tempValue = @"Default_iphone5";
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:tempValue];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
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
