//
//  BXTDetailBaseViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"
#import "BXTRepairDetailInfo.h"
#import <RongIMKit/RongIMKit.h>

@interface BXTDetailBaseViewController : BXTPhotoBaseViewController

@property (nonatomic ,strong) BXTRepairDetailInfo *repairDetail;

- (void)contactRepairer:(UIButton *)btn;
- (NSMutableArray *)containAllPhotosForMWPhotoBrowser;
- (NSMutableArray *)containAllArray;
- (UIImageView *)imageViewWith:(NSInteger)i andDictionary:(NSDictionary *)dictionary;
- (UIView *)viewForUser:(NSInteger)i andMaintenanceMaxY:(CGFloat)mainMaxY andLevelMaxY:(CGFloat)levelWidth;

@end
