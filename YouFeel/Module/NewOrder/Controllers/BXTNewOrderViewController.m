//
//  BXTNewOrderViewController.m
//  YouFeel
//
//  Created by Jason on 15/11/12.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTNewOrderViewController.h"
#import "BXTHeaderForVC.h"
#import "UIImageView+WebCache.h"

@interface BXTNewOrderViewController ()

@end

@implementation BXTNewOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"我的新工单" andRightTitle:nil andRightImage:nil];
    [self createLogoView];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createLogoView
{
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, valueForDevice(171.f, 149.f, 117.5f, 89.5f))];
    logoView.userInteractionEnabled = YES;
    logoView.backgroundColor = colorWithHexString(@"09439c");
    [self.view addSubview:logoView];
    
    CGFloat width = valueForDevice(73.f, 73.f, 26.f, 26.f);
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10.f, width, width)];
    headImgView.center = CGPointMake(SCREEN_WIDTH/2.f, headImgView.center.y);
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = width/2.f;
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[BXTGlobal getUserProperty:U_HEADERIMAGE]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    [logoView addSubview:headImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImgView.frame) + (IS_IPHONE6 ? 15 : 10), 130.f, 20.f)];
    nameLabel.center = CGPointMake(SCREEN_WIDTH/2.f, nameLabel.center.y);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = colorWithHexString(@"ffffff");
    nameLabel.font = [UIFont boldSystemFontOfSize:17.f];
    nameLabel.text = [BXTGlobal getUserProperty:U_NAME];
    [logoView addSubview:nameLabel];
    
    UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + (IS_IPHONE6 ? 10 : 7), 130.f, 20.f)];
    groupLabel.center = CGPointMake(SCREEN_WIDTH/2.f, groupLabel.center.y);
    groupLabel.textAlignment = NSTextAlignmentCenter;
    groupLabel.textColor = colorWithHexString(@"ffffff");
    groupLabel.font = [UIFont boldSystemFontOfSize:13.f];
    BXTPostionInfo *postionInfo = [BXTGlobal getUserProperty:U_POSITION];
    BXTGroupingInfo *groupInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
    groupLabel.text = [NSString stringWithFormat:@"%@-%@",groupInfo.subgroup,postionInfo.role];
    [logoView addSubview:groupLabel];
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
