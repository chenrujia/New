//
//  BXTMTReportsViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTReportsViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTMTReportsCell.h"
#import "UIImage+SubImage.h"
#import "BXTFaultInfo.h"
#import "BXTShopLocationViewController.h"
#import "BXTAddOtherManViewController.h"
#import "BXTAddOtherManInfo.h"
#import "BXTChooseFaultViewController.h"
#import "BXTMTAddImageCell.h"

#define MOBILE 11
#define CAUSE 12

@interface BXTMTReportsViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,BXTDataResponseDelegate>
{
    BXTFaultTypeInfo *fault_type_info;
    BXTFaultInfo     *selectFaultInfo;
    BXTFaultTypeInfo *selectFaultTypeInfo;
    NSMutableArray   *dep_dataSource;
    NSMutableArray   *fau_dataSource;
    NSString         *cause;
    
    
    NSMutableArray   *manIDs;
    NSInteger        faulttype_type;
    NSString         *address;
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

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BXTMTReportsViewController

- (void)dealloc
{
    LogBlue(@"新建报修释放了。。。");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //侦听删除事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"DeleteTheImage" object:nil];
    
    manIDs = [NSMutableArray array];
    self.mans = [NSMutableArray array];
    [BXTGlobal shareGlobal].maxPics = 4;
    self.repairState = @"2";
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
    dep_dataSource = [[NSMutableArray alloc] init];
    fau_dataSource = [[NSMutableArray alloc] init];
    address = @"请选择位置";
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"维修结果", @"维修位置", @"故障类型", @"", @"", @"结束时间", nil];
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"请选择", @"请选择", @"请选择", @"", @"", @"请选择", nil];
    
    [self navigationSetting:@"维修报告" andRightTitle:nil andRightImage:nil];
    [self createUI];
    
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
- (void)createUI
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70.f)];
    self.currentTableView = [[UITableView alloc] initWithFrame:backView.bounds style:UITableViewStyleGrouped];
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    [backView addSubview:self.currentTableView];
    [self.view addSubview:backView];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70.f, SCREEN_WIDTH, 70.f)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake((SCREEN_WIDTH-200)/2, 10, 200, 50.f);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 4.f;
    @weakify(self);
    [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self sureBtnClick];
    }];
    [footerView addSubview:doneBtn];
}

- (void)createMTReports
{
    
}

- (void)sureBtnClick
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
                   faultLevel:self.repairState
                  depatmentID:departmentInfo.dep_id
                  floorInfoID:self.addressIDArray[0]
                   areaInfoId:self.addressIDArray[2]
                   shopInfoID:self.addressIDArray[4]
                    equipment:@"0"
                   faultNotes:@""
                   imageArray:self.resultPhotos
              repairUserArray:manIDs];
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
    return 0.1f;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4)
    {
        return 130;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        [self createMTReports];
    }
    else if (indexPath.section == 4)
    {
        BXTMTAddImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkCell"];
        if (!cell)
        {
            cell = [[BXTMTAddImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RemarkCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = @"维修后照片";
        
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
    
    
    BXTMTReportsCell *cell = [BXTMTReportsCell cellWithTableViewCell:tableView];
    
    cell.titleView.text = self.titleArray[indexPath.section];
    cell.detailView.text = self.dataArray[indexPath.section];
    
    return cell;
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            [BXTDepartmentInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"dep_id":@"id"};
            }];
            [dep_dataSource addObjectsFromArray:[BXTDepartmentInfo mj_objectArrayWithKeyValuesArray:data]];
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
