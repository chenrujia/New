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

@interface BXTBaseViewController : UIViewController

@property (nonatomic, assign) BOOL       isNewWorkOrder;//我要报修
@property (nonatomic, assign) BOOL       isRepairList;//报修列表

- (UIImageView *)navigationSetting:(NSString *)title
                     andRightTitle:(NSString *)right_title
                     andRightImage:(UIImage *)image;

- (UIView *)navigationSetting:(NSString *)title
                    backColor:(UIColor *)color
                   rightImage:(UIImage *)image;

- (void)navigationLeftButton;

- (void)navigationRightButton;

- (NSString*)dataToJsonString:(id)object;

- (id)toArrayOrNSDictionary:(NSData *)jsonData;

@end
