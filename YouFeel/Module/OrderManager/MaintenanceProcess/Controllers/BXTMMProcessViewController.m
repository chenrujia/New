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
#import "BXTSearchPlaceViewController.h"
#import "BXTSelectBoxView.h"
#import "BXTRepairDetailInfo.h"
#import "BXTSpecialOrderInfo.h"
#import "ANKeyValueTable.h"

@interface BXTMMProcessViewController ()<BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate,UITextViewDelegate>
{
    BOOL  isDone;//是否修好的状态
}

@property (nonatomic, strong) NSMutableArray      *fau_dataSource;
@property (nonatomic, strong) NSMutableArray      *specialOrderArray;
@property (nonatomic, strong) NSMutableArray      *deviceStateArray;
@property (nonatomic, strong) NSArray             *stateArray;
@property (nonatomic, copy  ) NSString            *maintenanceState;
@property (nonatomic, copy  ) NSString            *repairID;
@property (nonatomic, copy  ) NSString            *deviceState;
@property (nonatomic, copy  ) NSString            *state;
@property (nonatomic, copy  ) NSString            *mmLog;
@property (nonatomic, copy  ) NSString            *repairPlace;
@property (nonatomic, copy  ) NSString            *faultTypeID;
@property (nonatomic, assign) NSInteger           number;
@property (nonatomic, strong) BXTSelectBoxView    *boxView;
@property (nonatomic, strong) BXTDeviceMMListInfo *deviceInfo;
@property (nonatomic, strong) BXTFaultInfo        *choosedFaultInfo;
@property (nonatomic, strong) BXTPlaceInfo        *choosedPlaceInfo;
@property (nonatomic, strong) BXTDeviceStateInfo  *choosedStateInfo;
@property (nonatomic, strong) BXTSpecialOrderInfo *choosedReasonInfo;

@end

@implementation BXTMMProcessViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                       repairID:(NSString *)repairID
                        placeID:(NSString *)placeID
                      placeName:(NSString *)placeName
                    faultTypeID:(NSString *)faultTypeID
                  faultTypeName:(NSString *)faultTypeName
                 maintenceNotes:(NSString *)notes
                     deviceList:(NSArray *)devices
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.repairID = repairID;
        self.number = 0;
        if (devices.count == 1)
        {
            self.deviceInfo = devices[0];
            self.number = 2;
        }
        isDone = YES;
        self.state = @"2";
        self.maintenanceState = @"已修好";
        self.mmLog = notes;
        self.faultTypeID = faultTypeID;
        
        if (![BXTGlobal isBlankString:placeID]) {
            BXTPlaceInfo *placeInfo = [BXTPlaceInfo new];
            placeInfo.placeID = placeID;
            placeInfo.place = placeName;
            self.repairPlace = placeName;
            self.choosedPlaceInfo = placeInfo;
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维修过程" andRightTitle:nil andRightImage:nil];
    self.doneBtn.layer.cornerRadius = 4.f;
    [self.currentTable registerClass:[BXTPhotosTableViewCell class] forCellReuseIdentifier:@"PhotosCell"];
    [self.currentTable registerClass:[BXTMMLogTableViewCell class] forCellReuseIdentifier:@"LogCell"];
    [self.currentTable registerClass:[BXTSettingTableViewCell class] forCellReuseIdentifier:@"NormalCell"];
    
    self.fau_dataSource = [NSMutableArray array];
    self.specialOrderArray = [NSMutableArray array];
    self.deviceStateArray = [NSMutableArray array];
    self.stateArray = @[@"未修好",@"已修好"];
    
    dispatch_queue_t queue = dispatch_queue_create("NormalQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        /**请求故障类型列表**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request faultTypeListWithRTaskType:@"1" more:@"1"];
    });
    dispatch_async(queue, ^{
        /**请求未修好原因**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request specialWorkOrder];
    });
    if (self.deviceInfo)
    {
        dispatch_async(queue, ^{
            /**请求设备状态**/
            BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
            [fau_request deviceStates];
        });
    }
}

