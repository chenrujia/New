//
//  BXTHomeViewController.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTHomeViewController : BXTBaseViewController <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *itemsCollectionView;
    NSMutableArray *imgNameArray;
    NSMutableArray *titleNameArray;
    UIButton *logo_btn;
    UIButton *shopBtn;
    UILabel *shop_label;
}

- (void)createLogoView;
- (void)repairClick;

@end
