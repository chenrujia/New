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

@interface BXTMaintenanceProcessViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MWPhotoBrowserDelegate,SelectPhotoDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,BXTBoxSelectedTitleDelegate,UIPickerViewDataSource,UIPickerViewDelegate,BXTDataResponseDelegate>
{
    UITableView *currentTableView;
    NSMutableArray *photosArray;
    NSMutableArray *selectPhotos;
    NSString *notes;
    NSString *maintenanceState;
    NSString *finishTime;
    NSString *maintenanceTime;
    BXTSelectBoxView *boxView;
    NSArray *stateArray;
    NSDateFormatter *dateFormatter;
    UIDatePicker *datePicker;
    UIPickerView *timePickView;
    UIPickerView *faultPickView;
    NSArray *timesArray;
    NSDate *selectDate;
    NSMutableArray *fau_dataSource;
    BXTFaultInfo *selectFaultInfo;
    BXTFaultTypeInfo *selectFaultTypeInfo;
}

@property (nonatomic ,strong) NSMutableArray *mwPhotosArray;
@property (nonatomic ,strong) NSString *cause;
@property (nonatomic ,assign) NSInteger currentFaultID;
@property (nonatomic ,assign) NSInteger repairID;
@property (nonatomic ,strong) NSString  *reaciveTime;


@end

@implementation BXTMaintenanceProcessViewController

- (instancetype)initWithCause:(NSString *)cause andCurrentFaultID:(NSInteger)faultID andRepairID:(NSInteger)repairID andReaciveTime:(NSString *)time
{
    self = [super init];
    if (self)
    {
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
    timesArray = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    selectDate = [NSDate date];
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    finishTime = [NSString stringWithFormat:@"%.0f",currentTime];
    maintenanceTime = @"1";
    
    [self navigationSetting:@"维修过程" andRightTitle:nil andRightImage:nil];
    [self createTableView];
    
    photosArray = [[NSMutableArray alloc] init];
    selectPhotos = [[NSMutableArray alloc] init];
    
    /**请求故障类型列表**/
    BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [fau_request faultTypeList];
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
- (void)dateChange:(UIDatePicker *)picker
{
    selectDate = picker.date;
    NSTimeInterval currentTime = selectDate.timeIntervalSince1970;
    finishTime = [NSString stringWithFormat:@"%.0f",currentTime];
    [currentTableView reloadData];
}

- (void)doneClick
{
    /**提交维修中状态**/
    BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
    NSString *state = @"2";
    if ([maintenanceState isEqualToString:@"未修好"])
    {
        state = @"1";
    }
    [fau_request maintenanceState:[NSString stringWithFormat:@"%ld",(long)_repairID] andReaciveTime:_reaciveTime andFinishTime:finishTime andMaintenanceState:state andFaultType:[NSString stringWithFormat:@"%ld",(long)_currentFaultID] andManHours:maintenanceTime];
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
#pragma mark 代理
/**
 *  UITableViewDelegate & UITableViewDatasource
 */
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
    if (section == 4)
    {
        return 80.f;
    }
    return 5.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, 50.f);
        [doneBtn setTitle:@"提交" forState:UIControlStateNormal];
        [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [doneBtn setBackgroundColor:colorWithHexString(@"aac3e1")];
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
    if (indexPath.section == 4)
    {
        return 170;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
        
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [cell.imgViewOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [cell.imgViewTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.checkImgView.hidden = YES;
            cell.detailLable.textAlignment = NSTextAlignmentRight;
            CGRect rect = cell.detailLable.frame;
            rect.size.width -= 12.f;
            cell.detailLable.frame = rect;
        }
        if (indexPath.section == 0)
        {
            cell.titleLabel.text = @"维修状态";
            cell.detailLable.text = maintenanceState;
        }
        else if (indexPath.section == 1)
        {
            cell.titleLabel.text = @"故障类型";
            cell.detailLable.text = _cause;
        }
        else if (indexPath.section == 2)
        {
            cell.titleLabel.text = @"完成时间";
            NSString *currentDateStr = [dateFormatter stringFromDate:selectDate];
            cell.detailLable.text = currentDateStr;
        }
        else
        {
            cell.titleLabel.text = @"维修耗时";
            cell.detailLable.text = [NSString stringWithFormat:@"%@小时",maintenanceTime];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self createBoxView:indexPath.section];
}

- (void)createBoxView:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    if (section == 0)
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"维修状态" boxSelectedViewType:Other listDataSource:stateArray markID:nil actionDelegate:self];
        
        [self.view addSubview:boxView];
        [UIView animateWithDuration:0.3f animations:^{
            [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
        }];
    }
    else if (section == 1)
    {
        faultPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        faultPickView.tag = 1000;
        faultPickView.showsSelectionIndicator = YES;
        faultPickView.backgroundColor = colorWithHexString(@"cdced1");
        faultPickView.dataSource = self;
        faultPickView.delegate = self;
        [self.view addSubview:faultPickView];
    }
    else if (section == 2)
    {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
        datePicker.backgroundColor = colorWithHexString(@"cdced1");
        datePicker.maximumDate = [NSDate date];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
    }
    else if (section == 3)
    {
        timePickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        timePickView.tag = 1001;
        timePickView.showsSelectionIndicator = YES;
        timePickView.backgroundColor = colorWithHexString(@"cdced1");
        timePickView.dataSource = self;
        timePickView.delegate = self;
        [self.view addSubview:timePickView];
    }
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
        else if (timePickView)
        {
            [timePickView removeFromSuperview];
            timePickView = nil;
            [currentTableView reloadData];
        }
        else if (datePicker)
        {
            [datePicker removeFromSuperview];
            datePicker = nil;
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

- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    maintenanceState = obj;
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

/**
 *  UIImagePickerControllerDelegate
 */
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
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

/**
 *  SelectPhotoDelegate
 */
- (void)getSelectedPhoto:(NSMutableArray *)photos
{
    selectPhotos = photos;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
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
}

/**
 *  MWPhotoBrowserDelegate
 */
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.mwPhotosArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = self.mwPhotosArray[index];
    return photo;
}

/**
 *  UITextViewDelegate
 */
- (void)textViewDidEndEditing:(UITextView *)textView
{
    notes = textView.text;
}

/**
 *  UIPickerViewDelegate
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 1000)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1000)
    {
        if (component == 0)
        {
            return fau_dataSource.count;
        }
        return selectFaultInfo.sub_data.count;
    }
    return timesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1000)
    {
        if (component == 0)
        {
            BXTFaultInfo *faultInfo = fau_dataSource[row];
            return faultInfo.faulttype_type;
        }
        
        BXTFaultTypeInfo *faultTypeInfo = selectFaultInfo.sub_data[row];
        return faultTypeInfo.faulttype;
    }
    return timesArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1000)
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
    }
    maintenanceTime = timesArray[row];
    [currentTableView reloadData];
}

/**
 *  请求返回代理
 */
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
            [self.navigationController popViewControllerAnimated:YES];
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
