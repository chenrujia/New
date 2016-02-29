//
//  BXTDrawView.h
//  BXT
//
//  Created by Jason on 15/9/9.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTDrawView : UIView

@property (nonatomic, strong) NSArray *progress;
@property (nonatomic ,assign) BOOL    isShow;

- (instancetype)initWithFrame:(CGRect)frame
                 withProgress:(NSArray *)progresses
                  isShowState:(BOOL)show;

@end
