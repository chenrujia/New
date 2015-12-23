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

@interface BXTPhotoBaseViewController ()<BXTDataResponseDelegate>

@end

@implementation BXTPhotoBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark 选择相册图片
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
                    [_selectPhotos removeAllObjects];
                    if (_isSettingVC)
                    {
                        //取原图
                        [_selectPhotos addObjectsFromArray:GetImages];
                        UIImage *image = [self handleImage];
                        [self showMLImageCropView:image];
                    }
                    else
                    {
                        [_photosArray removeAllObjects];
                        //取原图
                        [_selectPhotos addObjectsFromArray:GetImages];
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
                            @weakify(self);
                            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                            @strongify(self);
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
                pick.selectPhotos = _selectPhotos;
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
    id obj = [_selectPhotos objectAtIndex:0];
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
    BXTRemarksTableViewCell *cell;
    if (_remarkCell)
    {
        cell = _remarkCell;
    }
    else
    {
        cell = (BXTRemarksTableViewCell *)[_currentTableView cellForRowAtIndexPath:_indexPath];
    }
    if (_selectPhotos.count == 1)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            
        } completion:nil];
    }
    else if (_selectPhotos.count == 2)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        [self resetDatasource:cell arrayWithIndex:1];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:cell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            
        } completion:nil];
    }
    else if (_selectPhotos.count == 3)
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
    
    browser.titlePreNumStr = [NSString stringWithFormat:@"%ld%ld%ld", (long)faultPicCount, (long)fixedPicCount, (long)evaluationPicCount];
    
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
    }
    [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark SelectPhotoDelegate
- (void)getSelectedPhoto:(NSMutableArray *)photos
{
    if (_isSettingVC)
    {
        _selectPhotos = photos;
        UIImage *image = [self handleImage];
        [self showMLImageCropView:image];
        return;
    }
    _selectPhotos = photos;
    BXTRemarksTableViewCell *cell;
    if (_remarkCell)
    {
        cell = _remarkCell;
    }
    else
    {
        cell = (BXTRemarksTableViewCell *)[_currentTableView cellForRowAtIndexPath:_indexPath];
    }
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
    [cell.photosArray addObject:newImage];
    [_photosArray addObject:newImage];
    
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
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (headImage != nil)
    {
        headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        @weakify(self);
        [picker dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [self.selectPhotos addObject:headImage];
            [self selectImages];
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
                 [self.selectPhotos addObject:img];
                 [self selectImages];
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
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request uploadHeaderImage:cropImage];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    
}

- (void)requestError:(NSError *)error
{
    
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
