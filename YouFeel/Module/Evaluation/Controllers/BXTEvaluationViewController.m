//
//  BXTEvaluationViewController.m
//  BXT
//
//  Created by Jason on 15/9/11.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTEvaluationViewController.h"
#import "BXTHeaderFile.h"
#import "AMRatingControl.h"
#import "BXTRemarksTableViewCell.h"
#import "HySideScrollingImagePicker.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "LocalPhotoViewController.h"
#import "BXTDataRequest.h"

@interface BXTEvaluationViewController ()<AMRateDelegate,MWPhotoBrowserDelegate,SelectPhotoDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,BXTDataResponseDelegate>

@property (nonatomic ,strong) NSString                *notes;
@property (nonatomic ,strong) NSMutableArray          *rateArray;
@property (nonatomic ,strong) NSMutableArray          *photosArray;
@property (nonatomic ,strong) NSMutableArray          *selectPhotos;
@property (nonatomic ,strong) NSMutableArray          *mwPhotosArray;
@property (nonatomic ,strong) BXTRemarksTableViewCell *remarkCell;

@end

@implementation BXTEvaluationViewController

- (void)dealloc
{
    LogBlue(@"评价界面释放了！！！！！！");
}

- (instancetype)initWithRepairID:(NSString *)reID
{
    self = [super init];
    if (self)
    {
        [BXTGlobal shareGlobal].maxPics = 3;
        self.repairID = reID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.notes = @"";
    self.rateArray = [NSMutableArray arrayWithObjects:@"5",@"5",@"5", nil];
    self.photosArray = [[NSMutableArray alloc] init];
    self.selectPhotos = [[NSMutableArray alloc] init];
    
    [self createSubviews];
    [self navigationSetting:@"评价" andRightTitle:nil andRightImage:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -
#pragma mark 初始化视图
- (void)createSubviews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.backgroundColor = colorWithHexString(@"ffffff");
    [self.view addSubview:scrollView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    backView.backgroundColor = colorWithHexString(@"ffffff");
    [scrollView addSubview:backView];
    
    NSArray *titleArray = @[@"反应速度",@"专业水平",@"服务态度"];
    for (NSInteger i = 0; i < 3; i++)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 30 + 60 * i, 80.f, 20.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = titleArray[i];
        [backView addSubview:titleLabel];
        
        UIImage *dot = [UIImage imageNamed:@"star_selected"];
        UIImage *star = [UIImage imageNamed:@"star"];
        AMRatingControl *imagesRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(120, 24 + 60 * i)
                                                                              emptyImage:dot
                                                                              solidImage:star
                                                                            andMaxRating:5];
        imagesRatingControl.tag = i;
        imagesRatingControl.rating = 5;
        imagesRatingControl.delegate = self;
        [backView addSubview:imagesRatingControl];
    }
    
    UIView *lineViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 209.5f, SCREEN_WIDTH, 0.5f)];
    lineViewOne.backgroundColor = colorWithHexString(@"909497");
    [backView addSubview:lineViewOne];
    
    self.remarkCell = [[BXTRemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReCell"];
    self.remarkCell.frame = CGRectMake(0, CGRectGetMaxY(lineViewOne.frame), SCREEN_WIDTH, 170);
    self.remarkCell.remarkTV.delegate = self;
    self.remarkCell.titleLabel.text = @"备   注";
    
    @weakify(self);
    UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
    [self.remarkCell.imgViewOne addGestureRecognizer:tapGROne];
    [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self loadMWPhotoBrowser:self.remarkCell.imgViewOne.tag];
    }];
    
    UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
    [self.remarkCell.imgViewTwo addGestureRecognizer:tapGRTwo];
    [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self loadMWPhotoBrowser:self.remarkCell.imgViewTwo.tag];
    }];
    
    UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
    [self.remarkCell.imgViewThree addGestureRecognizer:tapGRThree];
    [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self loadMWPhotoBrowser:self.remarkCell.imgViewThree.tag];
    }];
    
    [self.remarkCell.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.remarkCell];
    
    UIView *lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.remarkCell.frame), SCREEN_WIDTH, 0.5f)];
    lineViewTwo.backgroundColor = colorWithHexString(@"909497");
    [backView addSubview:lineViewTwo];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, CGRectGetMaxY(lineViewTwo.frame) + 40.f, SCREEN_WIDTH - 40, 50.f);
    if (IS_IPHONE4)
    {
        commitBtn.frame = CGRectMake(20, CGRectGetMaxY(lineViewTwo.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
    }
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 6.f;
    [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showLoadingMBP:@"正在提交..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request evaluateRepair:self.rateArray
                evaluationNotes:self.notes
                       repairID:self.repairID
                     imageArray:self.photosArray];
    }];
    [backView addSubview:commitBtn];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(commitBtn.frame)+70);
}

