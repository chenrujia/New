//
//  BXTMaintenanceViewController.m
//  YouFeel
//
//  Created by Jason on 16/1/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenanceViewController.h"
#import "BXTSettingTableViewCell.h"
#import <objc/runtime.h>
#import "BXTHeaderForVC.h"
#import "BXTStandardViewController.h"
#import "BXTChangeStateViewController.h"
#import "SDWebImageManager.h"
#import "BXTDeviceStateViewController.h"

@interface BXTMaintenanceViewController ()<BXTDataResponseDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

//维保项目列表
@property (nonatomic, strong) NSMutableArray *maintenanceProes;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;

@end

@implementation BXTMaintenanceViewController

- (void)dealloc
{
    LogBlue(@"被释放了。。。。。");
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                      maintence:(BXTDeviceMaintenceInfo *)maintence
                       deviceID:(NSString *)devID
                deviceStateList:(NSArray *)states
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.state = @"1";
        self.name = @"正常";
        self.notes = @"";
        self.instruction = @"";
        self.maintenceInfo = maintence;
        self.maintenanceProes = [NSMutableArray array];
        //过滤check_arr空的情况
        for (BXTDeviceInspectionInfo *inspection in self.maintenceInfo.inspection_info)
        {
            if (inspection.check_arr.count)
            {
                [self.maintenanceProes addObject:inspection];
            }
        }
        self.deviceID = devID;
        self.deviceStates = states;
        if (maintence.device_state)
        {
            self.state = maintence.device_state;
            self.name = maintence.device_state_name;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维保作业" andRightTitle:nil andRightImage:nil];
    //定位
    [self locationPoint];
    //侦听删除事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"DeleteTheImage" object:nil];
    
    self.currentTableView = self.currentTable;
    for (NSDictionary *imgDic in _maintenceInfo.pic)
    {
        NSString *img_url_str = [imgDic objectForKey:@"photo_file"];
        @weakify(self);
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:img_url_str] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image)
            {
                @strongify(self);
                [self.selectPhotos addObject:image];
                [self.resultPhotos addObject:image];
                [self.currentTable reloadData];
            }
        }];
    }
    _commitBtn.layer.cornerRadius = 4.f;
    @weakify(self);
    [[_commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        for (BXTDeviceInspectionInfo *inspectionInfo in self.maintenanceProes)
        {
            for (BXTDeviceCheckInfo *checkProjectInfo in inspectionInfo.check_arr)
            {
                NSString *key = checkProjectInfo.check_key;
                NSString *value = checkProjectInfo.default_description;
                [dictionary setObject:value forKey:key];
            }
        }
        NSString *jsonStr = [self dataToJsonString:dictionary];
        [self showLoadingMBP:@"正在上传..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        if (self.isUpdate)
        {
            [request updateInspectionRecordID:self.maintenceInfo.maintenceID
                                     deviceID:self.deviceID
                              andInspectionID:self.maintenceInfo.inspection_item_id
                            andInspectionData:jsonStr
                                     andNotes:self.notes
                                     andState:self.state
                                    andImages:self.resultPhotos
                                 andLongitude:self.longitude
                                  andLatitude:self.latitude
                                      andDesc:self.instruction];
        }
        else
        {
            [request addInspectionRecord:self.maintenceInfo.maintenceID
                                deviceID:self.deviceID
                         andInspectionID:self.maintenceInfo.inspection_item_id
                       andInspectionData:jsonStr
                                andNotes:self.notes
                                andState:self.state
                               andImages:self.resultPhotos
                            andLongitude:self.longitude
                             andLatitude:self.latitude
                                 andDesc:self.instruction];
        }
    }];
}

- (void)locationPoint
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if (IS_IOS_8)
    {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        [locationManager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
    }
    locationManager.distanceFilter = kCLDistanceFilterNone; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    if ([CLLocationManager locationServicesEnabled])
    {
        [locationManager startUpdatingLocation];
    }
    else
    {
        NSLog(@"请开启定位功能！");
    }
}

- (void)deleteImage:(NSNotification *)notification
{
    NSNumber *number = notification.object;
    [self handleData:[number integerValue]];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"%@",locations);
    CLLocation *location = locations[0];
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    NSLog(@"纬度:%f",location.coordinate.latitude);
    NSLog(@"经度:%f",location.coordinate.longitude);
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

