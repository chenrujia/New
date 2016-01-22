//
//  BXTWorkOderViewController.m
//  BXT
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairWordOrderViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTSettingTableViewCell.h"
#import "UIImage+SubImage.h"
#import "BXTSelectBoxView.h"
#import "BXTFaultInfo.h"
#import "BXTFaultTypeInfo.h"
#import "BXTShopLocationViewController.h"
#import "BXTAddOtherManViewController.h"
#import "BXTAddOtherManInfo.h"
#import "BXTChooseFaultViewController.h"

#define MOBILE 11
#define CAUSE 12

@interface BXTRepairWordOrderViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate>
{
    BXTSelectBoxView *boxView;
    BXTFaultTypeInfo *fault_type_info;
    BXTFaultInfo     *selectFaultInfo;
    BXTFaultTypeInfo *selectFaultTypeInfo;
    NSMutableArray   *dep_dataSource;
    NSMutableArray   *fau_dataSource;
    NSString         *cause;
    NSString         *notes;
    UIView           *toolView;
    NSInteger        indexSection;
    NSMutableArray   *manIDs;
    NSInteger        faulttype_type;
    
}

@property (nonatomic ,strong) NSMutableArray *mans;
@property (nonatomic, strong) UIPickerView   *pickView;
@property (nonatomic ,strong) NSString       *faultType;
@property (nonatomic, strong) NSString       *repairState;
@property (nonatomic, strong) UIView         *pickerbackView;

@property (nonatomic, copy) NSString *faulttypeID;
@property (nonatomic, copy) NSString *faulttype_typeID;
@property (nonatomic, copy) NSString *faultStr;

@end

@implementation BXTRepairWordOrderViewController

- (void)dealloc
{
    NSArray *array = [BXTGlobal getUserProperty:U_BINDINGADS];
    if (array.count)
    {
        NSDictionary *areaDic = array[0];
        BXTFloorInfo *floor = [[BXTFloorInfo alloc] init];
        floor.area_id = [areaDic objectForKey:@"area_id"];
        floor.area_name = [areaDic objectForKey:@"area_name"];
        [BXTGlobal setUserProperty:floor withKey:U_FLOOOR];
        
        BXTAreaInfo *area = [[BXTAreaInfo alloc] init];
        area.place_id = [areaDic objectForKey:@"place_id"];
        area.place_name = [areaDic objectForKey:@"place_name"];
        [BXTGlobal setUserProperty:area withKey:U_AREA];
    }
    
    LogBlue(@"新建报修释放了。。。");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    manIDs = [NSMutableArray array];
    self.mans = [NSMutableArray array];
    [BXTGlobal shareGlobal].maxPics = 3;
    self.repairState = @"2";
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
    dep_dataSource = [[NSMutableArray alloc] init];
    fau_dataSource = [[NSMutableArray alloc] init];
    
    /**请求故障类型列表**/
    BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [fau_request faultTypeList];
    
    [self navigationSetting:@"新建工单" andRightTitle:nil andRightImage:nil];
    [self createTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    self.currentTableView = [[UITableView alloc] initWithFrame:backView.bounds style:UITableViewStyleGrouped];
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    [backView addSubview:self.currentTableView];
    [self.view addSubview:backView];
}

#pragma mark -
#pragma mark 事件处理
- (void)createBoxView:(NSInteger)section
{
    self.pickerbackView = [[UIView alloc] initWithFrame:self.view.bounds];
    _pickerbackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _pickerbackView.tag = 101;
    [self.view addSubview:_pickerbackView];
    
    if (section == -1)
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"部门" boxSelectedViewType:DepartmentView listDataSource:dep_dataSource markID:nil actionDelegate:self];
        
        [self.view addSubview:boxView];
        [UIView animateWithDuration:0.3f animations:^{
            [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
        }];
    }
    else if (section == 1)
    {
        // 工具条
        toolView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-44, SCREEN_WIDTH, 44)];
        toolView.backgroundColor = colorWithHexString(@"cccdd0");
        [_pickerbackView addSubview:toolView];
        // sure
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 2, 80, 40)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        @weakify(self);
        [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.pickView)
            {
                [self.pickView removeFromSuperview];
                self.pickView = nil;
                [self.pickerbackView removeFromSuperview];
                [self.currentTableView reloadData];
            }
        }];
        [toolView addSubview:sureBtn];
        
        self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        _pickView.tag = 1000;
        _pickView.showsSelectionIndicator = YES;
        _pickView.backgroundColor = colorWithHexString(@"cdced1");
        _pickView.dataSource = self;
        _pickView.delegate = self;
        [self.view addSubview:_pickView];
    }
}

