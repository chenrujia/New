//
//  QRCodeViewController.h
//  MyFramework
//
//  Created by 满孝意 on 15/12/22.
//  Copyright © 2015年 满孝意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTQRBaseViewController.h"

@interface BXTQRCodeViewController : BXTQRBaseViewController

/** ---- 模仿qq界面 ---- */
@property (nonatomic, assign) BOOL isQQSimulator;

/** ---- 扫码区域上方提示文字 ---- */
@property (nonatomic, strong) UILabel *topTitle;


/** ---- 底部显示的功能项 ---- */
@property (nonatomic, strong) UIView *bottomItemsView;
/** ---- 相册 ---- */
@property (nonatomic, strong) UIButton *btnPhoto;
/** ---- 闪光灯 ---- */
@property (nonatomic, strong) UIButton *btnFlash;
/** ---- 我的二维码 ---- */
@property (nonatomic, strong) UIButton *btnMyQR;

@end
