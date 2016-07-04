//
//  BXTEnergyBaseViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTHeaderFile.h"

@interface BXTEnergyBaseViewController : UIViewController

/**
 *  1 - 最右边  2 - 次最右
 *  有 1  才有 2
 */
- (void)navigationSetting:(NSString *)title
           andRightTitle1:(NSString *)right_title1
           andRightImage1:(UIImage *)image1
           andRightTitle2:(NSString *)right_title2
           andRightImage2:(UIImage *)image2;

@property (nonatomic, strong) UIButton *rightButton1;

- (void)navigationRightButton1;

- (void)navigationRightButton2;

@end
