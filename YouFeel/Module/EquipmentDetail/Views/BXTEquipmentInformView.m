//
//  EquipmentInformView.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTEquipmentInformView.h"
#import "BXTHeaderForVC.h"
#import "BXTEquipmentInformCell.h"

@interface BXTEquipmentInformView () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>
{
    UIImageView *arrow;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *headerTitleArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *isShowArray;

@end

@implementation BXTEquipmentInformView

#pragma mark -
#pragma mark - 初始化
- (void)initial
{
    self.dataArray = [[NSArray alloc] init];
    self.headerTitleArray = @[@"", @"基本信息", @"厂家信息", @"设备参数", @"设备负责人"];
    self.titleArray = @[@[@"设备名称", @"设备编号"],  @[@"设备型号", @"设备分类", @"设备品牌", @"安装位置", @"服务区域", @"接管日期", @"启用日期"], @[@"品牌", @"厂家", @"地址", @"联系人", @"联系电话"], @[@"工作电压", @"额定电流", @"输出功率", @"扬程", @"流量"], @[@"负责人"]];
    self.isShowArray = [[NSMutableArray alloc] init];
    for (int i=0; i<=self.headerTitleArray.count-1; i++)
    {
        [self.isShowArray addObject:@"0"];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    
    [self showLoadingMBP:@"数据加载中..."];
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request equipmentWithDeviceID:@"1"];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headerTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        NSArray *numArray = self.titleArray[section];
        return numArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    BXTEquipmentInformCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTEquipmentInformCell" owner:nil options:nil] lastObject];
    }
    
    cell.titleView.text = [NSString stringWithFormat:@"%@:", self.titleArray[indexPath.section][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"headerTitle";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [UIView new];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = section;
    btn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    btn.layer.borderWidth = 0.5;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 改变组的显示状态
        if ([self.isShowArray[btn.tag] isEqualToString:@"1"]) {
            [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"0"];
        } else  {
            [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"1"];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 14.5, 100, 21)];
    title.text = self.headerTitleArray[section];
    title.textColor = colorWithHexString(@"#666666");
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:15];
    [btn addSubview:title];
    
    arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 21, 15, 8)];
    arrow.image = [UIImage imageNamed:@"down_arrow_gray"];
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        arrow.image = [UIImage imageNamed:@"up_arrow_gray"];
    }
    [btn addSubview:arrow];
    
    
    return btn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == Device_Con && data.count > 0)
    {
        self.dataArray = data;
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

@end
