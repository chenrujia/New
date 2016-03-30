//
//  BXTRepairsListViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTRepairsListViewController.h"

@interface BXTRepairsListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *arrow;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *isShowArray;

@end

@implementation BXTRepairsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"人员列表" andRightTitle:nil andRightImage:nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.isShowArray = [[NSMutableArray alloc] initWithObjects:@"1", nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.isShowArray[section] isEqualToString:@"1"]) {
        return  1;
    }
    return  0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
//    cell.textLabel.text = self.dataArray[indexPath.section];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dataDict = self.dataArray[indexPath.section];
//    NSArray *workloadArray = dataDict[@"workload"];
//    CGFloat viViewH = (workloadArray.count-1) * (bgViewH+Margin) + 150;
//    return viViewH;
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld - %ld", (long)indexPath.section, (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"headerTitle";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataArray[section];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = section;
    btn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    btn.layer.borderWidth = 0.5;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 21)];
    title.text = dict[@"subgroup"];
    title.textColor = colorWithHexString(@"#666666");
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:15];
    [btn addSubview:title];
    
    arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 18.5, 15, 8)];
    arrow.image = [UIImage imageNamed:@"down_arrow_gray"];
    if ([self.isShowArray[section] isEqualToString:@"1"])
    {
        arrow.image = [UIImage imageNamed:@"up_arrow_gray"];
    }
    [btn addSubview:arrow];
    
    return btn;
}

#pragma mark -
#pragma mark - viewForHeader点击事件
- (void)btnClick:(UIButton *)btn
{
    // 改变组的显示状态
    if ([self.isShowArray[btn.tag] isEqualToString:@"1"])
    {
        [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"0"];
    }
    else
    {
        [self.isShowArray replaceObjectAtIndex:btn.tag withObject:@"1"];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
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
