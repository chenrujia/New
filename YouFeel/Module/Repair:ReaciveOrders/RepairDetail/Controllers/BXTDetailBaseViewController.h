//
//  BXTDetailBaseViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"
#import "BXTRepairDetailInfo.h"
#import "BXTControlUserInfo.h"
#import <RongIMKit/RongIMKit.h>

#define ImageWidth      73.3f
#define ImageHeight     73.3f
#define StateViewHeight 90.f
#define RepairHeight    95.f

@interface BXTDetailBaseViewController : BXTPhotoBaseViewController
{
    CGFloat log_height;
}
@property (nonatomic ,strong) BXTRepairDetailInfo *repairDetail;

- (void)handleUserInfoWithUser:(BXTControlUserInfo *)user;
- (void)handleUserInfo:(NSDictionary *)dictionary;
- (NSMutableArray *)containAllPhotos:(NSArray *)picArray;
- (NSMutableArray *)containAllPhotosForMWPhotoBrowser;
- (NSMutableArray *)containAllArray;
- (UIImageView *)imageViewWith:(NSInteger)i andDictionary:(NSDictionary *)dictionary;
- (UIView *)viewForUser:(NSInteger)i andMaintenanceMaxY:(CGFloat)mainMaxY andLevelWidth:(CGFloat)levelWidth;
- (UIView *)deviceLists:(NSInteger)i;

@end
