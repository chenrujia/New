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
#import "BXTRemarksTableViewCell.h"
#import "HySideScrollingImagePicker.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "BXTSelectBoxView.h"
#import "LocalPhotoViewController.h"
#import "BXTFaultInfo.h"
#import "BXTFaultTypeInfo.h"
#import "BXTMaintenanceProcessTableViewCell.h"
#import "BXTMMLogTableViewCell.h"

#define kMMLOG 12
#define kNOTE 11

@interface BXTMaintenanceProcessViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MWPhotoBrowserDelegate,SelectPhotoDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,BXTBoxSelectedTitleDelegate,UIPickerViewDataSource,UIPickerViewDelegate,BXTDataResponseDelegate>
{
    UITableView      *currentTableView;
    NSMutableArray   *photosArray;
    NSMutableArray   *selectPhotos;
    NSMutableArray   *specialArray;//特殊工单类型
    NSMutableArray   *groupArray;
    NSArray          *orderTypeArray;
    NSString         *notes;
    NSString         *maintenanceState;
    NSString         *orderType;//工单类型
    NSString         *orderTypeInfo;//工单类型描述
    BXTSelectBoxView *boxView;
    NSArray          *stateArray;
    UIPickerView     *faultPickView;
    NSMutableArray   *fau_dataSource;
    BXTFaultInfo     *selectFaultInfo;
    BXTFaultTypeInfo *selectFaultTypeInfo;
    NSString         *state;
    NSString         *mmLog;
    NSString         *specialOID;
    NSString         *groupID;
    BOOL             isDone;//是否修好的状态
    
    UIView *pickerbackView;
    UIView *toolView;
}

@property (nonatomic ,strong) NSMutableArray *mwPhotosArray;
@property (nonatomic ,strong) NSString       *cause;
@property (nonatomic ,assign) NSInteger      currentFaultID;
@property (nonatomic ,assign) NSInteger      repairID;
@property (nonatomic ,strong) NSString       *reaciveTime;

@end

@implementation BXTMaintenanceProcessViewController