#pragma mark -
#pragma mark 创建BoxView
- (void)createBoxView:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    backView.tag = 101;
    [self.view addSubview:backView];

    if (section == 2 && self.number)
    {
        [self boxViewWithType:OrderDeviceStateView andTitle:@"设备状态" andData:self.deviceStateArray];
    }
    else if (section == 1 + self.number)
    {
        [self boxViewWithType:FaultTypeView andTitle:@"故障类型" andData:self.fau_dataSource];
    }
    else if (section == 2 + self.number)
    {
        [self boxViewWithType:OtherView andTitle:@"维修结果" andData:self.stateArray];
    }
    else if (section == 3 + self.number)
    {
        [self boxViewWithType:SpecialSeasonView andTitle:@"未修好原因" andData:self.specialOrderArray];
    }
}

- (void)boxViewWithType:(BoxSelectedType)type andTitle:(NSString *)title andData:(NSArray *)array
{
    self.boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250.f) boxTitle:title boxSelectedViewType:type listDataSource:array markID:nil actionDelegate:self];
    [self.view addSubview:self.boxView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 250.f, SCREEN_WIDTH, 250.f)];
    }];
}

- (IBAction)doneClick:(id)sender
{
    if (!self.choosedPlaceInfo)
    {
        [self showMBP:@"请您确定维修位置" withBlock:nil];
        return;
    }
    else if (self.deviceInfo && !self.choosedStateInfo)
    {
        [self showMBP:@"请您确定设备状态" withBlock:nil];
        return;
    }
    else if (!self.choosedFaultInfo)
    {
        [self showMBP:@"请您确定故障类型" withBlock:nil];
        return;
    }
    else if ([self.state isEqualToString:@"1"] && !self.choosedReasonInfo)
    {
        [self showMBP:@"请您确定未完成原因" withBlock:nil];
        return;
    }
    else if (self.number && !self.choosedStateInfo)
    {
        [self showMBP:@"请您确定设备状态" withBlock:nil];
        return;
    }
    
    [self showLoadingMBP:@"请稍后..."];
    /**提交维修中状态**/
    NSString *deviceState = nil;
    if (self.choosedStateInfo)
    {
        deviceState = self.choosedStateInfo.param_key;
    }
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request maintenanceState:self.repairID
                      placeID:self.choosedPlaceInfo.placeID
                  deviceState:deviceState
                   orderState:self.state
                    faultType:self.choosedFaultInfo.fault_id
                     reasonID:self.choosedReasonInfo.param_key
                        mmLog:self.mmLog
                       images:self.resultPhotos];
}

