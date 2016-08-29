//
//  BXTDetailBaseViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"
#import "BXTDeviceMaintenceInfo.h"
#import <RongIMKit/RongIMKit.h>
#import "BXTRepairDetailInfo.h"

#define ImageWidth      73.3f
#define ImageHeight     73.3f
#define StateViewHeight 60.f
#define RepairHeight    95.f

@interface BXTDetailBaseViewController : BXTPhotoBaseViewController
{
    CGFloat log_height;
}
@property (nonatomic ,strong) BXTRepairDetailInfo *repairDetail;

- (void)handleUserInfoWithUser:(BXTControlUserInfo *)user;
- (void)handleUserInfo:(NSDictionary *)dic;
- (NSMutableArray *)containAllPhotos:(NSArray *)picArray;
- (NSMutableArray *)containAllPhotosForMWPhotoBrowser;
- (NSMutableArray *)containAllArray;
- (UIImageView *)imageViewWith:(NSInteger)i andDictionary:(BXTFaultPicInfo *)dictionary;
- (UIView *)viewForUser:(NSInteger)i andMaintenance:(BXTMaintenanceManInfo *)userInfo;
- (UIView *)deviceLists:(NSInteger)i comingFromDeviceInfo:(BOOL)isComing isLast:(BOOL)last;

@end
