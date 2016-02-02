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
#import "BXTFaultInfo.h"
#import "BXTFaultTypeInfo.h"
#import "BXTShopLocationViewController.h"
#import "BXTAddOtherManViewController.h"
#import "BXTAddOtherManInfo.h"
#import "BXTChooseFaultViewController.h"

#define MOBILE 11
#define CAUSE 12

@interface BXTRepairWordOrderViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,BXTDataResponseDelegate>
{
    BXTFaultTypeInfo *fault_type_info;
    BXTFaultInfo     *selectFaultInfo;
    BXTFaultTypeInfo *selectFaultTypeInfo;
    NSMutableArray   *dep_dataSource;
    NSMutableArray   *fau_dataSource;
    NSString         *cause;
    
    NSInteger        indexSection;
    NSMutableArray   *manIDs;
    NSInteger        faulttype_type;
    NSString        *address;
}

@property (nonatomic ,strong) NSMutableArray *mans;
@property (nonatomic ,strong) NSString       *faultType;
@property (nonatomic, strong) NSString       *repairState;

@property (nonatomic, copy) NSString *faulttypeID;
@property (nonatomic, copy) NSString *faulttype_typeID;
@property (nonatomic, copy) NSString *faultStr;
/**  0  area_id        1  area_name
 *    2  place_id       3  place_name
 *    4  stores_id      5  stores_name
 *    6  device_ids   7  name
 */
@property (nonatomic, strong) NSArray *addressIDArray;

@end

@implementation BXTRepairWordOrderViewController

- (void)dealloc
{
    LogBlue(@"新建报修释放了。。。");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //侦听删除事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"DeleteTheImage" object:nil];
    
    manIDs = [NSMutableArray array];
    self.mans = [NSMutableArray array];
    [BXTGlobal shareGlobal].maxPics = 3;
    self.repairState = @"2";
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    dep_dataSource = [[NSMutableArray alloc] init];
    fau_dataSource = [[NSMutableArray alloc] init];
    address = @"请选择位置";
    
    [self navigationSetting:@"新建工单" andRightTitle:nil andRightImage:nil];
    [self createTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)deleteImage:(NSNotification *)notification
{
    NSNumber *number = notification.object;
    [self handleData:[number integerValue]];
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
    if ([address isEqualToString:@"请选择位置"]) {
        [self showAlertView:@"请选择商铺所在位置"];
        return;
    }
    if ([self.faultType isEqualToString:@"请选择故障类型"])
    {
        [self showAlertView:@"请选择故障类型"];
        return;
    }
    if ([BXTGlobal isBlankString:cause])
    {
        [self showAlertView:@"请输入故障原因"];
        return;
    }
    if (faulttype_type == 0)
    {
        faulttype_type = 1;
    }
    
    [self showLoadingMBP:@"新工单创建中..."];
    
    BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
    /**请求新建工单**/
    BXTDataRequest *rep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [rep_request createRepair:self.faulttypeID
               faultType_type:self.faulttype_typeID
                    deviceIDs:self.addressIDArray[6]
                   faultCause:cause
                   faultLevel:_repairState
                  depatmentID:departmentInfo.dep_id
                  floorInfoID:self.addressIDArray[0]
                   areaInfoId:self.addressIDArray[2]
                   shopInfoID:self.addressIDArray[4]
                    equipment:@"0"
                   faultNotes:@""
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
    if (section == 3 + indexSection)
    {
        return 80.f;
    }
    
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3 + indexSection)
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
    if (indexPath.section == 3)
    {
        return 150;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4 + indexSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        BXTRemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkCell"];
        if (!cell)
        {
            cell = [[BXTRemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RemarkCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.remarkTV.delegate = self;
        cell.titleLabel.text = @"描   述";
        
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
            cell.detailLable.text = address;
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
                cell.detailLable.frame = CGRectMake(CGRectGetMaxX(cell.titleLabel.frame), 10., SCREEN_WIDTH - CGRectGetMaxX(cell.titleLabel.frame) - 50, 30);
                cell.detailLable.text = self.faultStr;
            }
            self.faultType = cell.detailLable.text;
            cell.checkImgView.hidden = NO;
            cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
            cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
        }
        else if (indexPath.section == 2)
        {
            cell.titleLabel.text = @"等   级";
            cell.emergencyBtn.hidden = NO;
            cell.normelBtn.hidden = NO;
            @weakify(self);
            [[cell.emergencyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                self.repairState = @"1";
                cell.emergencyBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
                [cell.emergencyBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
                cell.normelBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
                [cell.normelBtn setTitleColor:colorWithHexString(@"e2e6e8") forState:UIControlStateNormal];
            }];
            [[cell.normelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                self.repairState = @"2";
                cell.normelBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
                [cell.normelBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
                cell.emergencyBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
                [cell.emergencyBtn setTitleColor:colorWithHexString(@"e2e6e8") forState:UIControlStateNormal];
            }];
        }
        else if (indexPath.section == 4)
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
        shopLocationVC.delegateSignal = [RACSubject subject];
        [shopLocationVC.delegateSignal subscribeNext:^(NSArray *array) {
            self.addressIDArray = [[NSArray alloc] initWithArray:array];
            if ([BXTGlobal isBlankString:self.addressIDArray[5]]) {
                address = [NSString stringWithFormat:@"%@-%@", self.addressIDArray[1], self.addressIDArray[3]];
            }
            else {
                address = [NSString stringWithFormat:@"%@-%@-%@", self.addressIDArray[1], self.addressIDArray[3], self.addressIDArray[5]];
            }
            NSLog(@"--------------- %@", array);
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
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark UITextViewDelegate
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
    cause = textView.text;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