- (void)handleActionWithIndexPath:(NSIndexPath *)indexPath
{
    //维修位置
    if (indexPath.section == 0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTSearchPlaceViewController *searchVC = (BXTSearchPlaceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTSearchPlaceViewController"];
        NSArray *dataSource = [[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE];
        @weakify(self);
        [searchVC userChoosePlace:dataSource isProgress:YES type:PlaceSearchType block:^(BXTBaseClassifyInfo *classifyInfo,NSString *name) {
            @strongify(self);
            BXTPlaceInfo *placeInfo = (BXTPlaceInfo *)classifyInfo;
            self.choosedPlaceInfo = placeInfo;
            self.repairPlace = name;
            [self.currentTable reloadData];
        }];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    //故障类型
    else if (indexPath.section == 1 + self.number)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
        BXTSearchPlaceViewController *searchVC = (BXTSearchPlaceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTSearchPlaceViewController"];
        searchVC.faultTypeID = self.faultTypeID;
        @weakify(self);
        [searchVC userChoosePlace:self.fau_dataSource isProgress:NO type:FaultSearchType block:^(BXTBaseClassifyInfo *classifyInfo,NSString *name) {
            @strongify(self);
            BXTFaultInfo *faultInfo = (BXTFaultInfo *)classifyInfo;
            self.choosedFaultInfo = faultInfo;
            [self.currentTable reloadData];
        }];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    else if (!(indexPath.section == 5 + self.number) && !(indexPath.section == 6 + self.number) && !(!isDone && indexPath.section == 5 + self.number) && !(isDone && indexPath.section == 4 + self.number))
    {
        [self createBoxView:indexPath.section];
    }
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
    if ((isDone && (indexPath.section == 3 + self.number || indexPath.section == 4 + self.number)) || (!isDone && (indexPath.section == 4 + self.number || indexPath.section == 5 + self.number)))
    {
        return 110;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!isDone)
    {
        return 7 + self.number;
    }
    return 6 + self.number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //维修记录
    if ((!isDone && indexPath.section == 4 + self.number) || (isDone && indexPath.section == 3 + self.number))
    {
        BXTMMLogTableViewCell *logCell = [tableView dequeueReusableCellWithIdentifier:@"LogCell" forIndexPath:indexPath];
        
        logCell.titleLabel.text = @"维修记录";
        logCell.remarkTV.delegate = self;
        if (self.mmLog.length)
        {
            logCell.remarkTV.text = self.mmLog;
        }
        
        return logCell;
    }
    //维修后图片
    else if ((!isDone && indexPath.section == 5 + self.number) || (isDone && indexPath.section == 4 + self.number))
    {
        BXTPhotosTableViewCell *photosCell = [tableView dequeueReusableCellWithIdentifier:@"PhotosCell" forIndexPath:indexPath];
        
        photosCell.titleLabel.text = @"维修后图片";
        //添加图片点击事件
        @weakify(self);
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
        [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:photosCell.photosView.imgViewOne.tag];
        }];
        [photosCell.photosView.imgViewOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
        [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:photosCell.photosView.imgViewTwo.tag];
        }];
        [photosCell.photosView.imgViewTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
        [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:photosCell.photosView.imgViewThree.tag];
        }];
        [photosCell.photosView.imgViewThree addGestureRecognizer:tapGRThree];
        [photosCell.photosView.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
        self.photosView = photosCell.photosView;
        
        return photosCell;
    }
    //其他
    else
    {
        BXTSettingTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
        normalCell.detailLable.textAlignment = NSTextAlignmentRight;
        normalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.section == 0)
        {
            normalCell.titleLabel.text = @"维修位置";
            if (self.choosedPlaceInfo)
            {
                normalCell.detailLable.text = self.repairPlace;
            }
            else
            {
                normalCell.detailLable.text = @"请选择";
            }
        }
        else
        {
            if (isDone)
            {
                if (indexPath.section == 1 && self.number)
                {
                    normalCell.titleLabel.text = @"设备";
                    normalCell.detailLable.text = self.deviceInfo.name;
                    normalCell.accessoryType = UITableViewCellAccessoryNone;
                }
                else if (indexPath.section == 2 && self.number)
                {
                    normalCell.titleLabel.text = @"设备状态";
                    if (self.choosedStateInfo)
                    {
                        normalCell.detailLable.text = self.choosedStateInfo.param_value;
                    }
                    else
                    {
                        normalCell.detailLable.text = @"请选择";
                    }
                }
                else if (indexPath.section == 1 + self.number)
                {
                    normalCell.titleLabel.text = @"故障类型";
                    if (self.choosedFaultInfo)
                    {
                        normalCell.detailLable.text = self.choosedFaultInfo.faulttype;
                    }
                    else
                    {
                        normalCell.detailLable.text = @"请选择";
                    }
                }
                else if (indexPath.section == 2 + self.number)
                {
                    normalCell.titleLabel.text = @"维修结果";
                    normalCell.detailLable.text = self.maintenanceState;
                }
                else if (indexPath.section == 5 + self.number)
                {
                    normalCell.titleLabel.text = @"结束时间";
                    NSDate *now = [NSDate date];
                    NSString *dateStr = [BXTGlobal transTimeWithDate:now withType:@"yyyy-MM-dd HH:mm"];
                    normalCell.detailLable.text = dateStr;
                    normalCell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                if (indexPath.section == 1 && self.number)
                {
                    normalCell.titleLabel.text = @"设备";
                    normalCell.detailLable.text = self.deviceInfo.name;
                    normalCell.accessoryType = UITableViewCellAccessoryNone;
                }
                else if (indexPath.section == 2 && self.number)
                {
                    normalCell.titleLabel.text = @"设备状态";
                    normalCell.detailLable.text = self.deviceState;
                }
                else if (indexPath.section == 1 + self.number)
                {
                    normalCell.titleLabel.text = @"故障类型";
                    if (self.choosedFaultInfo)
                    {
                        normalCell.detailLable.text = self.choosedFaultInfo.faulttype;
                    }
                    else
                    {
                        normalCell.detailLable.text = @"请选择";
                    }
                }
                else if (indexPath.section == 2 + self.number)
                {
                    normalCell.titleLabel.text = @"维修结果";
                    normalCell.detailLable.text = self.maintenanceState;
                }
                else if (indexPath.section == 3 + self.number)
                {
                    normalCell.titleLabel.text = @"未修好原因";
                    if (self.choosedReasonInfo)
                    {
                        normalCell.detailLable.text = self.choosedReasonInfo.param_value;
                    }
                    else
                    {
                        normalCell.detailLable.text = @"请选择";
                    }
                }
                else if (indexPath.section == 6 + self.number)
                {
                    normalCell.titleLabel.text = @"结束时间";
                    NSDate *now = [NSDate date];
                    NSString *dateStr = [BXTGlobal transTimeWithDate:now withType:@"yyyy-MM-dd HH:mm"];
                    normalCell.detailLable.text = dateStr;
                    normalCell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
        
        return normalCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self handleActionWithIndexPath:indexPath];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        [UIView animateWithDuration:0.3f animations:^{
            [self.boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250.f)];
        } completion:^(BOOL finished) {
            [self.boxView removeFromSuperview];
            self.boxView = nil;
        }];
        [view removeFromSuperview];
    }
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入维修日志（少于200字）"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.mmLog = textView.text;
    if (textView.text.length < 1)
    {
        textView.text = @"请输入维修日志（少于200字）";
    }
}

#pragma mark -
#pragma mark BXTBoxSelectedTitleDelegate
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    UIView *view = [self.view viewWithTag:101];
    [view removeFromSuperview];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    } completion:^(BOOL finished) {
        [self.boxView removeFromSuperview];
        self.boxView = nil;
    }];
    
    if (!obj)
    {
        return;
    }
    if (type == FaultTypeView)
    {
        BXTFaultInfo *faultInfo = obj;
        self.choosedFaultInfo = faultInfo;
    }
    else if (type == OrderDeviceStateView)
    {
        BXTDeviceStateInfo *stateInfo = obj;
        self.choosedStateInfo = stateInfo;
    }
    else if (type == SpecialSeasonView)
    {
        BXTSpecialOrderInfo *orderInfo = obj;
        self.choosedReasonInfo = orderInfo;
    }
    else if (type == OtherView)
    {
        if ([obj isEqualToString:@"未修好"])
        {
            self.maintenanceState = obj;
            self.state = @"1";
            isDone = NO;
        }
        else if ([obj isEqualToString:@"已修好"])
        {
            self.maintenanceState = obj;
            isDone = YES;
            self.state = @"2";
        }
    }
    
    [self.currentTable reloadData];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
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
    else if (type == SpecialOrder)
    {
        [BXTSpecialOrderInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"specialOrderID":@"id"};
        }];
        [self.specialOrderArray addObjectsFromArray:[BXTSpecialOrderInfo mj_objectArrayWithKeyValuesArray:data]];
    }
    else if (type == DeviceState)
    {
        [BXTDeviceStateInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"stateID":@"id"};
        }];
        [self.deviceStateArray addObjectsFromArray:[BXTDeviceStateInfo mj_objectArrayWithKeyValuesArray:data]];
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
