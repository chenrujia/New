//
//  BXTEPFilterViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEPFilterViewController.h"

@interface BXTEPFilterViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat bgViewY;

@end

@implementation BXTEPFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"筛选条件" andRightTitle:nil andRightImage:nil];
    self.bgViewY = 0;
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self createSettingLocation];
    [self createMaintenanceCycle];
    [self createSystemGroup];
    [self createEquipmentStatus];
    
}

- (void)createSettingLocation
{
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 30)];
    detailLabel.text = @"安装位置:";
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.textColor = colorWithHexString(@"#666666");
    // footerViewH   self.bgViewY
    CGFloat footerViewH = 50;
    [[self createBgViewWithTitle:@"安装位置" FooterViewHeight:footerViewH FooterViewY:self.bgViewY] addSubview:detailLabel];
    self.bgViewY += 50 + footerViewH + 10;
}

- (void)createMaintenanceCycle
{
    // footerViewH   self.bgViewY
    CGFloat footerViewH = 50;
    UIView *bgView = [self createBgViewWithTitle:@"维保周期" FooterViewHeight:footerViewH FooterViewY:self.bgViewY];
    self.bgViewY += 50 + footerViewH + 10;
    
    // UIButton
    NSArray *titleArray = @[@"月保", @"季保", @"半年保", @"年保"];
    [self createButtonViewWithArray:titleArray bgView:bgView];
}

- (void)createSystemGroup
{
    // footerViewH   self.bgViewY
    CGFloat footerViewH = 50;
    UIView *bgView = [self createBgViewWithTitle:@"系统分组" FooterViewHeight:footerViewH FooterViewY:self.bgViewY];
    self.bgViewY += 50 + footerViewH + 10;
    
    // UIButton
    NSArray *titleArray = @[@"消防系统", @"空调系统", @"弱电系统", @"AAA系统"];
    [self createButtonViewWithArray:titleArray bgView:bgView];
}

- (void)createEquipmentStatus
{
    // footerViewH   self.bgViewY
    CGFloat footerViewH = 50;
    UIView *bgView = [self createBgViewWithTitle:@"设备状态" FooterViewHeight:footerViewH FooterViewY:self.bgViewY];
    
    // UIButton
    NSArray *titleArray = @[@"全部", @"故障", @"正常"];
    [self createButtonViewWithArray:titleArray bgView:bgView];
}

/** ---- 创建bgView，返回footerView ---- */
- (UIView *)createBgViewWithTitle:(NSString *)titleStr FooterViewHeight:(CGFloat)footerViewH FooterViewY:(CGFloat)footerViewY
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, footerViewY, SCREEN_WIDTH, 50 + footerViewH)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = colorWithHexString(@"#333333");
    [bgView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = colorWithHexString(@"#d9d9d9");
    [bgView addSubview:lineView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, footerViewH)];
    [bgView addSubview:footerView];
    
    return footerView;
}

/** ---- 创建UIButton ---- */
- (void)createButtonViewWithArray:(NSArray *)titleArray bgView:(UIView *)bgView
{
    CGFloat btnW = (SCREEN_WIDTH - (titleArray.count + 1)*10) / titleArray.count;
    for (int i=0; i<titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + i*(btnW+10), 10, btnW, 30);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = colorWithHexString(@"#d9d9d9");
        button.layer.cornerRadius = 5;
        __block BOOL isSelected = NO;
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (!isSelected) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor = colorWithHexString(@"#3BAFFF");
                isSelected = YES;
            }
            else {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button.backgroundColor = colorWithHexString(@"#d9d9d9");
                isSelected = NO;
            }
        }];
        [bgView addSubview:button];
    }
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
