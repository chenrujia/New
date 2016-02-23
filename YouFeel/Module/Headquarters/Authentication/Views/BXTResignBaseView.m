//
//  BXTResignBaseView.m
//  BXT
//
//  Created by Jason on 15/9/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTResignBaseView.h"

@implementation BXTResignBaseView

- (instancetype)initWithFrame:(CGRect)frame andViewType:(ViewType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化
        BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
        departmentInfo.department = @"";
        [BXTGlobal setUserProperty:departmentInfo withKey:U_DEPARTMENT];
        
        BXTPostionInfo *positionInfo = [BXTGlobal getUserProperty:U_POSITION];
        positionInfo.department = @"";
        positionInfo.role = @"";
        [BXTGlobal setUserProperty:positionInfo withKey:U_POSITION];
        
        BXTGroupingInfo *groupingInfo = [BXTGlobal getUserProperty:U_GROUPINGINFO];
        groupingInfo.subgroup = @"";
        [BXTGlobal setUserProperty:groupingInfo withKey:U_GROUPINGINFO];
 
        self.viewType = type;
        departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
        if (departmentInfo && [departmentInfo.dep_id integerValue] == 2)
        {
            indexRow = 1;
        }
        else
        {
            indexRow = 0;
        }
        
        departmentArray = [NSMutableArray array];
        positionArray = [NSMutableArray array];
        groupArray = [NSMutableArray array];
        self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        [_currentTableView registerClass:[BXTSettingTableViewCell class] forCellReuseIdentifier:@"AuthenticationCell"];
        _currentTableView.delegate = self;
        _currentTableView.dataSource = self;
        _currentTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_currentTableView];
    }
    return self;
}

- (void)showMBP:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.delegate = self;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideTheMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == DepartmentType)
    {
        if (data.count)
        {
            [departmentArray removeAllObjects];
            for (NSDictionary *dictionary in data)
            {
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"dep_id" onClass:[BXTDepartmentInfo class]];
                [config addObjectMapping:text];
                
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTDepartmentInfo class] andConfiguration:config];
                BXTDepartmentInfo *departmentInfo = [parser parseDictionary:dictionary];
                
                [departmentArray addObject:departmentInfo];
            }
        }
    }
    else if (type == PositionType)
    {
        [positionArray removeAllObjects];
        if (data.count)
        {
            for (NSDictionary *dictionary in data)
            {
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"role_id" onClass:[BXTPostionInfo class]];
                [config addObjectMapping:text];
                
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTPostionInfo class] andConfiguration:config];
                BXTPostionInfo *positionInfo = [parser parseDictionary:dictionary];
                
                [positionArray addObject:positionInfo];
            }
        }
    }
    else if (type == BranchResign)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            NSString *repID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"finish_id"]];
            [BXTGlobal setUserProperty:repID withKey:U_BRANCHUSERID];
            
            NSMutableArray *shops_id_array;
            NSArray *shopsID = [BXTGlobal getUserProperty:U_SHOPIDS];
            if (shopsID)
            {
                shops_id_array = [NSMutableArray arrayWithArray:shopsID];
                
            }
            else
            {
                shops_id_array = [NSMutableArray array];
            }
            BXTHeadquartersInfo *companyInfo = [BXTGlobal getUserProperty:U_COMPANY];
            [shops_id_array addObject:companyInfo.company_id];
            [BXTGlobal setUserProperty:shops_id_array withKey:U_SHOPIDS];
            
            NSMutableArray *my_shops_array;
            NSArray *myShops = [BXTGlobal getUserProperty:U_MYSHOP];
            if (myShops)
            {
                my_shops_array = [NSMutableArray arrayWithArray:myShops];
            }
            else
            {
                my_shops_array = [NSMutableArray array];
            }
            [my_shops_array addObject:@{@"id":companyInfo.company_id,@"shop_name":companyInfo.name}];
            [BXTGlobal setUserProperty:my_shops_array withKey:U_MYSHOP];
            
            [self showMBP:@"注册成功！"];
            
            /**分店登录**/
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request branchLogin];
        }
    }
    else if (type == PropertyGrouping)
    {
        [groupArray removeAllObjects];
        if (data.count)
        {
            for (NSDictionary *dictionary in data)
            {
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"group_id" onClass:[BXTGroupingInfo class]];
                [config addObjectMapping:text];
                
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTGroupingInfo class] andConfiguration:config];
                BXTGroupingInfo *groupInfo = [parser parseDictionary:dictionary];
                
                [groupArray addObject:groupInfo];
            }
        }
    }
    else if (type == BranchLogin && [[dic objectForKey:@"returncode"] isEqualToString:@"0"])
    {
        NSArray *data = [dic objectForKey:@"data"];
        if (data.count > 0)
        {
            NSDictionary *userInfo = data[0];
            [[BXTGlobal shareGlobal] reLoginWithDic:userInfo];
        }
    }
}

