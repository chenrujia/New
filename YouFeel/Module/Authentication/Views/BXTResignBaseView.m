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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"ChangeShopLocation" object:nil];
        
        self.viewType = type;
        BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
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
        currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        [currentTableView registerClass:[BXTSettingTableViewCell class] forCellReuseIdentifier:@"AuthenticationCell"];
        currentTableView.delegate = self;
        currentTableView.dataSource = self;
        currentTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:currentTableView];
    }
    return self;
}

- (void)reloadTable
{
    [currentTableView reloadData];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
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
            
            NSArray *bindingAds = [userInfo objectForKey:@"binding_ads"];
            [BXTGlobal setUserProperty:bindingAds withKey:U_BINDINGADS];
            
            BXTDepartmentInfo *departmentInfo = [[BXTDepartmentInfo alloc] init];
            departmentInfo.dep_id = [userInfo objectForKey:@"department"];
            departmentInfo.department = [userInfo objectForKey:@"department_name"];
            [BXTGlobal setUserProperty:departmentInfo withKey:U_DEPARTMENT];
            
            BXTGroupingInfo *groupInfo = [[BXTGroupingInfo alloc] init];
            groupInfo.group_id = [userInfo objectForKey:@"subgroup"];
            groupInfo.subgroup = [userInfo objectForKey:@"subgroup_name"];
            [BXTGlobal setUserProperty:groupInfo withKey:U_GROUPINGINFO];
            
            NSString *userID = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"]];
            [BXTGlobal setUserProperty:userID withKey:U_BRANCHUSERID];
            
            BXTPostionInfo *roleInfo = [[BXTPostionInfo alloc] init];
            roleInfo.role_id = [userInfo objectForKey:@"role_id"];
            roleInfo.role = [userInfo objectForKey:@"role"];
            [BXTGlobal setUserProperty:roleInfo withKey:U_POSITION];
            
            BXTShopInfo *shopInfo = [[BXTShopInfo alloc] init];
            shopInfo.stores_id = [userInfo objectForKey:@"stores_id"];
            shopInfo.stores_name = [userInfo objectForKey:@"stores"];
            [BXTGlobal setUserProperty:shopInfo withKey:U_SHOP];
            
            [BXTGlobal setUserProperty:[userInfo objectForKey:@"username"] withKey:U_USERNAME];
            [BXTGlobal setUserProperty:[userInfo objectForKey:@"role_con"] withKey:U_ROLEARRAY];
            [BXTGlobal setUserProperty:[userInfo objectForKey:@"mobile"] withKey:U_MOBILE];
            
            UINavigationController *nav;
            if ([[userInfo objectForKey:@"is_repair"] integerValue] == 2)
            {
                BXTRepairHomeViewController *homeVC = [[BXTRepairHomeViewController alloc] init];
                nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
            }
            else
            {
                BXTShopsHomeViewController *homeVC = [[BXTShopsHomeViewController alloc] init];
                nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
            }
            nav.navigationBar.hidden = YES;
            [AppDelegate appdelegete].window.rootViewController = nav;
        }
    }
}

- (void)requestError:(NSError *)error
{
    
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;//section头部高度
    }
    return 10.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16.f)];
    }
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
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
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
    [currentTableView reloadData];
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    }];
}

#pragma mark -
#pragma mark UITextFiledDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [BXTGlobal setUserProperty:textField.text withKey:U_JOBNUMBER];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
