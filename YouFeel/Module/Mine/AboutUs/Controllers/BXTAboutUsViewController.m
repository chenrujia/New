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
    
    headerHeight = IS_IPHONE6P ? 300.f+60.f : 350.f*2.f/3.f+60.f;
    
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
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, IS_IPHONE6P ? 45.f : 30.f, 182.f, 63.f)];
    iconView.center = CGPointMake(SCREEN_WIDTH/2.f, iconView.center.y);
    iconView.image = [UIImage imageNamed:@"logo"];
    [backView addSubview:iconView];
    
    UIImageView *qrCodeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(iconView.frame) + (IS_IPHONE6P ? 15.f : 5.f), 120, 120)];
    qrCodeImgView.center = CGPointMake(SCREEN_WIDTH/2.f, qrCodeImgView.center.y);
    [qrCodeImgView sd_setImageWithURL:[NSURL URLWithString:[_infoDic objectForKey:@"img_url"]]];
    qrCodeImgView.layer.masksToBounds = YES;
    qrCodeImgView.layer.cornerRadius = qrCodeImgView.bounds.size.width/2;
    [backView addSubview:qrCodeImgView];
    
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(qrCodeImgView.frame) + (IS_IPHONE6P ? 15.f : 5.f), 80.f, 20.f)];
    versionLabel.center = CGPointMake(SCREEN_WIDTH/2.f, versionLabel.center.y);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = colorWithHexString(@"909497");
    versionLabel.font = [UIFont systemFontOfSize:14.f];
    versionLabel.text = [NSString stringWithFormat:@"v %@", IOSSHORTAPPVERSION];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = @"给我评分";
    cell.textLabel.font = [UIFont systemFontOfSize:17.f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_APPADDRESS]];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
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

- (void)showAlertView:(NSString *)title
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertCtr addAction:doneAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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
