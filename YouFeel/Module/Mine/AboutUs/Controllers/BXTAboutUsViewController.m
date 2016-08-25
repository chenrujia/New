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
#import "BXTNoticeInformViewController.h"

@interface BXTAboutUsViewController ()<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic ,strong) NSDictionary *infoDic;

/** ---- 服务协议url ---- */
@property (nonatomic, copy) NSString *transUrl;

@end

@implementation BXTAboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"关于我们" andRightTitle:nil andRightImage:nil];
    
    [self createUI];
    
    [self showLoadingMBP:@"加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        // 关于我们
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request aboutUs];
    });
    dispatch_async(concurrentQueue, ^{
        // 服务协议
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request serviceAgreement];
    });
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    self.headerHeight = IS_IPHONE6P ? 300.f+50.f : 350.f*2.f/3.f+50.f;
    self.dataArray = @[@"去评分", @"新功能介绍", @"服务协议"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.rowHeight = 50.f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.dataArray[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:17.f];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.headerHeight)];
        backView.backgroundColor = [UIColor clearColor];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, IS_IPHONE6P ? 45.f : 30.f, 150.f, 50.f)];
        iconView.center = CGPointMake(SCREEN_WIDTH/2.f, iconView.center.y);
        iconView.image = [UIImage imageNamed:@"logo"];
        [backView addSubview:iconView];
        
        UIImageView *qrCodeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(iconView.frame) + (IS_IPHONE6P ? 15.f : 5.f), 120, 120)];
        qrCodeImgView.center = CGPointMake(SCREEN_WIDTH/2.f, qrCodeImgView.center.y);
        [qrCodeImgView sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"img_url"]]];
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
        detailLabel.text = @"扫描二维码，您的朋友也可以下载优服管理客户端！";
        [backView addSubview:detailLabel];
        
        return backView;
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headerHeight;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_APPADDRESS]];
    }
    if (indexPath.section == 1) {
        [self loadingGuideView];
    }
    if (indexPath.section == 2) {
        BXTNoticeInformViewController *nivc = [[BXTNoticeInformViewController alloc] init];
        nivc.titleStr = @"服务协议";
        nivc.urlStr = self.transUrl;
        [self.navigationController pushViewController:nivc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if (type == AboutUs && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [self hideMBP];
        
        NSArray *array = [dic objectForKey:@"data"];
        self.infoDic = array[0];
        
        [self.tableView reloadData];
    }
    else if (type == ServiceAgreement && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        NSArray *array = [dic objectForKey:@"data"];
        NSDictionary *subDict = array[0];
        self.transUrl = subDict[@"url"];
        
        [self.tableView reloadData];
    }
    
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

#pragma mark -
#pragma mark - Other
- (void)loadingGuideView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    
    NSString *tempValue = @"iphone4";
    if (IS_IPHONE6P)
    {
        tempValue = @"plus";
    }
    else if (IS_IPHONE6)
    {
        tempValue = @"iphone6";
    }
    else if (IS_IPHONE5)
    {
        tempValue = @"iphone5";
    }
    
    for (NSInteger i = 1; i < 6; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i - 1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%ld_%@",(long)i,tempValue]];
        [scrollView addSubview:imageView];
        
        if (i == 5)
        {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
            [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
                [scrollView removeFromSuperview];
            }];
            [imageView addGestureRecognizer:tapGesture];
        }
    }
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
