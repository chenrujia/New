//
//  MYAlertAction.h
//  MyFramework
//
//  Created by 满孝意 on 15/12/22.
//  Copyright © 2015年 满孝意. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYAlertAction : NSObject

/**
 *  UIAlertView模式对话框(iOS版本自适应)
 *
 *  @param title        标题
 *  @param msg          提示内容
 *  @param block        返回点击的按钮index,按照buttonsStatement按钮的顺序，从0开始
 *  @param cancelString   取消按钮 文本，必须以nil结束
 */
+ (void)showAlertWithTitle:(NSString*)title msg:(NSString*)msg chooseBlock:(void (^)(NSInteger buttonIdx))block  buttonsStatement:(NSString*)cancelString, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  UIActionSheet模式对话框(iOS版本自适应)
 *
 *  @param title                  标题
 *  @param message                消息内容
 *  @param block                  返回block,buttonIdx:cancelString,destructiveButtonTitle分别为0、1,
 otherButtonTitle从后面开始，如果destructiveButtonTitle没有，buttonIndex1开始，反之2开始
 *  @param cancelString           取消文本
 *  @param destructiveButtonTitle 特殊标记按钮，默认红色
 *  @param otherButtonTitle       其他选项,必须以nil结束
 */
+ (void)showActionSheetWithTitle:(NSString*)title message:(NSString*)message chooseBlock:(void (^)(NSInteger buttonIdx))block cancelButtonTitle:(NSString*)cancelString destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitle:(NSString*)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;

@end
