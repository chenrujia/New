//
//  BXTRepairerView.m
//  BXT
//
//  Created by Jason on 15/9/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairerView.h"

@implementation BXTRepairerView

- (instancetype)initWithFrame:(CGRect)frame andViewType:(ViewType)type
{
    self = [super initWithFrame:frame andViewType:type];
    if (self)
    {
        /**请求部门列表**/
        BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [dep_request departmentsList:@"1"];
        
        if ([BXTGlobal getUserProperty:U_DEPARTMENT])
        {
            /**请求职位列表**/
            BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
            BXTDataRequest *pos_request = [[BXTDataRequest alloc] initWithDelegate:self];
            [pos_request positionsList:departmentInfo.dep_id];
        }
    }
    return self;
}

#pragma mark -
#pragma makr UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
    if (section == table_section)
    {
        return 80.f;
    }
    
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 5 + indexRow)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, 50.f);
        [doneBtn setTitle:@"提交审核" forState:UIControlStateNormal];
        [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        doneBtn.layer.masksToBounds = YES;
        doneBtn.layer.cornerRadius = 6.f;
        [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:doneBtn];
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6 + indexRow;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthenticationCell"];
    
    if (indexPath.section == 0)
    {
        cell.titleLabel.text = @"手机号";
        cell.detailLable.text = [BXTGlobal getUserProperty:U_USERNAME];
        cell.checkImgView.hidden = NO;
    }
    else if (indexPath.section == 1)
    {
        cell.titleLabel.text = @"姓   名";
        cell.detailLable.text = [BXTGlobal getUserProperty:U_NAME];
        cell.checkImgView.hidden = NO;
    }
    else if (indexPath.section == 2)
    {
        cell.titleLabel.text = @"性   别";
        if ([[BXTGlobal getUserProperty:U_SEX] isEqualToString:@"1"])
        {
            cell.detailLable.text = @"男";
        }
        else
        {
            cell.detailLable.text = @"女";
        }
        cell.checkImgView.hidden = NO;
    }
    else if (indexPath.section == 3)
    {
        cell.titleLabel.text = @"位   置";
        BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
        cell.detailLable.text = company.name;
        cell.checkImgView.hidden = NO;
    }
    else if (indexPath.section == 4)
    {
        BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
        cell.titleLabel.text = @"部   门";
        if (![BXTGlobal isBlankString:departmentInfo.department])
        {
            cell.detailLable.text = departmentInfo.department;
        }
        else
        {
            cell.detailLable.text = @"请选择您所在部门";
        }
        cell.checkImgView.hidden = NO;
        cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
        cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
    }
    else
    {
        BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
        if (departmentInfo && [departmentInfo.dep_id integerValue] == 2)
        {
            if (indexPath.section == 5)
            {
                cell.titleLabel.text = @"地   点";
                BXTFloorInfo *floorInfo = [BXTGlobal getUserProperty:U_FLOOOR];
                BXTAreaInfo *areaInfo = [BXTGlobal getUserProperty:U_AREA];
                if (floorInfo)
                {
                    id shopInfo = [BXTGlobal getUserProperty:U_SHOP];
                    if ([shopInfo isKindOfClass:[NSString class]])
                    {
                        cell.detailLable.text = [NSString stringWithFormat:@"%@ %@ %@",floorInfo.area_name,areaInfo.place_name,shopInfo];
                    }
                    else
                    {
                        BXTShopInfo *tempShop = (BXTShopInfo *)shopInfo;
                        cell.detailLable.text = [NSString stringWithFormat:@"%@ %@ %@",floorInfo.area_name,areaInfo.place_name,tempShop.stores_name];
                    }
                }
                else
                {
                    cell.detailLable.text = @"请选择您商铺所在具体位置";
                }
                
                cell.checkImgView.hidden = NO;
                cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
                cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
            }
            else
            {
                cell.titleLabel.text = @"职   位";
                cell.detailTF.hidden = YES;
                cell.detailLable.hidden = NO;
                BXTPostionInfo *postionInfo = [BXTGlobal getUserProperty:U_POSITION];
                if (![BXTGlobal isBlankString:postionInfo.role])
                {
                    cell.detailLable.text = postionInfo.role;
                }
                else
                {
                    cell.detailLable.text = @"请选择您的职位";
                }
                cell.checkImgView.hidden = NO;
                cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
                cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
            }
        }
        else
        {
            cell.titleLabel.text = @"职   位";
            cell.detailTF.hidden = YES;
            cell.detailLable.hidden = NO;
            BXTPostionInfo *postionInfo = [BXTGlobal getUserProperty:U_POSITION];
            if (![BXTGlobal isBlankString:postionInfo.role])
            {
                cell.detailLable.text = postionInfo.role;
            }
            else
            {
                cell.detailLable.text = @"请选择您的职位";
            }
            cell.checkImgView.hidden = NO;
            cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
            cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 4)
    {
        [self createBoxView:indexPath.section];
    }
    else
    {
        BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
        if ([BXTGlobal isBlankString:departmentInfo.department])
        {
            [self showAlertView:@"请选择你所在部门"];
            return;
        }
    
        departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
        if (departmentInfo && [departmentInfo.dep_id integerValue] == 2)
        {
            if (indexPath.section == 5)
            {
                @weakify(self);
                BXTShopLocationViewController *shopLocationVC = [[BXTShopLocationViewController alloc] initWithIsResign:YES andBlock:^{
                    @strongify(self);
                    [self.currentTableView reloadData];
                }];
                UINavigationController *nav = (UINavigationController *)[AppDelegate appdelegete].window.rootViewController;
                [nav pushViewController:shopLocationVC animated:YES];
            }
            else if (indexPath.section == 6)
            {
                [self createBoxView:indexPath.section];
            }
        }
        else
        {
            if (indexPath.section == 5)
            {
                //先选部门，后选职位
                if ([BXTGlobal getUserProperty:U_DEPARTMENT])
                {
                    [self createBoxView:indexPath.section];
                }
            }
        }
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [super requestResponseData:response requeseType:type];
}

- (void)requestError:(NSError *)error
{
    [super requestError:error];
}

- (void)doneClick
{
    BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
    if ([BXTGlobal isBlankString:departmentInfo.department]) {
        [self showAlertView:@"请选择你所在部门"];
        return;
    }
    
    BXTPostionInfo *postionInfo = [BXTGlobal getUserProperty:U_POSITION];
    if ([BXTGlobal isBlankString:postionInfo.role]) {
        [self showAlertView:@"请选择你的职位"];
        return;
    }
    
    [self showLoadingMBP:@"注册中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request branchResign:1];
}

- (void)showAlertView:(NSString *)title
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertCtr addAction:doneAction];
        [self.window.rootViewController presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end