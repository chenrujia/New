//
//  BXTEPLocationViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEPLocationViewController.h"
#import "BXTEPLocationCell.h"
#import "BXTHeaderForVC.h"
#import "BXTShopInfo.h"
#import "ANKeyValueTable.h"
#import "BXTDeviceList.h"

typedef NS_ENUM(NSInteger, SelectedType) {
    SelectedType_First = 0,
    SelectedType_Second,
    SelectedType_Third,
};

@interface BXTEPLocationViewController () <UITableViewDataSource, UITableViewDelegate, BXTDataResponseDelegate>

{
    NSMutableArray   *dataArray;
}

@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, assign) BOOL        isResign;


@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, assign) BOOL isBgBtnExist;
@property (nonatomic, strong) UITableView *tableView_address;
/** ---- 显示数组 ---- */
@property (nonatomic, strong) NSMutableArray *addressArray;
/** ---- 选择位置 ---- */
@property (nonatomic, strong) NSMutableArray *addressFirstArray;
@property (nonatomic, strong) NSMutableArray *addressSecondArray;
@property (nonatomic, strong) NSMutableArray *addressThirdArray;
/** ---- 位置类别 ---- */
@property (nonatomic, strong) NSMutableArray *addressType;
@property (nonatomic, assign) CGSize cellSize;
/** ---- 层数 ---- */
@property (nonatomic, assign) NSInteger typeOfRow;
/** ---- 1层数选择的row ---- */
@property (nonatomic, assign) NSInteger indexOfRow1;
/** ---- 2层数选择的row ---- */
@property (nonatomic, assign) NSInteger indexOfRow2;
/** ---- 3层数选择的row ---- */
@property (nonatomic, assign) NSInteger indexOfRow3;

@property (nonatomic, copy) NSString *firstText;
@property (nonatomic, copy) NSString *secondText;
@property (nonatomic, copy) NSString *thirdText;


@end

@implementation BXTEPLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"位置" andRightTitle:nil andRightImage:nil];
    
    self.addressArray = [[NSMutableArray alloc] init];
    self.addressFirstArray = [[NSMutableArray alloc] init];
    self.addressSecondArray = [[NSMutableArray alloc] init];
    self.addressThirdArray = [[NSMutableArray alloc] init];
    self.firstText = @"请输入(必填项)";
    self.secondText = @"请输入(非必填项)";
    self.thirdText = @"请输入(非必填项)";
    
    
    dataArray = [NSMutableArray array];
    
    [self showLoadingMBP:@"正在获取信息..."];
    /**请求分店位置**/
    BXTDataRequest *dep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [dep_request shopLocation];
    
    [self createTableView];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [_currentTableView registerClass:[BXTEPLocationCell class] forCellReuseIdentifier:@"BXTEPLocationCell"];
    _currentTableView.delegate = self;
    _currentTableView.dataSource = self;
    _currentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_currentTableView];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
    view.backgroundColor = [UIColor clearColor];
    self.currentTableView.tableFooterView = view;
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, 50.f);
    
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 4.f;
    @weakify(self);
    [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self sendNewInform];
    }];
    [view addSubview:doneBtn];
}

