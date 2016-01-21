//
//  BXTShopLocationViewController.m
//  BXT
//
//  Created by Jason on 15/8/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTShopLocationViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTSettingTableViewCell.h"
#import "BXTShopInfo.h"
#import "BXTSelectBoxView.h"
#import "ANKeyValueTable.h"

@interface BXTShopLocationViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate>
{
    NSMutableArray   *dataArray;
    BXTFloorInfo     *selectedFloorInfo;
    BXTAreaInfo      *selectedAreaInfo;
    BXTShopInfo      *selecedShopInfo;
    BXTSelectBoxView *boxView;
}

@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, assign) BOOL        isResign;

@end

@implementation BXTShopLocationViewController

- (instancetype)initWithIsResign:(BOOL)resign andBlock:(ChangeArea)selectArea
{
    self = [super init];
    if (self)
    {
        self.isResign = resign;
        self.selectAreaBlock = selectArea;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    if ([BXTGlobal getUserProperty:U_FLOOOR])
    {
        selectedFloorInfo = [BXTGlobal getUserProperty:U_FLOOOR];
    }
    if ([BXTGlobal getUserProperty:U_AREA])
    {
        selectedAreaInfo = [BXTGlobal getUserProperty:U_AREA];
    }
    if ([BXTGlobal getUserProperty:U_SHOP])
    {
        selecedShopInfo = [BXTGlobal getUserProperty:U_SHOP];
    }
    
    [self showLoadingMBP:@"正在获取信息..."];
    /**请求分店位置**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request shopLocation];
    
    [self navigationSetting:@"选择位置" andRightTitle:nil andRightImage:nil];
    [self createTableView];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [_currentTableView registerClass:[BXTSettingTableViewCell class] forCellReuseIdentifier:@"ShopLocationCell"];
    _currentTableView.delegate = self;
    _currentTableView.dataSource = self;
    _currentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_currentTableView];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
    view.backgroundColor = [UIColor clearColor];
    self.currentTableView.tableFooterView = view;
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, 50.f);
    [doneBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 6.f;
    @weakify(self);
    [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self navigationLeftButton];
    }];
    [view addSubview:doneBtn];
}

#pragma mark -
#pragma mark 事件处理
- (void)createBoxView:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    if (section == 0)
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"区域" boxSelectedViewType:FloorInfoView listDataSource:dataArray markID:nil actionDelegate:self];
    }
    else if (section == 1)
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"地点" boxSelectedViewType:AreaInfoView listDataSource:selectedFloorInfo.place markID:nil actionDelegate:self];
    }
    else if (section == 2)
    {
        NSMutableArray *stores = [NSMutableArray arrayWithArray:selectedAreaInfo.stores];
        if (_isResign)
        {
            //[stores addObject:@"其他"];
        }
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"店名" boxSelectedViewType:ShopInfoView listDataSource:stores markID:nil actionDelegate:self];
    }
    [self.view addSubview:boxView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
    }];
}

- (void)navigationLeftButton
{
    if (_isResign && (![BXTGlobal getUserProperty:U_FLOOOR] || ![BXTGlobal getUserProperty:U_AREA] || ![BXTGlobal getUserProperty:U_SHOP]))
    {
        [BXTGlobal showText:@"请填写完整信息" view:self.view completionBlock:nil];
        return;
    }
    if (!_isResign && (![BXTGlobal getUserProperty:U_FLOOOR] || ![BXTGlobal getUserProperty:U_AREA]))
    {
        [BXTGlobal showText:@"请选择楼层" view:self.view completionBlock:nil];
        return;
    }
    else if (_isResign)
    {
        id shopInfo = [BXTGlobal getUserProperty:U_SHOP];
        if ([shopInfo isKindOfClass:[BXTShopInfo class]])
        {
            NSArray *areaArrResult = [selectedAreaInfo.stores filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.stores_id = %@",selecedShopInfo.stores_id]];
            if (!areaArrResult.count)
            {
                [BXTGlobal showText:@"地点和店名信息不符" view:self.view completionBlock:nil];
                return;
            }
        }
    }
    
    [self showLoadingMBP:@"正在更新信息..."];
    /**请求分店位置**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request updateShopAddress:selecedShopInfo.stores_id];
    
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
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_isResign && selectedAreaInfo.stores.count == 0)
    {
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopLocationCell"];
    
    cell.checkImgView.hidden = NO;
    cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
    cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
    
    if (indexPath.section == 0)
    {
        cell.titleLabel.text = @"项目/楼号:";
        if ([BXTGlobal getUserProperty:U_FLOOOR])
        {
            BXTFloorInfo *floorInfo = [BXTGlobal getUserProperty:U_FLOOOR];
            cell.detailLable.text = floorInfo.area_name;
        }
        else
        {
            cell.detailLable.text = @"请选择一级位置信息";
        }
    }
    else if (indexPath.section == 1)
    {
        cell.titleLabel.text = @"区域/楼层:";
        if ([BXTGlobal getUserProperty:U_AREA])
        {
            BXTAreaInfo *areaInfo = [BXTGlobal getUserProperty:U_AREA];
            cell.detailLable.text = areaInfo.place_name;
        }
        else
        {
            cell.detailLable.text = @"请选择二级位置信息";
        }
    }
    else
    {
        cell.titleLabel.text = @"地点/单元:";
        if ([BXTGlobal getUserProperty:U_SHOP])
        {
            id shopInfo = [BXTGlobal getUserProperty:U_SHOP];
            if ([shopInfo isKindOfClass:[NSString class]])
            {
                cell.detailLable.text = shopInfo;
            }
            else
            {
                BXTShopInfo *tempShop = (BXTShopInfo *)shopInfo;
                cell.detailLable.text = tempShop.stores_name;
            }
        }
        else
        {
            cell.detailLable.text = @"请选择三级位置信息";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self createBoxView:indexPath.section];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    NSArray *array = [dic objectForKey:@"data"];
    
    if (type == ShopType)
    {
        for (NSDictionary *dictionary in array)
        {
            DCArrayMapping *floorMapper = [DCArrayMapping mapperForClassElements:[BXTAreaInfo class] forAttribute:@"place" onClass:[BXTFloorInfo class]];
            DCParserConfiguration *floorConfig = [DCParserConfiguration configuration];
            [floorConfig addArrayMapper:floorMapper];
            DCKeyValueObjectMapping *floorParser = [DCKeyValueObjectMapping mapperForClass:[BXTFloorInfo class]  andConfiguration:floorConfig];
            BXTFloorInfo *floor = [floorParser parseDictionary:dictionary];
            
            NSMutableArray *areaArray = [NSMutableArray array];
            NSArray *places = [dictionary objectForKey:@"place"];
            for (NSDictionary *placeDic in places)
            {
                DCArrayMapping *areaMapper = [DCArrayMapping mapperForClassElements:[BXTShopInfo class] forAttribute:@"stores" onClass:[BXTAreaInfo class]];
                DCParserConfiguration *areaConfig = [DCParserConfiguration configuration];
                [areaConfig addArrayMapper:areaMapper];
                DCKeyValueObjectMapping *areaParser = [DCKeyValueObjectMapping mapperForClass:[BXTAreaInfo class]  andConfiguration:areaConfig];
                BXTAreaInfo *area = [areaParser parseDictionary:placeDic];
                if ([area.place_id isEqual:selectedAreaInfo.place_id])
                {
                    selectedAreaInfo = area;
                }
                [areaArray addObject:area];
            }
            floor.place = areaArray;
            if ([floor.area_id isEqual:selectedFloorInfo.area_id])
            {
                selectedFloorInfo = floor;
            }
            [dataArray addObject:floor];
        }
    }
    else if (type == CommitShop)
    {
        //[BXTGlobal setUserProperty:[NSString stringWithFormat:@"%@", dic[@"finish_id"]] withKey:U_Finish_ID];
    }
    else if (type == UpdateShopAddress)
    {
        [BXTGlobal showText:@"更新成功" view:self.view completionBlock:^{
            if (self.delegateSignal) {
                [self.delegateSignal sendNext:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        [view removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
        } completion:^(BOOL finished) {
            [boxView removeFromSuperview];
            boxView = nil;
        }];
    }
}

#pragma mark -
#pragma mark BXTBoxSelectedTitleDelegate
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    if (type == FloorInfoView)
    {
        selectedFloorInfo = obj;
        BXTUserInfo *userInfo = [BXTGlobal getUserInfo];
        userInfo.areaInfo = nil;
        userInfo.shopInfo = nil;
        [BXTGlobal setUserInfo:userInfo];
        [_currentTableView reloadData];
    }
    else if (type == AreaInfoView)
    {
        selectedAreaInfo = obj;
        BXTUserInfo *userInfo = [BXTGlobal getUserInfo];
        userInfo.shopInfo = nil;
        [BXTGlobal setUserInfo:userInfo];
        [_currentTableView reloadData];
    }
    else if (type == ShopInfoView)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            if (IS_IOS_8)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"店名" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    textField.placeholder = @"请输入您的地点";
                }];
                
                @weakify(self);
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    @strongify(self);
                    UITextField *shopTF = alertController.textFields.firstObject;
                    [BXTGlobal setUserProperty:shopTF.text withKey:U_SHOP];
                    [self.currentTableView reloadData];
                    
                    [self showLoadingMBP:@"正在上传地点信息..."];
                    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                    [request commitNewShop:shopTF.text];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"店名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField *textField=[alertView textFieldAtIndex:0];
                textField.placeholder = @"请输入您的店名";
                @weakify(self);
                [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
                    @strongify(self);
                    if ([x integerValue] == 1)
                    {
                        UITextField *shopTF=[alertView textFieldAtIndex:0];
                        [BXTGlobal setUserProperty:shopTF.text withKey:U_SHOP];
                        [self.currentTableView reloadData];
                        
                        [self showLoadingMBP:@"正在上传地点信息..."];
                        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                        [request commitNewShop:shopTF.text];
                    }
                }];
                [alertView show];
            }
        }
        else
        {
            selecedShopInfo = obj;
        }
    }
    //block回传
    if (selectedFloorInfo && selectedAreaInfo)
    {
        _selectAreaBlock();
    }
    
    [_currentTableView reloadData];
    UIView *view = [self.view viewWithTag:101];
    [view removeFromSuperview];
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    } completion:^(BOOL finished) {
        [boxView removeFromSuperview];
        boxView = nil;
    }];
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
