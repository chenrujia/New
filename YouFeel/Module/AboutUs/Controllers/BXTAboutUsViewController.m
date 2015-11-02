//
//  BXTAboutUsViewController.m
//  BXT
//
//  Created by Jason on 15/10/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTAboutUsViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTDataRequest.h"
#import "UIImageView+WebCache.h"

@interface BXTAboutUsViewController ()<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>
{
    UITableView *currentTableView;
    CGFloat headerHeight;
}

@property (nonatomic ,strong) NSDictionary *infoDic;

@end

@implementation BXTAboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    headerHeight = IS_IPHONE6P ? 300.f : 350.f*2.f/3.f;
    
    [self navigationSetting:@"关于我们" andRightTitle:nil andRightImage:nil];
    [self loadingViews];
    
    [self showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request aboutUs];
}

- (void)loadingViews
{
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [currentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
    backView.backgroundColor = [UIColor clearColor];

    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, IS_IPHONE6P ? 35.f : 10.f, 182.f, 63.f)];
    iconView.center = CGPointMake(SCREEN_WIDTH/2.f, iconView.center.y);
    iconView.image = [UIImage imageNamed:@"logo"];
    [backView addSubview:iconView];
    
    UIImageView *qrCodeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(iconView.frame) + (IS_IPHONE6P ? 15.f : 5.f), 90, 90)];
    qrCodeImgView.center = CGPointMake(SCREEN_WIDTH/2.f, qrCodeImgView.center.y);
    [qrCodeImgView sd_setImageWithURL:[NSURL URLWithString:[_infoDic objectForKey:@"img_url"]]];
    [backView addSubview:qrCodeImgView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(qrCodeImgView.frame) + (IS_IPHONE6P ? 15.f : 5.f), 80.f, 20.f)];
    versionLabel.center = CGPointMake(SCREEN_WIDTH/2.f, versionLabel.center.y);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = colorWithHexString(@"909497");
    versionLabel.font = [UIFont systemFontOfSize:14.f];
    versionLabel.text = @"V 1.0.0";
    [backView addSubview:versionLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(versionLabel.frame) + (IS_IPHONE6P ? 15.f : 5.f), 320.f, 20.f)];
    detailLabel.center = CGPointMake(SCREEN_WIDTH/2.f, detailLabel.center.y);
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = colorWithHexString(@"909497");
    detailLabel.font = [UIFont systemFontOfSize:13.f];
    detailLabel.text = @"扫描二维码，您的朋友也可以下载优服报修客户端！";
    [backView addSubview:detailLabel];
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"平台介绍";
    }
    else
    {
        cell.textLabel.text = @"给我评分";
    }
    
    return cell;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    LogRed(@"dic.......%@",dic);
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        NSArray *array = [dic objectForKey:@"data"];
        self.infoDic = array[0];
        [currentTableView reloadData];
    }
    [self hideMBP];
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
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
