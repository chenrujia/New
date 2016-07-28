//
//  BXTPhotoBaseViewController.h
//  YYouFeel GroupouFeel
//
//  Created by Jason on 15/12/22.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhoto.h"
#import "MLImageCrop.h"
#import "MWPhotoBrowser.h"
#import "BXTBaseViewController.h"
#import "LocalPhotoViewController.h"
#import "BXTPhotosView.h"
@import AssetsLibrary;
@import AVFoundation;
@import MobileCoreServices;

typedef NS_ENUM(NSInteger,PhotoVCType)
{
    DefaultVCType = 0,
    SettingVCType = 1,
    MeterRecordType = 2
};

@interface BXTPhotoBaseViewController : BXTBaseViewController<SelectPhotoDelegate,MWPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MLImageCropDelegate>

@property (nonatomic ,strong) BXTPhotosView  *photosView;
@property (nonatomic ,strong) NSMutableArray *mwPhotosArray;
@property (nonatomic ,strong) NSMutableArray *selectPhotos;
@property (nonatomic ,strong) NSMutableArray *resultPhotos;
@property (nonatomic ,strong) NSIndexPath    *indexPath;
@property (nonatomic ,strong) UITableView    *currentTableView;
@property (nonatomic ,assign) PhotoVCType    photoVCType;
//新建抄表专用
@property (nonatomic ,strong) UIImage        *meterImage;

- (void)addImages;
- (void)loadMWPhotoBrowser:(NSInteger)index;
- (void)loadMWPhotoBrowserForDetail:(NSInteger)index withFaultPicCount:(NSInteger)faultPicCount withFixedPicCount:(NSInteger)fixedPicCount withEvaluationPicCount:(NSInteger)evaluationPicCount;
- (void)handleData:(NSInteger)number;

@end
