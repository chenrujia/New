//
//  BXTHomeViewController.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface BXTHomeViewController : BXTBaseViewController <UICollectionViewDataSource,UICollectionViewDelegate,RCIMUserInfoDataSource>
{
    UICollectionView *itemsCollectionView;
    NSMutableArray   *imgNameArray;
    NSMutableArray   *titleNameArray;
    UILabel          *shop_label;
    UIButton         *logo_Btn;
    UILabel          *title_label;
    NSMutableArray   *datasource;
    UIImageView      *logoImgView;
}

- (void)createLogoView;
- (void)repairClick;
/**
 *  是否已验证
 */
- (BOOL)is_verify;

@end
