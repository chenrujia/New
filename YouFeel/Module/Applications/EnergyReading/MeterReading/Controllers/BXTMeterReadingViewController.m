//
//  BXTMeterReadingViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingViewController.h"
#import "BXTMeterReadingHeaderCell.h"
#import "BXTMeterReadingListCell.h"
#import "BXTQRCodeViewController.h"
#import "BXTMeterReadingInfo.h"

@interface BXTMeterReadingViewController () <UITableViewDelegate, UITableViewDataSource, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) BXTMeterReadingInfo *meterReadingInfo;
@property (nonatomic, strong) BXTMeterReadingLastList *lastList;

@end

@implementation BXTMeterReadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"新建抄表" andRightTitle1:@"扫描解锁" andRightImage1:nil andRightTitle2:nil andRightImage2:nil];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", nil];
    
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    /**新建抄表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterDetailWithID:self.transID];
    
    [self createUI];
}

- (void)navigationRightButton1
{
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    BXTQRCodeViewController *qrcVC = [[BXTQRCodeViewController alloc] init];
    qrcVC.style = style;
    qrcVC.isQQSimulator = YES;
    qrcVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrcVC animated:YES];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // footerView
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerView];
    
    UIButton *cancelBtn = [self createButtonWithTitle:@"取消" btnX:10 tilteColor:@"#AEB4BB"];
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    [self.footerView addSubview:cancelBtn];
    
    UIButton *commitBtn = [self createButtonWithTitle:@"提交" btnX:SCREEN_WIDTH / 2 + 5  tilteColor:@"#5DAFF9"];
    [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    [self.footerView addSubview:commitBtn];
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
    if (indexPath.section == 0) {
        BXTMeterReadingHeaderCell *cell = [BXTMeterReadingHeaderCell cellWithTableView:tableView];
        
        cell.backgroundColor = colorWithHexString(@"#E36760");
        cell.meterReadingInfo = self.meterReadingInfo;
        
        return cell;
    }
    
    BXTMeterReadingListCell *cell = [BXTMeterReadingListCell cellWithTableView:tableView];
    
    cell.backgroundColor = colorWithHexString(@"#E36760");
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }
    return 175;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == EnergyMeterDetail && data.count > 0)
    {
        [BXTMeterReadingInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"meterReadingID":@"id"};
        }];
        self.meterReadingInfo = [BXTMeterReadingInfo mj_objectWithKeyValues:data[0]];
        self.lastList = self.meterReadingInfo.last;
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

#pragma mark -
#pragma mark - other
- (UIButton *)createButtonWithTitle:(NSString *)titleStr btnX:(CGFloat)btnX tilteColor:(NSString *)colorStr
{
    UIButton *newMeterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newMeterBtn.frame = CGRectMake(btnX, 10, (SCREEN_WIDTH - 30) / 2, 50);
    [newMeterBtn setBackgroundColor:colorWithHexString(colorStr)];
    [newMeterBtn setTitle:titleStr forState:UIControlStateNormal];
    newMeterBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    newMeterBtn.layer.cornerRadius = 5;
    
    return newMeterBtn;
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
