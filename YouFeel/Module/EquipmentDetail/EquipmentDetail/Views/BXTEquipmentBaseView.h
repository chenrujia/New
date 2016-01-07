//
//  BXTEquipmentBaseView.h
//  YouFeel
//
//  Created by 满孝意 on 15/12/29.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BXTHeaderFile.h"
#import "DOPDropDownMenu.h"

@interface BXTEquipmentBaseView : UIView

/** ---- 初始化 ---- */
- (void)initial;

/** ---- 显示 ---- */
- (void)showLoadingMBP:(NSString *)text;

/** ---- 隐藏 ---- */
- (void)hideMBP;

@end
