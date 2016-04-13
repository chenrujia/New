//
//  BXTCustomButton.h
//  AttributeViewDemo
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 tangjp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomButtonType) {
    FaultTypeType,//故障类型
    SelectBtnType,//选择按钮（例如：设备列表选择按钮）
    GroupBtnType//分组名称（增员列表中使用）
};

@interface BXTCustomButton : UIButton

@property (nonatomic, assign) CustomButtonType customBtnType;

- (instancetype)initWithType:(CustomButtonType)btnType;

@end
