//
//  BXTAddOtherManViewController.m
//  BXT
//
//  Created by Jason on 15/9/22.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTAddOtherManViewController.h"
#import "BXTHeaderForVC.h"
#import "DOPDropDownMenu.h"
#import "BXTDataRequest.h"
#import "BXTAddOtherManInfo.h"
#import "BXTAddOtherManTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface BXTAddOtherManViewController ()<UITableViewDelegate,UITableViewDataSource,BXTDataResponseDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    UITableView    *currentTableView;
    NSMutableArray *departmentsArray;
    NSMutableArray *dataSource;
    UIView         *singleView;
    NSInteger      number;
    NSMutableArray *selectMans;
    NSInteger      repairID;
    ControllerType vcType;
    BOOL           isHave;
    NSMutableArray *listArray;
    NSMutableArray *indexArray;
}

@property (nonatomic ,copy) ChooseMans choosedMans;

@end

@implementation BXTAddOtherManViewController

- (instancetype)initWithRepairID:(NSInteger)repair_id
                   andWithVCType:(ControllerType)vc_type
{
    self = [super init];
    if (self)
    {
        number = 0;
        repairID = repair_id;
        vcType = vc_type;
    }
    return self;
}

- (void)didChoosedMans:(ChooseMans)mans
{
    self.choosedMans = mans;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:vcType == AssignType ? @"指派工单" : @"增加人员" andRightTitle:nil andRightImage:nil];
    [self createTableView];
    
    dataSource = [NSMutableArray array];
    selectMans = [NSMutableArray array];
    listArray = [NSMutableArray array];
    indexArray = [NSMutableArray array];
    
    [self showLoadingMBP:@"努力加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**请求维修员列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request maintenanceManList:@""];
    });
    dispatch_async(concurrentQueue, ^{
        /**请求职位列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request propertyGrouping];
    });
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    departmentsArray = [NSMutableArray arrayWithObjects:@"分组", nil];
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 44) style:UITableViewStylePlain];
    currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [currentTableView registerClass:[BXTAddOtherManTableViewCell class] forCellReuseIdentifier:@"OtherManCell"];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 事件处理
- (void)addMan:(UIButton *)btn
{
    for (NSString *indexStr in indexArray)
    {
        if (btn.tag == [indexStr intValue])
        {
            return;
        }
    }
    
    btn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;;
    
    BXTAddOtherManInfo *manInfo = dataSource[btn.tag];
    if ([selectMans containsObject:manInfo])
    {
        if (manInfo.manID == [[BXTGlobal getUserProperty:U_BRANCHUSERID] integerValue])
        {
            return;
        }
        number--;
        [selectMans removeObject:manInfo];
        if (selectMans.count == 0)
        {
            [UIView animateWithDuration:0.3f animations:^{
                singleView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60.f);
                currentTableView.frame = CGRectMake(0, KNAVIVIEWHEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 44);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else
    {
        number++;
        if (selectMans.count == 0)
        {
            [UIView animateWithDuration:0.3f animations:^{
                singleView.frame = CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60.f);
                currentTableView.frame = CGRectMake(0, KNAVIVIEWHEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 44-60);
            } completion:^(BOOL finished) {
                
            }];
        }
        [selectMans addObject:manInfo];
    }
    [currentTableView reloadData];
    
    if (singleView == nil)
    {
        singleView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60.f)];
        singleView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
        [self.view addSubview:singleView];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 20, 180.f, 20)];
        numberLabel.tag = 2;
        numberLabel.textColor = colorWithHexString(@"ffffff");
        numberLabel.font = [UIFont systemFontOfSize:16.f];
        long sumNum = number - 1;
        if (vcType == AssignType) {
            sumNum = number;
        }
        numberLabel.text = [NSString stringWithFormat:@"当前已添加:%ld人", sumNum];
        [singleView addSubview:numberLabel];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        doneBtn.backgroundColor = [UIColor whiteColor];
        doneBtn.layer.cornerRadius = 4.f;
        [doneBtn setFrame:CGRectMake(SCREEN_WIDTH - 100.f - 15.f, 10.f, 100.f, 40.f)];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [singleView addSubview:doneBtn];
        
        [UIView animateWithDuration:0.3f animations:^{
            singleView.frame = CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60.f);
            currentTableView.frame = CGRectMake(0, KNAVIVIEWHEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 44-60);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        UILabel *numberLabel = (UILabel *)[singleView viewWithTag:2];
        long sumNum = number - 1;
        if (vcType == AssignType) {
            sumNum = number;
        }
        numberLabel.text = [NSString stringWithFormat:@"当前已添加:%ld人", sumNum];
    }
}

- (void)doneClick
{
    if (vcType == AssignType)
    {
        [self showLoadingMBP:@"请稍候..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        NSString *userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
        [request reaciveOrderID:[NSString stringWithFormat:@"%ld",(long)repairID]
                    arrivalTime:@""
                      andUserID:userID
                       andUsers:[self selectMans]
                      andIsGrad:NO];
    }
    else if (vcType == DetailType)
    {
        [self showLoadingMBP:@"请稍候..."];
        /**请求维修员列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request dispatchingMan:[NSString stringWithFormat:@"%ld",(long)repairID] andMans:[self selectMans]];
    }
    else
    {
        _choosedMans(selectMans);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSArray *)selectMans
{
    NSMutableArray *selectManIDs = [NSMutableArray array];
    if (!isHave && vcType != AssignType)
    {
        [selectManIDs addObject:[BXTGlobal getUserProperty:U_BRANCHUSERID]];
    }
    
    // 现在加入人员ID
    for (BXTAddOtherManInfo *otherManInfo in selectMans)
    {
        [selectManIDs addObject:[NSString stringWithFormat:@"%ld",(long)otherManInfo.manID]];
    }
    
    // 以前人员ID
    [selectManIDs addObjectsFromArray:self.manIDArray];
    
    // 去重
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < selectManIDs.count; i++){
        if (![categoryArray containsObject:selectManIDs[i]]){
            [categoryArray addObject:selectManIDs[i]];
        }
    }
    
    // 指派工单 去除自己
    if (vcType == AssignType) {
        if ([categoryArray containsObject:[BXTGlobal getUserProperty:U_BRANCHUSERID]]) {
            [categoryArray removeObject:[BXTGlobal getUserProperty:U_BRANCHUSERID]];
        }
    }
    
    return categoryArray;
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    BXTAddOtherManTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BXTAddOtherManTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BXTAddOtherManInfo *otherManInfo = dataSource[indexPath.row];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:otherManInfo.head_pic] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    cell.userName.text = otherManInfo.name;
    cell.detailName.text = [NSString stringWithFormat:@"%@-%@",otherManInfo.department,otherManInfo.subgroup_name];
    
    cell.addBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    for (BXTAddOtherManInfo *manInfo in selectMans)
    {
        if (manInfo.manID == otherManInfo.manID)
        {
            cell.addBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            break;
        }
    }
    for (NSString *manID in self.manIDArray) {
        if ([manID integerValue] == otherManInfo.manID)
        {
            cell.addBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            break;
        }
    }
    
    cell.addBtn.tag = indexPath.row;
    [cell.addBtn addTarget:self action:@selector(addMan:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

#pragma mark -
#pragma mark DOPDropDownMenuDataSource & DOPDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return departmentsArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return [departmentsArray objectAtIndex:indexPath.row];
    }
    else
    {
        BXTGroupingInfo *groupInfo = departmentsArray[indexPath.row];
        return groupInfo.subgroup;
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    [self showLoadingMBP:@"努力加载中..."];
    if (indexPath.row == 0)
    {
        /**请求维修员列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request maintenanceManList:@""];
    }
    else
    {
        BXTGroupingInfo *groupInfo = departmentsArray[indexPath.row];
        /**请求维修员列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request maintenanceManList:groupInfo.group_id];
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == PropertyGrouping)
    {
        if (data.count == 0) return;
        for (NSDictionary *dictionary in data)
        {
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"group_id" onClass:[BXTGroupingInfo class]];
            [config addObjectMapping:text];
            
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTGroupingInfo class] andConfiguration:config];
            BXTGroupingInfo *groupInfo = [parser parseDictionary:dictionary];
            
            [departmentsArray addObject:groupInfo];
        }
    }
    else if (type == ManList)
    {
        [dataSource removeAllObjects];
        if (data.count > 0)
        {
            for (NSDictionary *dictionary in data)
            {
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"manID" onClass:[BXTAddOtherManInfo class]];
                [config addObjectMapping:text];
                
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTAddOtherManInfo class] andConfiguration:config];
                BXTAddOtherManInfo *otherManInfo = [parser parseDictionary:dictionary];
                
                if (otherManInfo.manID == [[BXTGlobal getUserProperty:U_BRANCHUSERID] integerValue])
                {
                    if (vcType != AssignType)
                    {
                        number = 1;
                        [selectMans addObject:otherManInfo];
                    }
                    isHave = YES;
                }
                [dataSource addObject:otherManInfo];
                
                [listArray addObject:[NSString stringWithFormat:@"%ld", (long)otherManInfo.manID]];
            }
            
            for (NSString *manID in self.manIDArray) {
                [indexArray addObject:[NSString stringWithFormat:@"%ld", (unsigned long)[listArray indexOfObject:manID]]];
            }
        }
        [currentTableView reloadData];
    }
    else if (type == ReaciveOrder)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [self showMBP:@"添加成功！" withBlock:^(BOOL hidden) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestDetail" object:nil];
                if (vcType == AssignType) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
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
