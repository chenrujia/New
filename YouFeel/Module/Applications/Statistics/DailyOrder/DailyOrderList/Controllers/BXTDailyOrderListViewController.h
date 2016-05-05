//
//  BXTDailyOrderListViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/18.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTDailyOrderListViewController : BXTBaseViewController

/** ---- 时间数组 ---- */
@property (strong, nonatomic) NSMutableArray *transTimeArray;
/** ---- 维修状态 1已修好 2 未修好 ---- */
@property (copy, nonatomic) NSString *transStateStr;
/** ---- 报修者的列表进度状态 1进行中 2 已完成 ---- */
@property (copy, nonatomic) NSString *transFaultCarriedState;

@end
