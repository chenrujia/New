//
//  BXTChooseListViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTStoresListsInfo.h"
#import "BXTPlaceListInfo.h"

typedef NS_ENUM(NSInteger, PushType) {
    PushType_Department = 1,    // 所属 - 默认
    PushType_Location,               // 常用位置
};

@interface BXTChooseListViewController : BXTBaseViewController

/** ---- 跳转类型 ---- */
@property (nonatomic, assign) PushType typeOfPush;

@property (nonatomic, strong) RACSubject *delegateSignal;

/** ---- 传递ID ---- */
@property (nonatomic, copy) NSString *transID;

@end