- (void)navigationLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendNewInform
{
    if ([self.firstText isEqualToString:@"请输入(必填项)"])
    {
        [BXTGlobal showText:@"请填写完整信息" view:self.view completionBlock:nil];
        return;
    }
    
    [BXTGlobal showText:@"位置选择成功" view:self.view completionBlock:^{
        // 一级位置
        BXTFloorInfo *firstModel = self.addressFirstArray[self.indexOfRow1];
        [self.delegateSignal sendNext:@[firstModel.area_id, firstModel.area_name, @"", @"", @"", @""]];
        
        // 二级位置
        if (![self.secondText isEqualToString:@"请输入(非必填项)"]) {
            BXTAreaInfo *secondModel = self.addressSecondArray[self.indexOfRow1][self.indexOfRow2];
            [self.delegateSignal sendNext:@[firstModel.area_id, firstModel.area_name, secondModel.place_id, secondModel.place_name, @"", @""]];
        }
        
        if (![self.thirdText isEqualToString:@"请输入(非必填项)"]) {
            BXTAreaInfo *secondModel = self.addressSecondArray[self.indexOfRow1][self.indexOfRow2];
            BXTShopInfo *thirdModel = self.addressThirdArray[self.indexOfRow1][self.indexOfRow2][self.indexOfRow3];
            [self.delegateSignal sendNext:@[firstModel.area_id, firstModel.area_name, secondModel.place_id, secondModel.place_name, thirdModel.stores_id, thirdModel.stores_name]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView_address) {
        return 1;
    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView_address) {
        return self.addressArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_address) {
        static NSString *cellID = @"cellFault";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        if (self.typeOfRow == SelectedType_First) {
            BXTFloorInfo *model = self.addressArray[indexPath.row];
            cell.textLabel.text = model.area_name;
        }
        else if (self.typeOfRow == SelectedType_Second) {
            BXTAreaInfo *model = self.addressArray[indexPath.row];
            cell.textLabel.text = model.place_name;
        }
        
        if (self.typeOfRow == SelectedType_Third) {
            BXTShopInfo *model = self.addressArray[indexPath.row];
            cell.textLabel.text = model.stores_name;
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        
        self.cellSize = MB_MULTILINE_TEXTSIZE(cell.textLabel.text, [UIFont systemFontOfSize:16], CGSizeMake(SCREEN_WIDTH-60, CGFLOAT_MAX), NSLineBreakByWordWrapping);
        
        return cell;
    }
    
    
    BXTEPLocationCell *cell = [BXTEPLocationCell cellWithTableView:tableView];
    
    
    if (indexPath.section == 0) {
        cell.titleView.text = @"一级位置";
        cell.descView.text = self.firstText;
    }
    else if (indexPath.section == 1) {
        cell.titleView.text = @"二级位置";
        cell.descView.text = self.secondText;
    }
    else if (indexPath.section == 2) {
        cell.titleView.text = @"三级位置";
        cell.descView.text = self.thirdText;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableView_address) {
        self.isBgBtnExist = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.bgBtn.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.bgBtn removeFromSuperview];
        }];
        
        if (self.typeOfRow == SelectedType_First) {
            BXTFloorInfo *model = self.addressArray[indexPath.row];
            self.firstText = model.area_name;
            self.indexOfRow1 = indexPath.row;
            self.secondText = @"请输入(非必填项)";
            self.thirdText = @"请输入(非必填项)";
        }
        else if (self.typeOfRow == SelectedType_Second) {
            BXTAreaInfo *model = self.addressArray[indexPath.row];
            self.secondText = model.place_name;
            self.indexOfRow2 = indexPath.row;
            self.thirdText = @"请输入(非必填项)";
        }
        else if (self.typeOfRow == SelectedType_Third) {
            BXTShopInfo *model = self.addressArray[indexPath.row];
            self.thirdText = model.stores_name;
            self.indexOfRow3 = indexPath.row;
        }
        
        [self.currentTableView reloadData];
    }
    else {
        [self createChooseAddressWithType:indexPath.section];
    }
}

#pragma mark -
#pragma mark - createChooseAddress
- (void)createChooseAddressWithType:(SelectedType)typeSelected
{
    if (typeSelected == 0) {
        self.addressArray = self.addressFirstArray;
        self.typeOfRow = SelectedType_First;
    }
    else if (typeSelected == 1) {
        if ([self.firstText isEqualToString:@"请输入(必填项)"]) {
            [BXTGlobal showText:@"请选择一级位置信息" view:self.view completionBlock:nil];
            return;
        }
        self.addressArray = self.addressSecondArray[self.indexOfRow1];
        self.typeOfRow = SelectedType_Second;
    }
    else if (typeSelected == 2) {
        if ([self.secondText isEqualToString:@"请输入(非必填项)"]) {
            [BXTGlobal showText:@"请选择二级位置信息" view:self.view completionBlock:nil];
            return;
        }
        self.addressArray = self.addressThirdArray[self.indexOfRow1][self.indexOfRow2];
        self.typeOfRow = SelectedType_Third;
    }
    
    
    self.isBgBtnExist = YES;
    self.bgBtn = [[UIButton alloc] initWithFrame:self.view.frame];
    self.bgBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.bgBtn.alpha = 0;
    @weakify(self);
    [[self.bgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.isBgBtnExist = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.bgBtn.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.bgBtn removeFromSuperview];
        }];
    }];
    [self.view addSubview:self.bgBtn];
    
    CGSize bgSize = self.view.frame.size;
    self.tableView_address = [[UITableView alloc] initWithFrame:CGRectMake(20, 70, bgSize.width-40, bgSize.height-140) style:UITableViewStylePlain];
    self.tableView_address.backgroundColor = colorWithHexString(@"eff3f6");
    self.tableView_address.delegate = self;
    self.tableView_address.dataSource = self;
    [self.bgBtn addSubview:self.tableView_address];
    
    if (self.addressArray.count <= 6) {
        self.tableView_address.frame = CGRectMake(20, 80, bgSize.width-40, bgSize.height-160);
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.bgBtn.alpha = 1.0;
    }];
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
        NSMutableArray *firstArray = [[NSMutableArray alloc] init];
        NSMutableArray *secondArray = [[NSMutableArray alloc] init];
        NSMutableArray *thirdArray = [[NSMutableArray alloc] init];
        for (NSDictionary *firstDict in array) {
            // 第一层
            BXTFloorInfo *firstModel = [BXTFloorInfo modelWithDict:firstDict];
            [firstArray addObject:firstModel];
            
            // 第二层
            NSMutableArray *subSecondArray = [[NSMutableArray alloc] init];
            NSMutableArray *subThirdArray = [[NSMutableArray alloc] init];
            for (NSDictionary *secondDict in firstDict[@"place"]) {
                BXTAreaInfo *secondModel = [BXTAreaInfo modelWithDict:secondDict];
                [subSecondArray addObject:secondModel];
                
                // 第三层
                NSMutableArray *subSubThirdArray = [[NSMutableArray alloc] init];
                for (NSDictionary *thirdDict in secondDict[@"stores"]) {
                    BXTShopInfo *thirdModel = [BXTShopInfo modelWithDict:thirdDict];
                    [subSubThirdArray addObject:thirdModel];
                }
                [subThirdArray addObject:subSubThirdArray];
            }
            [secondArray addObject:subSecondArray];
            [thirdArray addObject:subThirdArray];
        }
        
        self.addressFirstArray = firstArray;
        self.addressSecondArray = secondArray;
        self.addressThirdArray = thirdArray;
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

- (void)createForthUI {
    self.isBgBtnExist = YES;
    self.bgBtn = [[UIButton alloc] initWithFrame:self.view.frame];
    self.bgBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.bgBtn.alpha = 0;
    @weakify(self);
    [[self.bgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.isBgBtnExist = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.bgBtn.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.bgBtn removeFromSuperview];
        }];
    }];
    [self.view addSubview:self.bgBtn];
    
    CGSize bgSize = self.view.frame.size;
    self.tableView_address = [[UITableView alloc] initWithFrame:CGRectMake(20, 30, bgSize.width-40, bgSize.height-60) style:UITableViewStylePlain];
    self.tableView_address.backgroundColor = colorWithHexString(@"eff3f6");
    self.tableView_address.delegate = self;
    self.tableView_address.dataSource = self;
    [self.bgBtn addSubview:self.tableView_address];
    
    if (self.addressArray.count <= 6) {
        self.tableView_address.frame = CGRectMake(20, 80, bgSize.width-40, bgSize.height-160);
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.bgBtn.alpha = 1.0;
    }];
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
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