- (void)requestError:(NSError *)error
{
    [self hideTheMBP];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16.f)];
    }
    else
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    }
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthenticationCell"];
    
    return cell;
}

- (void)createBoxView:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTapAction:)];
    [backView addGestureRecognizer:tapGesture];
    [[self navigation].view addSubview:backView];
    
    NSInteger table_section;
    BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
    if (departmentInfo && [departmentInfo.dep_id integerValue] == 2)
    {
        table_section = 6;
    }
    else
    {
        table_section = 5;
    }
    
    if (currentRow != section)
    {
        if (!boxView)
        {
            if (section == 4)
            {
                boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"部门" boxSelectedViewType:DepartmentView listDataSource:departmentArray markID:nil actionDelegate:self];
            }
            else
            {
                if (_viewType == RepairType)
                {
                    if (section == table_section)
                    {
                        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"职位" boxSelectedViewType:PositionView listDataSource:positionArray markID:nil actionDelegate:self];
                    }
                }
                else
                {
                    if (section == 5)
                    {
                        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"职位" boxSelectedViewType:PositionView listDataSource:positionArray markID:nil actionDelegate:self];
                    }
                    else if (section == 6)
                    {
                        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"分组" boxSelectedViewType:GroupingView listDataSource:groupArray markID:nil actionDelegate:self];
                    }
                }
            }
            
            [[self navigation].view addSubview:boxView];
        }
        else
        {
            if (section == 4)
            {
                [boxView boxTitle:@"部门" boxSelectedViewType:DepartmentView listDataSource:departmentArray];
            }
            else
            {
                if (_viewType == RepairType)
                {
                    [boxView boxTitle:@"职位" boxSelectedViewType:PositionView listDataSource:positionArray];
                }
                else
                {
                    if (section == 5)
                    {
                        [boxView boxTitle:@"职位" boxSelectedViewType:PositionView listDataSource:positionArray];
                    }
                    else if (section == 6)
                    {
                        [boxView boxTitle:@"分组" boxSelectedViewType:GroupingView listDataSource:groupArray];
                    }
                }
            }
            [[self navigation].view bringSubviewToFront:boxView];
        }
    }
    else
    {
        [[self navigation].view bringSubviewToFront:boxView];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
    }];
    
    currentRow = section;
}

- (void)backViewTapAction:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    [view removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    }];
}

#pragma mark -
#pragma mark BXTBoxSelectedTitleDelegate
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    UIView *view = [[self navigation].view viewWithTag:101];
    [view removeFromSuperview];
    
    if (type == DepartmentView)
    {
        BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
        if (departmentInfo && [departmentInfo.dep_id integerValue] == 2)
        {
            indexRow = 1;
        }
        else
        {
            indexRow = 0;
        }
        /**请求职位列表**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request positionsList:departmentInfo.dep_id];
    }
    [_currentTableView reloadData];
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    }];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
}

@end
