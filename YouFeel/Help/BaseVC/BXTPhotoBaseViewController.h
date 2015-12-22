//
//  BXTPhotoBaseViewController.h
//  YouFeel
//
//  Created by Jason on 15/12/22.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "BXTBaseViewController.h"
#import "BXTRemarksTableViewCell.h"
#import "LocalPhotoViewController.h"
@import AssetsLibrary;
@import AVFoundation;
@import MobileCoreServices;

@interface BXTPhotoBaseViewController : BXTBaseViewController<SelectPhotoDelegate,MWPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic ,strong) NSMutableArray *mwPhotosArray;
@property (nonatomic, strong) NSMutableArray *selectPhotos;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic ,strong) UITableView    *currentTableView;

- (void)addImages;
- (void)loadMWPhotoBrowser:(NSInteger)index;

@end