#pragma mark -
#pragma mark UITableDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == self.maintenanceProes.count + 2)
    {
        return 0.1f;
    }
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == self.maintenanceProes.count + 2)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.f)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., SCREEN_WIDTH - 30.f, 30)];
    titleLabel.textColor = colorWithHexString(@"000000");
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    if (section == self.maintenanceProes.count + 1)
    {
        titleLabel.text = @"设备状态";
    }
    else
    {
        BXTDeviceInspectionInfo *inspectionInfo = self.maintenanceProes[section - 1];
        titleLabel.text = inspectionInfo.check_item;
    }
    [view addSubview:titleLabel];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 + self.maintenanceProes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == self.maintenanceProes.count + 2)
    {
        return 1;
    }
    BXTDeviceInspectionInfo *inspection = self.maintenanceProes[section - 2];
    return inspection.check_arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.maintenanceProes.count + 2)
    {
        return 170;
    }
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.maintenanceProes.count + 2)
    {
//        BXTRemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarksTableViewCell"];
//        if (!cell)
//        {
//            cell = [[BXTRemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RemarksTableViewCell"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        cell.remarkTV.delegate = self;
//        cell.titleLabel.text = @"备   注";
//        cell.remarkTV.text = self.maintenceInfo.notes;
//        self.indexPath = indexPath;
//        
//        [cell handleImagesFrame:self.maintenceInfo.pic];
//        
//        @weakify(self);
//        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
//        [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
//            @strongify(self);
//            //展示大图
//            self.mwPhotosArray = [self containAllPhotos:self.maintenceInfo.pic];
//            [self loadMWPhotoBrowser:cell.imgViewOne.tag];
//        }];
//        [cell.imgViewOne addGestureRecognizer:tapGROne];
//        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
//        [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
//            @strongify(self);
//            self.mwPhotosArray = [self containAllPhotos:self.maintenceInfo.pic];
//            [self loadMWPhotoBrowser:cell.imgViewTwo.tag];
//        }];
//        [cell.imgViewTwo addGestureRecognizer:tapGRTwo];
//        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
//        [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
//            @strongify(self);
//            self.mwPhotosArray = [self containAllPhotos:self.maintenceInfo.pic];
//            [self loadMWPhotoBrowser:cell.imgViewThree.tag];
//        }];
//        [cell.imgViewThree addGestureRecognizer:tapGRThree];
//        
//        [cell.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
        //TODO: 处理下BXTRemarksTableViewCell的问题
        UITableViewCell *cell = [UITableViewCell new];
        return cell;
    }
    else
    {
        BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTenanceCell"];
        if (!cell)
        {
            cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainTenanceCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.frame = CGRectMake(15.f, 15.f, 120.f, 20);
            cell.detailLable.textAlignment = NSTextAlignmentRight;
        }
        if (indexPath.section == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.checkImgView.hidden = YES;
            cell.detailLable.hidden = YES;
            cell.titleLabel.text = @"设备操作规范";
        }
        else if (indexPath.section == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.checkImgView.hidden = YES;
            cell.titleLabel.text = @"设备当前状态";
            cell.detailLable.hidden = NO;
            
            cell.detailLable.text = self.name;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.checkImgView.hidden = YES;
            BXTDeviceInspectionInfo *inspection = self.maintenanceProes[indexPath.section - 2];
            BXTDeviceCheckInfo *checkProject = inspection.check_arr[indexPath.row];
            cell.titleLabel.text = checkProject.check_con;
            cell.detailLable.hidden = NO;
            cell.detailLable.text = checkProject.default_description;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //操作规范
    if (indexPath.section == 0)
    {
        BXTStandardViewController *standardVC = [[BXTStandardViewController alloc] init];
        [self.navigationController pushViewController:standardVC animated:YES];
    }
    else if (indexPath.section == 1)
    {
        @weakify(self);
        BXTDeviceStateViewController *stateVC = [[BXTDeviceStateViewController alloc] initWithArray:self.deviceStates deviceState:self.state stateBlock:^(NSString *name, NSString *state, NSString *notes) {
            @strongify(self);
            self.name = name;
            self.state = state;
            self.instruction = notes;
            [self.currentTableView reloadData];
        }];
        [self.navigationController pushViewController:stateVC animated:YES];
    }
    else
    {
        //维保项目
        if (indexPath.row != self.maintenanceProes.count + 2)
        {
            BXTDeviceInspectionInfo *inspectionInfo = self.maintenanceProes[indexPath.section - 2];
            BXTDeviceCheckInfo *checkProject = inspectionInfo.check_arr[indexPath.row];
            BXTChangeStateViewController *changeStateVC = [[BXTChangeStateViewController alloc] initWithNibName:@"BXTChangeStateViewController" bundle:nil withNotes:checkProject.default_description withTitle:inspectionInfo.check_item withDetail:checkProject.check_con];
            @weakify(self);
            [changeStateVC valueChanged:^(NSString *text) {
                @strongify(self);
                
                checkProject.default_description = text;
                NSMutableArray *tempIns = [NSMutableArray arrayWithArray:inspectionInfo.check_arr];
                [tempIns replaceObjectAtIndex:indexPath.row withObject:checkProject];
                inspectionInfo.check_arr = tempIns;
                NSMutableArray *tempInsInfos = [NSMutableArray arrayWithArray:self.maintenanceProes];
                [tempInsInfos replaceObjectAtIndex:indexPath.section - 2 withObject:inspectionInfo];
                self.maintenanceProes = tempInsInfos;
                
                [self.currentTable reloadData];
            }];
            [self.navigationController pushViewController:changeStateVC animated:YES];
        }
    }
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入维保内容"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.notes = textView.text;
    if (textView.text.length < 1)
    {
        textView.text = @"请输入维保内容";
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        if (type == Add_Inspection)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:nil];
            [self showMBP:@"新建维保作业成功！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else if (type == Update_Inspection)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:nil];
            [self showMBP:@"更新维保作业成功！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
    else if ([[dic objectForKey:@"returncode"] isEqual:@"006"])
    {
        [self showMBP:@"此次作业已经提交，不得重复提交！" withBlock:nil];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