- (instancetype)initWithCause:(NSString *)cause andCurrentFaultID:(NSInteger)faultID andRepairID:(NSInteger)repairID andReaciveTime:(NSString *)time
{
    self = [super init];
    if (self)
    {
        orderType = @"";
        orderTypeInfo = @"";
        state = @"2";
        mmLog = @"";
        specialOID = @"";
        groupID = @"";
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
    
    fau_dataSource = [NSMutableArray array];
    maintenanceState = @"已修好";
    stateArray= @[@"未修好",@"已修好"];

    [self navigationSetting:@"维修过程" andRightTitle:nil andRightImage:nil];
    [self createTableView];
    
    orderTypeArray = @[@"特殊工单",@"协作工单"];
    photosArray = [[NSMutableArray alloc] init];
    selectPhotos = [[NSMutableArray alloc] init];
    specialArray = [[NSMutableArray alloc] init];
    groupArray = [[NSMutableArray alloc] init];
    
    /**请求故障类型列表**/
    BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [fau_request faultTypeList];
    
    /**请求特殊工单类型列表**/
    BXTDataRequest *ot_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [ot_request specialOrderTypes];
    
    /**请求分组列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request propertyGrouping];
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
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 事件处理
- (void)doneClick
{
    /**提交维修中状态**/
    BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
    
    if ([BXTGlobal isBlankString:notes])
    {
        notes = @"";
    }
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    NSString *finishTime = [NSString stringWithFormat:@"%.0f",currentTime];
    NSString *manHours = [NSString stringWithFormat:@"%.1f",(float)([finishTime integerValue] - [_reaciveTime integerValue])/60/60];
    
    [fau_request maintenanceState:[NSString stringWithFormat:@"%ld",(long)_repairID]
                   andReaciveTime:_reaciveTime
                    andFinishTime:finishTime
              andMaintenanceState:state
                     andFaultType:[NSString stringWithFormat:@"%ld",(long)_currentFaultID]
                      andManHours:manHours
                andSpecialOrderID:specialOID
                        andImages:photosArray
                         andNotes:notes
                         andMMLog:mmLog
               andCollectionGroup:groupID];
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGR
{
    UIView *tapView = [tapGR view];
    [self loadMWPhotoBrowser:tapView.tag];
}

- (void)addImages
{
    HySideScrollingImagePicker *hy = [[HySideScrollingImagePicker alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"拍摄",@"从相册选择"]];
    hy.isMultipleSelection = NO;
    hy.SeletedImages = ^(NSArray *GetImages, NSInteger Buttonindex){
        switch (Buttonindex) {
            case 1:
            {
                if (GetImages.count != 0)
                {
                    [selectPhotos removeAllObjects];
                    [photosArray removeAllObjects];
                    //取原图
                    [selectPhotos addObjectsFromArray:GetImages];
                    [self selectImages];
                }
                else
                {
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
                    {
                        if (IS_IOS_8)
                        {
                            UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请为报修通开放相机权限：手机设置->隐私->相机->报修通（打开）" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                            [alertCtr addAction:alertAction];
                            [self presentViewController:alertCtr animated:YES completion:nil];
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法启动相机"
                                                                            message:@"请为报修通开放相机权限：手机设置->隐私->相机->报修通（打开）"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                    else
                    {
                        [self selectCamenaType:UIImagePickerControllerSourceTypeCamera];
                    }
                }
            }
                break;
            case 2:
            {
                LocalPhotoViewController *pick=[[LocalPhotoViewController alloc] init];
                pick.selectPhotoDelegate = self;
                pick.selectPhotos = selectPhotos;
                [self.navigationController pushViewController:pick animated:YES];
            }
                break;
            default:
                break;
        }
    };
    
    [self.view addSubview:hy];
}

#pragma mark -
#pragma mark 创建BoxView
- (void)createBoxView:(NSInteger)section
{
    pickerbackView = [[UIView alloc] initWithFrame:self.view.bounds];
    pickerbackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    pickerbackView.tag = 101;
    [self.view addSubview:pickerbackView];
    
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
        if ([orderType isEqual:@"特殊工单"])
        {
            [self boxViewWithType:SpecialOrderView andTitle:@"类型描述" andData:specialArray];
        }
        else if ([orderType isEqual:@"协作工单"])
        {
            [self boxViewWithType:GroupingView andTitle:@"类型描述" andData:groupArray];
        }
    }
    else if (!isDone && section == 3)
    {
        faultPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        faultPickView.showsSelectionIndicator = YES;
        faultPickView.backgroundColor = colorWithHexString(@"cdced1");
        faultPickView.dataSource = self;
        faultPickView.delegate = self;
        [self.view addSubview:faultPickView];
    }
    else if (isDone && section == 1)
    {
        faultPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        faultPickView.showsSelectionIndicator = YES;
        faultPickView.backgroundColor = colorWithHexString(@"cdced1");
        faultPickView.dataSource = self;
        faultPickView.delegate = self;
        [self.view addSubview:faultPickView];
        
        // 工具条
        toolView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-44, SCREEN_WIDTH, 44)];
        toolView.backgroundColor = colorWithHexString(@"cccdd0");
        [pickerbackView addSubview:toolView];
        
        // sure
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 2, 80, 40)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [sureBtn addTarget:self action:@selector(toolBarDoneClick) forControlEvents:UIControlEventTouchUpInside];
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

- (void)toolBarDoneClick {
    if (faultPickView) {
        [faultPickView removeFromSuperview];
        faultPickView = nil;
        [pickerbackView removeFromSuperview];
        [currentTableView reloadData];
    }
}

#pragma mark -
#pragma mark 代理
#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((isDone && section == 2) || (!isDone && section == 4))
    {
        return 80.f;
    }
    return 5.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((isDone && section == 2) || (!isDone && section == 4))
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, 50.f);
        [doneBtn setTitle:@"提交" forState:UIControlStateNormal];
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
        
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [cell.imgViewOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [cell.imgViewTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.checkImgView.hidden = YES;
            cell.detailLable.textAlignment = NSTextAlignmentRight;
            CGRect rect = cell.detailLable.frame;
            rect.size.width -= 12.f;
            cell.detailLable.frame = rect;
        }
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
                cell.detailLable.text = orderType.length > 0 ? orderType : @"请选择工单类型";
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
    [self createBoxView:indexPath.section];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (faultPickView)
        {
            [faultPickView removeFromSuperview];
            faultPickView = nil;
            [currentTableView reloadData];
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
        groupID = @"";
        NSDictionary *dic = obj;
        orderTypeInfo = [dic objectForKey:@"collection"];
        specialOID = [dic objectForKey:@"id"];
    }
    else if (type == GroupingView)
    {
        specialOID = @"";
        BXTGroupingInfo *groupInfo = obj;
        orderTypeInfo = groupInfo.subgroup;
        groupID = groupInfo.group_id;
    }
    else if (type == Other)
    {
        if ([obj isEqualToString:@"未修好"])
        {
            maintenanceState = obj;
            state = @"1";
            isDone = NO;
        }
        else if ([obj isEqualToString:@"已修好"])
        {
            maintenanceState = obj;
            isDone = YES;
            state = @"2";
        }
        else
        {
            orderType = obj;
        }
    }
    
    [currentTableView reloadData];
    
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
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (headImage != nil)
    {
        headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        __weak BXTMaintenanceProcessViewController *weakSelf = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [selectPhotos addObject:headImage];
            [weakSelf selectImages];
        }];
    }
    else
    {
        NSURL *path = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        [self loadImageFromAssertByUrl:path completion:^(UIImage * img)
         {
             __weak BXTMaintenanceProcessViewController *weakSelf = self;
             [picker dismissViewControllerAnimated:YES completion:^{
                 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                 [selectPhotos addObject:img];
                 [weakSelf selectImages];
             }];
         }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        picker.delegate = nil;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

//有的图片在Ipad的情况下
- (void)loadImageFromAssertByUrl:(NSURL *)url completion:(void (^)(UIImage *))completion{
    
    __block UIImage* img;
    
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)
     {
         ALAssetRepresentation *rep = [asset defaultRepresentation];
         Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
         NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned int)rep.size error:nil];
         NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
         img = [UIImage imageWithData:data];
         completion(img);
     } failureBlock:^(NSError *err) {
         NSLog(@"Error: %@",[err localizedDescription]);
     }];
}

