//
//  BXTBaseViewController.h
//  BXT
//
//  Created by Jason on 15/8/18.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTHeaderForVC.h"

#define KNavViewTag 23

typedef void (^HaveHidden)(BOOL hidden);

@interface BXTBaseViewController : UIViewController

@property (nonatomic, assign) BOOL       isNewWorkOrder;//我要报修
@property (nonatomic, assign) BOOL       isRepairList;//报修列表
@property (nonatomic, copy  ) HaveHidden havedHidden;

- (UIImageView *)navigationSetting:(NSString *)title
                     andRightTitle:(NSString *)right_title
                     andRightImage:(UIImage *)image;

- (UIView *)navigationSetting:(NSString *)title
                    backColor:(UIColor *)color
                   rightImage:(UIImage *)image;

- (void)navigationLeftButton;

- (void)navigationRightButton;

- (void)showMBP:(NSString *)text
      withBlock:(HaveHidden)block;

- (void)showLoadingMBP:(NSString *)text;

- (void)hideMBP;

- (NSString*)dataToJsonString:(id)object;

- (id)toArrayOrNSDictionary:(NSData *)jsonData;

@end