#pragma mark -
#pragma mark 事件处理
- (void)loadMWPhotoBrowser:(NSInteger)index
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (UIImage *image in self.photosArray)
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
#pragma mark 图片相关
- (void)addImages
{
    @weakify(self);
    HySideScrollingImagePicker *hy = [[HySideScrollingImagePicker alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"拍摄",@"从相册选择"]];
    hy.isMultipleSelection = NO;
    
    hy.SeletedImages = ^(NSArray *GetImages, NSInteger Buttonindex){
        @strongify(self);
        switch (Buttonindex) {
            case 1:
            {
                if (GetImages.count != 0)
                {
                    [self.selectPhotos removeAllObjects];
                    [self.photosArray removeAllObjects];
                    //取原图
                    [self.selectPhotos addObjectsFromArray:GetImages];
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
                LocalPhotoViewController *pick = [[LocalPhotoViewController alloc] init];
                pick.selectPhotoDelegate = self;
                pick.selectPhotos = self.selectPhotos;
                [self.navigationController pushViewController:pick animated:YES];
            }
                break;
            default:
                break;
        }
    };
    
    [self.view addSubview:hy];
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
    if (self.selectPhotos.count == 1)
    {
        [self resetCell:self.remarkCell];
        [self resetDatasource:self.remarkCell arrayWithIndex:0];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:self.remarkCell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            
        } completion:nil];
    }
    else if (self.selectPhotos.count == 2)
    {
        [self resetCell:self.remarkCell];
        [self resetDatasource:self.remarkCell arrayWithIndex:0];
        [self resetDatasource:self.remarkCell arrayWithIndex:1];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:self.remarkCell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:self.remarkCell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            
        } completion:nil];
    }
    else if (self.selectPhotos.count == 3)
    {
        [self resetCell:self.remarkCell];
        [self resetDatasource:self.remarkCell arrayWithIndex:0];
        [self resetDatasource:self.remarkCell arrayWithIndex:1];
        [self resetDatasource:self.remarkCell arrayWithIndex:2];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:self.remarkCell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:self.remarkCell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            [self resetFrame:self.remarkCell arrayWithIndex:2 withValue:(IMAGEWIDTH + 10.f) * 3];
            
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
    id obj = [self.selectPhotos objectAtIndex:index];
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
    [self.photosArray addObject:newImage];
    
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

#pragma mark -
#pragma mark AMRateDeletage
- (void)rateNumber:(NSInteger)rate withRateControl:(AMRatingControl *)ctr
{
    [self.rateArray replaceObjectAtIndex:ctr.tag withObject:[NSString stringWithFormat:@"%ld",(long)rate]];
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
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (headImage != nil)
    {
        headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        __weak BXTEvaluationViewController *weakSelf = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [weakSelf.selectPhotos addObject:headImage];
            [weakSelf selectImages];
        }];
    }
    else
    {
        NSURL *path = [info objectForKey:UIImagePickerControllerReferenceURL];
        __weak BXTEvaluationViewController *weakSelf = self;
        [self loadImageFromAssertByUrl:path completion:^(UIImage * img)
         {
             [picker dismissViewControllerAnimated:YES completion:^{
                 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                 [weakSelf.selectPhotos addObject:img];
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

#pragma mark -
#pragma mark SelectPhotoDelegate
- (void)getSelectedPhoto:(NSMutableArray *)photos
{
    self.selectPhotos = photos;
    if (photos.count == 1)
    {
        [self resetCell:self.remarkCell];
        [self resetDatasource:self.remarkCell arrayWithIndex:0];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:self.remarkCell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            
        } completion:nil];
    }
    else if (photos.count == 2)
    {
        [self resetCell:self.remarkCell];
        [self resetDatasource:self.remarkCell arrayWithIndex:0];
        [self resetDatasource:self.remarkCell arrayWithIndex:1];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:self.remarkCell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:self.remarkCell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            
        } completion:nil];
    }
    else if (photos.count == 3)
    {
        [self resetCell:self.remarkCell];
        [self resetDatasource:self.remarkCell arrayWithIndex:0];
        [self resetDatasource:self.remarkCell arrayWithIndex:1];
        [self resetDatasource:self.remarkCell arrayWithIndex:2];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:self.remarkCell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:self.remarkCell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            [self resetFrame:self.remarkCell arrayWithIndex:2 withValue:(IMAGEWIDTH + 10.f) * 3];
            
        } completion:nil];
    }
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
    self.notes = textView.text;
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
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [self hideMBP];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EvaluateSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenEvaluationBtn" object:nil];
        @weakify(self);
        [self showMBP:@"评价成功！" withBlock:^(BOOL hidden) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        [self hideMBP];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