- (void)selectCamenaType:(NSInteger)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //设置相机支持的类型，拍照和录像
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)selectImages
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    BXTRemarksTableViewCell *cell = (BXTRemarksTableViewCell *)[currentTableView cellForRowAtIndexPath:indexPath];
    if (selectPhotos.count == 1)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            
        } completion:nil];
    }
    else if (selectPhotos.count == 2)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        [self resetDatasource:cell arrayWithIndex:1];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:cell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            
        } completion:nil];
    }
    else if (selectPhotos.count == 3)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        [self resetDatasource:cell arrayWithIndex:1];
        [self resetDatasource:cell arrayWithIndex:2];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:cell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            [self resetFrame:cell arrayWithIndex:2 withValue:(IMAGEWIDTH + 10.f) * 3];
            
        } completion:nil];
    }
}

#pragma mark -
#pragma mark SelectPhotoDelegate
- (void)getSelectedPhoto:(NSMutableArray *)photos
{
    selectPhotos = photos;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    BXTRemarksTableViewCell *cell = (BXTRemarksTableViewCell *)[currentTableView cellForRowAtIndexPath:indexPath];
    if (photos.count == 1)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            
        } completion:nil];
    }
    else if (photos.count == 2)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        [self resetDatasource:cell arrayWithIndex:1];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:cell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            
        } completion:nil];
    }
    else if (photos.count == 3)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        [self resetDatasource:cell arrayWithIndex:1];
        [self resetDatasource:cell arrayWithIndex:2];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:cell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            [self resetFrame:cell arrayWithIndex:2 withValue:(IMAGEWIDTH + 10.f) * 3];
            
        } completion:nil];
    }
}

- (void)resetCell:(BXTRemarksTableViewCell *)cell
{
    [cell.imgViewOne setFrame:cell.addBtn.frame];
    [cell.imgViewTwo setFrame:cell.addBtn.frame];
    [cell.imgViewThree setFrame:cell.addBtn.frame];
    
    cell.imgViewOne.image = nil;
    cell.imgViewTwo.image = nil;
    cell.imgViewThree.image = nil;
}

- (void)resetDatasource:(BXTRemarksTableViewCell *)cell arrayWithIndex:(NSInteger)index
{
    id obj = [selectPhotos objectAtIndex:index];
    UIImage *newImage = nil;
    if ([obj isKindOfClass:[UIImage class]])
    {
        UIImage *tempImg = (UIImage *)obj;
        newImage = tempImg;
    }
    else
    {
        ALAsset *asset = (ALAsset *)obj;
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef posterImageRef = [representation fullScreenImage];
        UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef scale:[representation scale] orientation:UIImageOrientationUp];
        newImage = posterImage;
    }
    [cell.photosArray addObject:newImage];
    [photosArray addObject:newImage];
    
    if (index == 0)
    {
        cell.imgViewOne.image = newImage;
    }
    else if (index == 1)
    {
        cell.imgViewTwo.image = newImage;
    }
    else if (index == 2)
    {
        cell.imgViewThree.image = newImage;
    }
}

- (void)resetFrame:(BXTRemarksTableViewCell *)cell arrayWithIndex:(NSInteger)index withValue:(CGFloat)space
{
    CGRect rect = cell.imgViewOne.frame;
    rect.origin.x = CGRectGetMinX(cell.addBtn.frame) + space;
    
    if (index == 0)
    {
        cell.imgViewOne.frame = rect;
    }
    else if (index == 1)
    {
        cell.imgViewTwo.frame = rect;
    }
    else if (index == 2)
    {
        cell.imgViewThree.frame = rect;
    }
}

- (void)loadMWPhotoBrowser:(NSInteger)index
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (UIImage *image in photosArray)
    {
        MWPhoto *photo = [MWPhoto photoWithImage:image];
        [photos addObject:photo];
    }
    self.mwPhotosArray = photos;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    
    [self.navigationController pushViewController:browser animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -
#pragma mark MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.mwPhotosArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = self.mwPhotosArray[index];
    return photo;
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag == kNOTE)
    {
        if ([textView.text isEqualToString:@"请输入报修内容"])
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
        notes = textView.text;
        if (textView.text.length < 1)
        {
            textView.text = @"请输入报修内容";
        }
    }
    else
    {
        mmLog = textView.text;
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
        selectFaultTypeInfo = faultTypesArray[0];
        [pickerView reloadComponent:1];
    }
    else
    {
        NSArray *faultTypesArray = selectFaultInfo.sub_data;
        selectFaultTypeInfo = faultTypesArray[row];
        _currentFaultID = selectFaultTypeInfo.fau_id;
    }
    _cause = [NSString stringWithFormat:@"%@-%@",selectFaultInfo.faulttype_type,selectFaultTypeInfo.faulttype];
    [currentTableView reloadData];
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
            LogBlue(@"dic......%@",dic);
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
