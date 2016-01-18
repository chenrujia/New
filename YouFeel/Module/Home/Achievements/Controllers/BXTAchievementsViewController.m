//
//  BXTAchievementsViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/14.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTAchievementsViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTDataRequest.h"
#import "BXTAchievementsInfo.h"
#import "BXTArchievementsTableViewCell.h"

@interface BXTAchievementsViewController ()<BXTDataResponseDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *datasource;
    UITableView    *currentTableView;
    NSArray        *imgsArray;
    NSArray        *titlesArray;
}
@end

@implementation BXTAchievementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"绩效" andRightTitle:nil andRightImage:nil];
    [self initContentViews];
    
    datasource = [[NSMutableArray alloc] init];
    imgsArray = @[@"bar_graph",@"chart",@"thumb_up",@"calendar_ok"];
    titlesArray = @[@"接单量",@"完成度",@"好评度",@"月排名"];
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request achievementsList:6];
}

#pragma mark -
#pragma mark 初始化视图
- (void)initContentViews
{
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [currentTableView registerClass:[BXTArchievementsTableViewCell class] forCellReuseIdentifier:@"ArchievementsTableViewCell"];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    currentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 代理
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dictionary = response;
    NSArray *array = [dictionary objectForKey:@"data"];
    for (NSDictionary *dictionary in array)
    {
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTAchievementsInfo class] andConfiguration:config];
        BXTAchievementsInfo *achievementsInfo = [parser parseDictionary:dictionary];
        
        [datasource addObject:achievementsInfo];
    }
    [currentTableView reloadData];
    [self hideMBP];
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.5f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTArchievementsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArchievementsTableViewCell" forIndexPath:indexPath];
    
    BXTAchievementsInfo *info = datasource[indexPath.section];
    if (indexPath.row == 0)
    {
        cell.timeLabel.hidden = NO;
        cell.imgView.hidden = YES;
        cell.nameLabel.hidden = YES;
        cell.dateLabel.hidden = YES;
        cell.timeLabel.text = info.months;
        cell.lineView.frame = CGRectMake(0.f, 49.3f, SCREEN_WIDTH, 0.7f);
    }
    else
    {
        cell.timeLabel.hidden = YES;
        cell.imgView.hidden = NO;
        cell.nameLabel.hidden = NO;
        cell.dateLabel.hidden = NO;
        UIImage *image = [UIImage imageNamed:imgsArray[indexPath.row - 1]];
        cell.imgView.frame = CGRectMake(20.f, (50.f - image.size.height)/2.f, image.size.width, image.size.height);
        cell.imgView.image = image;
        cell.nameLabel.frame = CGRectMake(CGRectGetMaxX(cell.imgView.frame) + 30.f, 15.f, 100.f, 20.f);
        cell.nameLabel.text = titlesArray[indexPath.row - 1];
        
        if (indexPath.row == 1)
        {
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld单",(long)info.workload];
        }
        else if (indexPath.row == 2)
        {
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld%@",(long)info.yes_degree,@"%"];
        }
        else if (indexPath.row == 3)
        {
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld%@",(long)info.praise_degree,@"%"];
        }
        else
        {
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)info.rank_number];
        }
        cell.lineView.frame = CGRectMake(70.f, 49.3f, SCREEN_WIDTH - 50.f, 0.7f);
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
