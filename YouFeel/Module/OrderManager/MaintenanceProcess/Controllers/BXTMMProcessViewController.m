//
//  BXTMMProcessViewController.m
//  YouFeel
//
//  Created by Jason on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMMProcessViewController.h"
#import "BXTPhotosTableViewCell.h"
#import "BXTMMLogTableViewCell.h"
#import "BXTSettingTableViewCell.h"
#import "BXTFaultInfo.h"

@interface BXTMMProcessViewController ()<BXTDataResponseDelegate>
{
    BOOL  isDone;//是否修好的状态
}

@property (nonatomic, strong) NSMutableArray *fau_dataSource;
@property (nonatomic, strong) NSString *repairID;

@end

@implementation BXTMMProcessViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil repairID:(NSString *)repairID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.repairID = repairID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维修过程" andRightTitle:nil andRightImage:nil];
    
    [self.currentTable registerClass:[BXTPhotosTableViewCell class] forCellReuseIdentifier:@"PhotosCell"];
    [self.currentTable registerClass:[BXTMMLogTableViewCell class] forCellReuseIdentifier:@"LogCell"];
    [self.currentTable registerClass:[BXTSettingTableViewCell class] forCellReuseIdentifier:@"NormalCell"];
    
    self.fau_dataSource = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_queue_create("NormalQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        /**请求故障类型列表**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request faultTypeListWithRTaskType:@"all"];
    });
}

- (IBAction)doneClick:(id)sender
{
    
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((isDone && (indexPath.section == 2 || indexPath.section == 3)) || (!isDone && (indexPath.section == 4 || indexPath.section == 5)))
    {
        return 110;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!isDone)
    {
        return 7;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //维修记录
    if ((!isDone && indexPath.section == 4) || (isDone && indexPath.section == 2))
    {
        BXTMMLogTableViewCell *logCell = [tableView dequeueReusableCellWithIdentifier:@"LogCell" forIndexPath:indexPath];
        
        logCell.titleLabel.text = @"维修记录";
        
        return logCell;
    }
    //维修后图片
    else if ((!isDone && indexPath.section == 5) || (isDone && indexPath.section == 3))
    {
        BXTPhotosTableViewCell *photosCell = [tableView dequeueReusableCellWithIdentifier:@"PhotosCell" forIndexPath:indexPath];
        
        photosCell.titleLabel.text = @"维修后图片";
        
        return photosCell;
    }
    //其他
    else
    {
        BXTSettingTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
        
        normalCell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        
        return normalCell;
    }
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == FaultType)
    {
        [BXTFaultInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"fault_id":@"id"};
        }];
        [self.fau_dataSource addObjectsFromArray:[BXTFaultInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    else if (type == MaintenanceProcess)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestDetail" object:nil];
            __weak typeof(self) weakSelf = self;
            [self showMBP:@"更改成功！" withBlock:^(BOOL hidden) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"041"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestDetail" object:nil];
            __weak typeof(self) weakSelf = self;
            [self showMBP:@"工单已被处理！" withBlock:^(BOOL hidden) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
