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
    UIButton         *logo_btn;
    UIButton         *shopBtn;
    UILabel          *shop_label;
    NSMutableArray   *datasource;
    UIImageView      *logoImgView;
}

- (void)createLogoView;
- (void)repairClick;

@end