- (void)repairClick
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertCtr addAction:alertAction];
        @weakify(self);
        UIAlertAction *needAction = [UIAlertAction actionWithTitle:@"需要增援" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            @strongify(self);
            BXTAddOtherManViewController *addOtherManVC = [[BXTAddOtherManViewController alloc] initWithRepairID:0 andWithVCType:RepairType];
            [addOtherManVC didChoosedMans:^(NSMutableArray *mans) {
                [self handleMansArray:mans];
            }];
            [self.navigationController pushViewController:addOtherManVC animated:YES];
        }];
        [alertCtr addAction:needAction];
        UIAlertAction *notNeedAction = [UIAlertAction actionWithTitle:@"不需要增援" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            @strongify(self);
            [self handleMansArray:[NSMutableArray array]];
        }];
        [alertCtr addAction:notNeedAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"需要增援",@"不需要增援", nil];
        @weakify(self);
        [[sheet rac_buttonClickedSignal] subscribeNext:^(id x) {
            @strongify(self);
            if ([x integerValue] == 0)
            {
                BXTAddOtherManViewController *addOtherManVC = [[BXTAddOtherManViewController alloc] initWithRepairID:0 andWithVCType:RepairType];
                [addOtherManVC didChoosedMans:^(NSMutableArray *mans) {
                    [self handleMansArray:mans];
                }];
                [self.navigationController pushViewController:addOtherManVC animated:YES];
            }
            else
            {
                [self handleMansArray:[NSMutableArray array]];
            }
        }];
        [sheet showInView:self.view];
    }
}

- (void)handleMansArray:(NSMutableArray *)array
{
    self.mans = array;
    indexSection = 1;
    [self.currentTableView reloadData];
}

- (void)createNewWorkOrder:(NSArray *)array
{
    if ([self.faultType isEqualToString:@"请选择故障类型"])
    {
        [self showAlertView:@"请选择故障类型"];
        return;
    }
    if ([BXTGlobal isBlankString:cause])
    {
        [self showAlertView:@"请输入故障描述"];
        return;
    }
    if (faulttype_type == 0)
    {
        faulttype_type = 1;
    }
    if ([BXTGlobal isBlankString:notes])
    {
        notes = @"";
    }
    
    [self showLoadingMBP:@"新工单创建中..."];
    id shopInfo = [BXTGlobal getUserProperty:U_SHOP];
    if (!shopInfo)
    {
        [self requestWithShopID:@"" andRepairUsers:array];
        return;
    }
    if ([shopInfo isKindOfClass:[NSString class]])
    {
        [self requestWithShopID:shopInfo andRepairUsers:array];
    }
    else
    {
        BXTShopInfo *tempShopInfo = (BXTShopInfo *)shopInfo;
        [self requestWithShopID:tempShopInfo.stores_id andRepairUsers:array];
    }
}

- (void)requestWithShopID:(NSString *)shopID andRepairUsers:(NSArray *)array
{
    BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
    BXTFloorInfo *floorInfo = [BXTGlobal getUserProperty:U_FLOOOR];
    BXTAreaInfo *areaInfo = [BXTGlobal getUserProperty:U_AREA];
    
    /**请求新建工单**/
    BXTDataRequest *rep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [rep_request createRepair:self.faulttypeID
               faultType_type:self.faulttype_typeID
                   faultCause:cause
                   faultLevel:_repairState
                  depatmentID:departmentInfo.dep_id
                  floorInfoID:floorInfo.area_id
                   areaInfoId:areaInfo.place_id
                   shopInfoID:shopID
                    equipment:@"0"
                   faultNotes:notes
                   imageArray:self.resultPhotos
              repairUserArray:array];
}

