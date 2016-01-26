//
//  BXTMaintenanceProcessViewController.m
//  BXT
//
//  Created by Jason on 15/9/21.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTMaintenanceProcessViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTSettingTableViewCell.h"
#import "BXTSelectBoxView.h"
#import "BXTFaultInfo.h"
#import "BXTFaultTypeInfo.h"
#import "BXTMaintenanceProcessTableViewCell.h"
#import "BXTMMLogTableViewCell.h"

#define kMMLOG 12
#define kNOTE 11

@interface BXTMaintenanceProcessViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,BXTBoxSelectedTitleDelegate,UIPickerViewDataSource,UIPickerViewDelegate,BXTDataResponseDelegate>
{
    BXTSelectBoxView *boxView;
    BXTFaultInfo     *selectFaultInfo;
    BXTFaultTypeInfo *selectFaultTypeInfo;
    NSMutableArray   *specialArray;//特殊工单类型
    NSMutableArray   *groupArray;
    NSArray          *orderTypeArray;
    NSString         *maintenanceState;
    NSString         *orderType;//工单类型
    NSString         *orderTypeInfo;//工单类型描述
    NSArray          *stateArray;
    NSMutableArray   *fau_dataSource;
    BOOL             isDone;//是否修好的状态
    UIView           *toolView;
}

@property (nonatomic, strong) NSString     *mmLog;
@property (nonatomic, strong) NSString     *groupID;
@property (nonatomic, strong) NSString     *state;
@property (nonatomic, strong) NSString     *notes;
@property (nonatomic ,strong) NSString     *cause;
@property (nonatomic ,assign) NSInteger    repairID;
@property (nonatomic ,strong) NSString     *reaciveTime;
@property (nonatomic, strong) NSString     *specialOID;
@property (nonatomic ,assign) NSInteger    currentFaultID;
@property (nonatomic, strong) UIView       *pickerbackView;
@property (nonatomic, strong) UIPickerView *faultPickView;

@end

@implementation BXTMaintenanceProcessViewController

- (void)dealloc
{
    LogBlue(@"维修过程被释放了");
}

- (instancetype)initWithCause:(NSString *)cause
            andCurrentFaultID:(NSInteger)faultID
                  andRepairID:(NSInteger)repairID
               andReaciveTime:(NSString *)time
{
    self = [super init];
    if (self)
    {
        orderType = @"";
        orderTypeInfo = @"";
        self.state = @"2";
        self.mmLog = @"";
        self.specialOID = @"";
        self.groupID = @"";
        isDone = YES;
        [BXTGlobal shareGlobal].maxPics = 3;
        self.repairID = repairID;
        self.reaciveTime = time;
        self.cause = cause;
        self.currentFaultID = faultID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //侦听删除事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"DeleteTheImage" object:nil];
    
    fau_dataSource = [NSMutableArray array];
    maintenanceState = @"已修好";
    stateArray= @[@"未修好",@"已修好"];

    [self navigationSetting:@"维修过程" andRightTitle:nil andRightImage:nil];
    [self createTableView];
    
    orderTypeArray = @[@"特殊工单"];
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    specialArray = [[NSMutableArray alloc] init];
    groupArray = [[NSMutableArray alloc] init];
    
    /**请求故障类型列表**/
    BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [fau_request faultTypeList];
    
    /**请求特殊工单类型列表**/
    BXTDataRequest *ot_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [ot_request specialOrderTypes];
    
    /**请求分组列表**/
//    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
//    [request propertyGrouping];
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
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    [self.view addSubview:self.currentTableView];
}

#pragma mark -
#pragma mark 创建BoxView
- (void)createBoxView:(NSInteger)section
{
    self.pickerbackView = [[UIView alloc] initWithFrame:self.view.bounds];
    _pickerbackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _pickerbackView.tag = 101;
    [self.view addSubview:_pickerbackView];
    
    if (section == 0)
    {
        [self boxViewWithType:Other andTitle:@"维修状态" andData:stateArray];
    }
    else if (!isDone && section == 1)
    {
        [self boxViewWithType:Other andTitle:@"工单类型" andData:orderTypeArray];
    }
    else if (!isDone && section == 2)
    {
        [self boxViewWithType:SpecialOrderView andTitle:@"类型描述" andData:specialArray];
//        if ([orderType isEqual:@"特殊工单"])
//        {
//            [self boxViewWithType:SpecialOrderView andTitle:@"类型描述" andData:specialArray];
//        }
//        else if ([orderType isEqual:@"协作工单"])
//        {
//            [self boxViewWithType:GroupingView andTitle:@"类型描述" andData:groupArray];
//        }
    }
    else if (!isDone && section == 3)
    {
        self.faultPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        _faultPickView.showsSelectionIndicator = YES;
        _faultPickView.backgroundColor = colorWithHexString(@"cdced1");
        _faultPickView.dataSource = self;
        _faultPickView.delegate = self;
        [self.view addSubview:_faultPickView];
    }
    else if (isDone && section == 1)
    {
        self.faultPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        _faultPickView.showsSelectionIndicator = YES;
        _faultPickView.backgroundColor = colorWithHexString(@"cdced1");
        _faultPickView.dataSource = self;
        _faultPickView.delegate = self;
        [self.view addSubview:_faultPickView];
        
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
            if (self.faultPickView)
            {
                [self.faultPickView removeFromSuperview];
                self.faultPickView = nil;
                [self.pickerbackView removeFromSuperview];
                [self.currentTableView reloadData];
            }
        }];
        [toolView addSubview:sureBtn];
    }
}

