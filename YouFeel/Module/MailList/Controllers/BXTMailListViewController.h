//
//  BXTMailListViewController.h
//  YouFeel
//
//  Created by Jason on 15/12/24.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTMailRootInfo.h"

@interface BXTMailListViewController : UIViewController

@property (strong, nonatomic) BXTMailRootInfo *transMailInfo;

/** ---- 是否为直接跳转，是返回首页 ---- */
@property (assign, nonatomic) BOOL isSinglePush;

@end
