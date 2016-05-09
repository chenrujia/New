//
//  BXTPhotoBaseViewController.m
//  YouFeel
//
//  Created by Jason on 15/12/22.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"
#import "HySideScrollingImagePicker.h"
#import "BXTPublicSetting.h"
#import "BXTDataRequest.h"
#import "BXTGlobal.h"

@interface BXTPhotoBaseViewController () <BXTDataResponseDelegate>

@end

@implementation BXTPhotoBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectPhotos = [NSMutableArray arrayWithCapacity:0];
    self.resultPhotos = [NSMutableArray arrayWithCapacity:0];
}

- (void)handleData:(NSInteger)number
{
    [self removeImage:number];
}

- (void)removeImage:(NSInteger)index
{
    if (index == 0)
    {
        [self.selectPhotos removeObjectAtIndex:index];
        [self.resultPhotos removeObjectAtIndex:index];
    }
    else if (index == 1)
    {
        if (self.photosView.imgViewOne.isGetBack)
        {
            [self.selectPhotos removeObjectAtIndex:0];
            [self.resultPhotos removeObjectAtIndex:0];
        }
        else
        {
            [self.selectPhotos removeObjectAtIndex:index];
            [self.resultPhotos removeObjectAtIndex:index];
        }
    }
    else if (index == 2)
    {
        if (self.photosView.imgViewOne.isGetBack && self.photosView.imgViewTwo.isGetBack)
        {
            [self.selectPhotos removeObjectAtIndex:0];
            [self.resultPhotos removeObjectAtIndex:0];
        }
        else if ((self.photosView.imgViewOne.isGetBack && !self.photosView.imgViewTwo.isGetBack) ||
                 (!self.photosView.imgViewOne.isGetBack && self.photosView.imgViewTwo.isGetBack))
        {
            [self.selectPhotos removeObjectAtIndex:1];
            [self.resultPhotos removeObjectAtIndex:1];
        }
        else
        {
            [self.selectPhotos removeObjectAtIndex:index];
            [self.resultPhotos removeObjectAtIndex:index];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -
#pragma mark 选择相册图片
- (void)addImages
{
    HySideScrollingImagePicker *hy = [[HySideScrollingImagePicker alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"拍照上传",@"本地上传"]];
    hy.isMultipleSelection = NO;
    [BXTGlobal shareGlobal].maxPics = 3 - [self.selectPhotos count];
    @weakify(self);
    hy.SeletedImages = ^(NSArray *GetImages, NSInteger Buttonindex){
        @strongify(self);
        switch (Buttonindex) {
            case 1:
            {
                if (GetImages.count != 0)
                {
                    if (self.isSettingVC)
                    {
                        //取原图
                        [self.selectPhotos removeAllObjects];
                        [self.selectPhotos addObjectsFromArray:GetImages];
                        UIImage *image = [self handleImage];
                        [self showMLImageCropView:image];
                    }
                    else
                    {
                        [self.resultPhotos removeAllObjects];
                        //取原图
                        [self.selectPhotos addObjectsFromArray:GetImages];
                        [self selectImages];
                    }
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
                pick.selectPhotos = self.selectPhotos;
                [self.navigationController pushViewController:pick animated:YES];
                self.navigationController.navigationBar.hidden = NO;
            }
                break;
            default:
                break;
        }
    };
    
    [self.view addSubview:hy];
}

- (void)showMLImageCropView:(UIImage *)image
{
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.delegate = self;
    imageCrop.ratioOfWidthAndHeight = 1.f;
    imageCrop.image = image;
    [imageCrop showWithAnimation:YES];
}

- (UIImage *)handleImage
{
    id obj = [self.selectPhotos objectAtIndex:0];
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
    return newImage;
}

- (void)selectImages
{
    if (self.selectPhotos.count == 1)
    {
        [self refreshPhotosView];
        [self refreshDatasourceWithIndex:0];
        
        @weakify(self);
        [UIView animateWithDuration:1.f animations:^{
            @strongify(self);
            [self refreshFrameWithIndex:0 withValue:GImageHeight + 10.f];
            
        } completion:nil];
    }
    else if (self.selectPhotos.count == 2)
    {
        [self refreshPhotosView];
        [self refreshDatasourceWithIndex:0];
        [self refreshDatasourceWithIndex:1];
        
        @weakify(self);
        [UIView animateWithDuration:1.f animations:^{
            @strongify(self);
            [self refreshFrameWithIndex:0 withValue:GImageHeight + 10.f];
            [self refreshFrameWithIndex:1 withValue:(GImageHeight + 10.f) * 2];
            
        } completion:nil];
    }
    else if (self.selectPhotos.count == 3)
    {
        [self refreshPhotosView];
        [self refreshDatasourceWithIndex:0];
        [self refreshDatasourceWithIndex:1];
        [self refreshDatasourceWithIndex:2];
        
        @weakify(self);
        [UIView animateWithDuration:1.f animations:^{
            @strongify(self);
            [self refreshFrameWithIndex:0 withValue:GImageHeight + 10.f];
            [self refreshFrameWithIndex:1 withValue:(GImageHeight + 10.f) * 2];
            [self refreshFrameWithIndex:2 withValue:(GImageHeight + 10.f) * 3];
            
        } completion:nil];
    }
}

- (void)loadMWPhotoBrowser:(NSInteger)index
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (UIImage *image in self.resultPhotos)
    {
        MWPhoto *photo = [MWPhoto photoWithImage:image];
        [photos addObject:photo];
    }
    if (photos.count)
    {
        self.mwPhotosArray = photos;
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
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

- (void)loadMWPhotoBrowserForDetail:(NSInteger)index withFaultPicCount:(NSInteger)faultPicCount withFixedPicCount:(NSInteger)fixedPicCount withEvaluationPicCount:(NSInteger)evaluationPicCount
{
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
//    browser.titlePreNumStr = [NSString stringWithFormat:@"%ld%ld%ld", (long)faultPicCount, (long)fixedPicCount, (long)evaluationPicCount];
    [self.navigationController pushViewController:browser animated:YES];
    self.navigationController.navigationBar.hidden = NO;
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
        if (self.isSettingVC)
        {
            imagePickerController.allowsEditing = YES;
        }
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark SelectPhotoDelegate
- (void)getSelectedPhoto:(NSMutableArray *)photos
{
    [self.resultPhotos removeAllObjects];
    if (_isSettingVC)
    {
        self.selectPhotos = photos;
        UIImage *image = [self handleImage];
        [self showMLImageCropView:image];
        return;
    }
    self.selectPhotos = photos;
    if (photos.count == 1)
    {
        [self refreshPhotosView];
        [self refreshDatasourceWithIndex:0];
        
        @weakify(self);
        [UIView animateWithDuration:1.f animations:^{
            @strongify(self);
            [self refreshFrameWithIndex:0 withValue:GImageHeight + 10.f];
            
        } completion:nil];
    }
    else if (photos.count == 2)
    {
        [self refreshPhotosView];
        [self refreshDatasourceWithIndex:0];
        [self refreshDatasourceWithIndex:1];
        @weakify(self);
        [UIView animateWithDuration:1.f animations:^{
            @strongify(self);
            [self refreshFrameWithIndex:0 withValue:GImageHeight + 10.f];
            [self refreshFrameWithIndex:1 withValue:(GImageHeight + 10.f) * 2];
            
        } completion:nil];
    }
    else if (photos.count == 3)
    {
        [self refreshPhotosView];
        [self refreshDatasourceWithIndex:0];
        [self refreshDatasourceWithIndex:1];
        [self refreshDatasourceWithIndex:2];
        @weakify(self);
        [UIView animateWithDuration:1.f animations:^{
            @strongify(self);
            [self refreshFrameWithIndex:0 withValue:GImageHeight + 10.f];
            [self refreshFrameWithIndex:1 withValue:(GImageHeight + 10.f) * 2];
            [self refreshFrameWithIndex:2 withValue:(GImageHeight + 10.f) * 3];
            
        } completion:nil];
    }
}

- (void)refreshPhotosView
{
    [self.photosView.imgViewOne setFrame:self.photosView.addBtn.frame];
    [self.photosView.imgViewTwo setFrame:self.photosView.addBtn.frame];
    [self.photosView.imgViewThree setFrame:self.photosView.addBtn.frame];
    
    self.photosView.imgViewOne.image = nil;
    self.photosView.imgViewTwo.image = nil;
    self.photosView.imgViewThree.image = nil;
}

- (void)refreshDatasourceWithIndex:(NSInteger)index
{
    id obj = [_selectPhotos objectAtIndex:index];
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
    [_resultPhotos addObject:newImage];
    
    if (index == 0)
    {
        self.photosView.imgViewOne.image = newImage;
    }
    else if (index == 1)
    {
        self.photosView.imgViewTwo.image = newImage;
    }
    else if (index == 2)
    {
        self.photosView.imgViewThree.image = newImage;
    }
}

- (void)refreshFrameWithIndex:(NSInteger)index withValue:(CGFloat)space
{
    CGRect rect = self.photosView.imgViewOne.frame;
    rect.origin.x = CGRectGetMinX(self.photosView.addBtn.frame) + space;
    
    if (index == 0)
    {
        self.photosView.imgViewOne.isGetBack = NO;
        self.photosView.imgViewOne.frame = rect;
    }
    else if (index == 1)
    {
        self.photosView.imgViewTwo.isGetBack = NO;
        self.photosView.imgViewTwo.frame = rect;
    }
    else if (index == 2)
    {
        self.photosView.imgViewThree.isGetBack = NO;
        self.photosView.imgViewThree.frame = rect;
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (headImage != nil)
    {
        headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation = headImage.imageOrientation;
        if(imageOrientation != UIImageOrientationUp)
        {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(headImage.size);
            [headImage drawInRect:CGRectMake(0, 0, headImage.size.width, headImage.size.height)];
            headImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        
        @weakify(self);
        [picker dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            if (self.isSettingVC)
            {
                [self showLoadingMBP:@"正在上传..."];
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request uploadHeaderImage:headImage];
            }
            else
            {
                [self.resultPhotos removeAllObjects];
                [self.selectPhotos addObject:headImage];
                [self selectImages];
            }
        }];
    }
    else
    {
        NSURL *path = [info objectForKey:UIImagePickerControllerReferenceURL];
        [self loadImageFromAssertByUrl:path completion:^(UIImage * img)
         {
             @weakify(self);
             [picker dismissViewControllerAnimated:YES completion:^{
                 @strongify(self);
                 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                 if (self.isSettingVC)
                 {
                     [self showLoadingMBP:@"正在上传..."];
                     BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                     [request uploadHeaderImage:img];
                 }
                 else
                 {
                     [self.selectPhotos addObject:img];
                     [self selectImages];
                 }
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
- (void)loadImageFromAssertByUrl:(NSURL *)url completion:(void (^)(UIImage *))completion
{
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
#pragma mark MLImageCropDelegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    [self showLoadingMBP:@"正在上传..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request uploadHeaderImage:cropImage];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
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