- (void)boxViewWithType:(BoxSelectedType)type andTitle:(NSString *)title andData:(NSArray *)array
{
    boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:title boxSelectedViewType:type listDataSource:array markID:nil actionDelegate:self];
    
    [self.view addSubview:boxView];
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
    }];
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((isDone && section == 2) || (!isDone && section == 4))
    {
        return 80.f;
    }
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((isDone && section == 2) || (!isDone && section == 4))
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(10, 20, SCREEN_WIDTH - 20, 50.f);
        [doneBtn setTitle:@"提交" forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        doneBtn.layer.masksToBounds = YES;
        doneBtn.layer.cornerRadius = 4.f;
        @weakify(self);
        [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            /**提交维修中状态**/
            BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
            if ([BXTGlobal isBlankString:self.notes])
            {
                self.notes = @"";
            }
            if ([self.state isEqual:@"1"] && self.specialOID.length == 0)
            {
                [self showMBP:@"特殊类型不能为空！" withBlock:nil];
                return;
            }
            
            NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
            NSString *finishTime = [NSString stringWithFormat:@"%.0f",currentTime];
            NSString *manHours = [NSString stringWithFormat:@"%.1f",(float)([finishTime integerValue] - [self.reaciveTime integerValue])/60/60];
            
            [fau_request maintenanceState:[NSString stringWithFormat:@"%ld",(long)self.repairID]
                           andReaciveTime:self.reaciveTime
                            andFinishTime:finishTime
                      andMaintenanceState:self.state
                             andFaultType:[NSString stringWithFormat:@"%ld",(long)self.currentFaultID]
                              andManHours:manHours
                        andSpecialOrderID:self.specialOID
                                andImages:self.resultPhotos
                                 andNotes:self.notes
                                 andMMLog:self.mmLog
                       andCollectionGroup:self.groupID];
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
    if ((isDone && indexPath.section == 2) || (!isDone && indexPath.section == 4))
    {
        return 170;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!isDone)
    {
        return 5;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isDone && indexPath.section == 2)
    {
        BXTRemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
        {
            cell = [[BXTRemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.remarkTV.delegate = self;
        cell.remarkTV.tag = kNOTE;
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
    if (!isDone && indexPath.section == 4)
    {
        BXTMMLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCell"];
        if (!cell)
        {
            cell = [[BXTMMLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.remarkTV.delegate = self;
        cell.remarkTV.tag = kMMLOG;
        cell.titleLabel.text = @"维修日志";
        
        return cell;
    }
    else
    {
        BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepairCell"];
        if (!cell)
        {
            cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepairCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.checkImgView.hidden = YES;
            cell.detailLable.textAlignment = NSTextAlignmentRight;
            CGRect rect = cell.detailLable.frame;
            rect.size.width -= 12.f;
            cell.detailLable.frame = rect;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (isDone)
        {
            if (indexPath.section == 0)
            {
                cell.titleLabel.text = @"维修状态";
                cell.detailLable.text = maintenanceState;
            }
            else
            {
                cell.titleLabel.text = @"故障类型";
                cell.detailLable.text = _cause;
            }
        }
        else
        {
            if (indexPath.section == 0)
            {
                cell.titleLabel.text = @"维修状态";
                cell.detailLable.text = maintenanceState;
            }
            else if (indexPath.section == 1)
            {
                cell.titleLabel.text = @"工单类型";
                cell.detailLable.text = @"特殊工单";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if (indexPath.section == 2)
            {
                if ([orderType isEqual:@"协作工单"])
                {
                    cell.titleLabel.text = @"协作部门";
                }
                else
                {
                    cell.titleLabel.text = @"特殊类型";
                }
                cell.detailLable.text = orderTypeInfo.length > 0 ? orderTypeInfo : @"请选择类型描述";
            }
            else
            {
                cell.titleLabel.text = @"故障类型";
                cell.detailLable.text = _cause;
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!(!isDone && indexPath.section == 1))
    {
        [self createBoxView:indexPath.section];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (_faultPickView)
        {
            [_faultPickView removeFromSuperview];
            _faultPickView = nil;
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
#pragma mark BXTBoxSelectedTitleDelegate
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    if (type == SpecialOrderView)
    {
        _groupID = @"";
        NSDictionary *dic = obj;
        orderTypeInfo = [dic objectForKey:@"collection"];
        _specialOID = [dic objectForKey:@"id"];
    }
    else if (type == GroupingView)
    {
        _specialOID = @"";
        BXTGroupingInfo *groupInfo = obj;
        orderTypeInfo = groupInfo.subgroup;
        _groupID = groupInfo.group_id;
    }
    else if (type == Other)
    {
        if ([obj isEqualToString:@"未修好"])
        {
            maintenanceState = obj;
            _state = @"1";
            isDone = NO;
        }
        else if ([obj isEqualToString:@"已修好"])
        {
            maintenanceState = obj;
            isDone = YES;
            _state = @"2";
        }
        else
        {
            orderType = obj;
        }
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
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag == kNOTE)
    {
        if ([textView.text isEqualToString:@"请输入维修内容"])
        {
            textView.text = @"";
        }
    }
    else
    {
        if ([textView.text isEqualToString:@"请输入维修日志"])
        {
            textView.text = @"";
        }
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == kNOTE)
    {
        _notes = textView.text;
        if (textView.text.length < 1)
        {
            textView.text = @"请输入维修内容";
        }
    }
    else
    {
        _mmLog = textView.text;
        if (textView.text.length < 1)
        {
            textView.text = @"请输入维修日志";
        }
    }
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
        if (faultTypesArray.count > 0)
        {
            selectFaultTypeInfo = faultTypesArray[0];
        }
        else
        {
            BXTFaultTypeInfo *faultTypeInfo = [[BXTFaultTypeInfo alloc] init];
            faultTypeInfo.faulttype = @"";
            faultTypeInfo.fau_id = 1;
            selectFaultTypeInfo = faultTypeInfo;
        }
        [pickerView reloadComponent:1];
    }
    else
    {
        NSArray *faultTypesArray = selectFaultInfo.sub_data;
        selectFaultTypeInfo = faultTypesArray[row];
        _currentFaultID = selectFaultTypeInfo.fau_id;
    }
    if (selectFaultTypeInfo.faulttype.length > 0)
    {
        _cause = [NSString stringWithFormat:@"%@-%@",selectFaultInfo.faulttype_type,selectFaultTypeInfo.faulttype];
    }
    else
    {
        _cause = selectFaultInfo.faulttype_type;
    }
    [self.currentTableView reloadData];
}

#pragma mark -
#pragma mark 请求返回代理
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == FaultType)
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
                
                if (faultTypeObj.fau_id == _currentFaultID)
                {
                    selectFaultInfo = faultObj;
                    selectFaultTypeInfo = faultTypeObj;
                }
                
                [fault_subs addObject:faultTypeObj];
            }
            
            faultObj.sub_data = fault_subs;
            [fau_dataSource addObject:faultObj];
        }
    }
    else if (type == MaintenanceProcess)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
            __weak typeof(self) weakSelf = self;
            [self showMBP:@"更改成功！" withBlock:^(BOOL hidden) {
                if (weakSelf.BlockRefresh)
                {
                    weakSelf.BlockRefresh();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
    else if (type == SpecialOrderTypes)
    {
        if ([data count])
        {
            [specialArray addObjectsFromArray:data];
        }
    }
    else if (type == PropertyGrouping)
    {
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