- (void)showAlertView:(NSString *)title
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertCtr addAction:doneAction];
        [self.navigationController presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;//section头部高度
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4 + indexSection)
    {
        return 80.f;
    }
    
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4 + indexSection)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        
        CGFloat width = (SCREEN_WIDTH - 60.f)/2.f;
        CGFloat x = 40.f + width;
        
        UIButton *repairBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        repairBtn.frame = CGRectMake(20, 20, width, 50.f);
        [repairBtn setTitle:@"我来修" forState:UIControlStateNormal];
        [repairBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [repairBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        repairBtn.layer.masksToBounds = YES;
        repairBtn.layer.cornerRadius = 4.f;
        [repairBtn addTarget:self action:@selector(repairClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:repairBtn];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(x, 20, width, 50.f);
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        doneBtn.layer.masksToBounds = YES;
        doneBtn.layer.cornerRadius = 4.f;
        @weakify(self);
        [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self createNewWorkOrder:[NSArray array]];
        }];
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
    if (indexPath.section == 4)
    {
        return 170;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5 + indexSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4)
    {
        BXTRemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkCell"];
        if (!cell)
        {
            cell = [[BXTRemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RemarkCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.remarkTV.delegate = self;
        cell.titleLabel.text = @"备   注";
        
        @weakify(self);
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
        [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:cell.imgViewOne.tag];
        }];
        [cell.imgViewOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
        [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:cell.imgViewTwo.tag];
        }];
        [cell.imgViewTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
        [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:cell.imgViewThree.tag];
        }];
        [cell.imgViewThree addGestureRecognizer:tapGRThree];
        
        [cell.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepairCell"];
        if (!cell)
        {
            cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepairCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.detailLable.hidden = NO;
        cell.detailTF.hidden = YES;
        
        if (indexPath.section == 0)
        {
            cell.titleLabel.text = @"位   置";
            BXTFloorInfo *floorInfo = [BXTGlobal getUserProperty:U_FLOOOR];
            BXTAreaInfo *areaInfo = [BXTGlobal getUserProperty:U_AREA];
            if (floorInfo)
            {
                id shopInfo = [BXTGlobal getUserProperty:U_SHOP];
                if (shopInfo)
                {
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
                    cell.detailLable.text = [NSString stringWithFormat:@"%@ %@",floorInfo.area_name,areaInfo.place_name];
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
        else if (indexPath.section == 1)
        {
            cell.titleLabel.text = @"故   障";
            if (!self.faultStr)
            {
                cell.detailLable.text = @"请选择故障类型";
            }
            else
            {
                cell.detailLable.frame = CGRectMake(CGRectGetMaxX(cell.titleLabel.frame) + 20.f, 10., SCREEN_WIDTH - CGRectGetMaxX(cell.titleLabel.frame) - 50, 30);
                cell.detailLable.text = self.faultStr;
            }
            self.faultType = cell.detailLable.text;
            cell.checkImgView.hidden = NO;
            cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
            cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
        }
        else if (indexPath.section == 2)
        {
            cell.titleLabel.text = @"描   述";
            cell.detailLable.hidden = YES;
            cell.detailTF.hidden = NO;
            cell.detailTF.keyboardType = UIKeyboardTypeDefault;
            if (cause)
            {
                cell.detailTF.text = cause;
            }
            else
            {
                cell.detailTF.tag = CAUSE;
                cell.detailTF.delegate = self;
                cell.detailTF.placeholder = @"请输入故障原因";
                [cell.detailTF setValue:colorWithHexString(@"909497") forKeyPath:@"_placeholderLabel.textColor"];
                [cell.detailTF setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
            }
        }
        else if (indexPath.section == 3)
        {
            cell.titleLabel.text = @"等   级";
            cell.emergencyBtn.hidden = NO;
            cell.normelBtn.hidden = NO;
            @weakify(self);
            [[cell.emergencyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                self.repairState = @"1";
                cell.emergencyBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
                cell.normelBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
            }];
            [[cell.normelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                self.repairState = @"2";
                cell.emergencyBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
                cell.normelBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
            }];
        }
        else if (indexPath.section == 5)
        {
            cell.titleLabel.text = @"维修员";
            [manIDs removeAllObjects];
            [manIDs addObject:[BXTGlobal getUserProperty:U_BRANCHUSERID]];
            NSMutableArray *manNames = [NSMutableArray arrayWithObjects:[BXTGlobal getUserProperty:U_NAME], nil];
            for (BXTAddOtherManInfo *otherMan in _mans)
            {
                [manNames addObject:otherMan.name];
                [manIDs addObject:[NSString stringWithFormat:@"%ld",(long)otherMan.manID]];
            }
            NSString *strName = [manNames componentsJoinedByString:@"、"];
            cell.detailLable.text = strName;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        @weakify(self);
        BXTShopLocationViewController *shopLocationVC = [[BXTShopLocationViewController alloc] initWithIsResign:NO andBlock:^{
            @strongify(self);
            [self.currentTableView reloadData];
        }];
        [self.navigationController pushViewController:shopLocationVC animated:YES];
    }
    if (indexPath.section == 1)
    {
        BXTChooseFaultViewController *cfvc = [[BXTChooseFaultViewController alloc] init];
        cfvc.delegateSignal = [RACSubject subject];
        [cfvc.delegateSignal subscribeNext:^(NSArray *transArray) {
            NSString *transID = transArray[0];
            NSLog(@"---------- %@", transID);
            self.faultStr = transArray[1];
            if ([transID isEqualToString:@"other"]) {
                self.faulttypeID = @"";
                self.faulttype_typeID = @"1";
            }
            else {
                self.faulttypeID = transID;
                self.faulttype_typeID = @"";
            }
            [self.currentTableView reloadData];
        }];
        [self.navigationController pushViewController:cfvc animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (_pickView)
        {
            [_pickView removeFromSuperview];
            _pickView = nil;
            [self.currentTableView reloadData];
        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
            } completion:^(BOOL finished) {
                [boxView removeFromSuperview];
                boxView = nil;
            }];
        }
        [view removeFromSuperview];
    }
}

#pragma mark -
#pragma mark UITextViewDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == MOBILE)
    {
        [BXTGlobal setUserProperty:textField.text withKey:U_MOBILE];
    }
    else if (textField.tag == CAUSE)
    {
        cause = textField.text;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入报修内容"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    notes = textView.text;
    if (textView.text.length < 1)
    {
        textView.text = @"请输入报修内容";
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == DepartmentType)
    {
        if (data.count)
        {
            for (NSDictionary *dictionary in data)
            {
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"dep_id" onClass:[BXTDepartmentInfo class]];
                [config addObjectMapping:text];
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTDepartmentInfo class] andConfiguration:config];
                BXTDepartmentInfo *departmentInfo = [parser parseDictionary:dictionary];
                
                [dep_dataSource addObject:departmentInfo];
            }
        }
    }
    else if (type == FaultType)
    {
        for (NSDictionary *dictionary in data)
        {
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"fault_id" onClass:[BXTFaultInfo class]];
            [config addObjectMapping:text];
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTFaultInfo class] andConfiguration:config];
            BXTFaultInfo *faultObj = [parser parseDictionary:dictionary];
            
            NSMutableArray *fault_subs = [NSMutableArray array];
            NSArray *places = [dictionary objectForKey:@"sub_data"];
            
            for (NSDictionary *placeDic in places)
            {
                DCParserConfiguration *fault_type_config = [DCParserConfiguration configuration];
                DCObjectMapping *fault_type_map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"fau_id" onClass:[BXTFaultTypeInfo class]];
                [fault_type_config addObjectMapping:fault_type_map];
                DCKeyValueObjectMapping *fault_type_parser = [DCKeyValueObjectMapping mapperForClass:[BXTFaultTypeInfo class] andConfiguration:fault_type_config];
                BXTFaultTypeInfo *faultTypeObj = [fault_type_parser parseDictionary:placeDic];
                [fault_subs addObject:faultTypeObj];
            }
            
            BXTFaultTypeInfo *otherFaultTypeInfo = [[BXTFaultTypeInfo alloc] init];
            otherFaultTypeInfo.fau_id = 1;
            otherFaultTypeInfo.faulttype = @"其他";
            [fault_subs addObject:otherFaultTypeInfo];
            
            faultObj.sub_data = fault_subs;
            [fau_dataSource addObject:faultObj];
        }
        
        if (fau_dataSource.count > 0)
        {
            selectFaultInfo = fau_dataSource[0];
            NSArray *faultTypesArray = selectFaultInfo.sub_data;
            selectFaultTypeInfo = faultTypesArray[0];
        }
    }
    if (type == CreateRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestRepairList" object:nil];
            [self showMBP:@"新工单已创建！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

#pragma mark -
#pragma mark BXTBoxSelectedTitleDelegate
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    if (type == FaultInfoView)
    {
        fault_type_info = obj;
    }
    [self.currentTableView reloadData];
    
    UIView *view = [self.view viewWithTag:101];
    [view removeFromSuperview];
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    } completion:^(BOOL finished) {
        [boxView removeFromSuperview];
        boxView = nil;
    }];
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return fau_dataSource.count;
    }
    return selectFaultInfo.sub_data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        BXTFaultInfo *faultInfo = fau_dataSource[row];
        return faultInfo.faulttype_type;
    }
    
    BXTFaultTypeInfo *faultTypeInfo = selectFaultInfo.sub_data[row];
    return faultTypeInfo.faulttype;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        selectFaultInfo = fau_dataSource[row];
        NSArray *faultTypesArray = selectFaultInfo.sub_data;
        if (faultTypesArray.count)
        {
            selectFaultTypeInfo = faultTypesArray[0];
        }
        [pickerView reloadComponent:1];
        
        NSInteger typeID = selectFaultTypeInfo.faulttype_type;
        if (typeID != 0) {
            faulttype_type = typeID;
        }
    }
    else
    {
        NSArray *faultTypesArray = selectFaultInfo.sub_data;
        if (faultTypesArray.count)
        {
            selectFaultTypeInfo = faultTypesArray[row];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
