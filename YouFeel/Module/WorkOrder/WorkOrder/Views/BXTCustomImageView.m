//
//  BXTCustomImageView.m
//  NavItem
//
//  Created by Jason on 16/1/21.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTCustomImageView.h"
#define IMAGEWIDTH 67.5f

@implementation BXTCustomImageView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        //侦听长按事件
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"LongPress" object:nil] subscribeNext:^(id x) {
            @strongify(self);
            [self longPress];
        }];
        
        //侦听删除事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"DeleteTheImage" object:nil];
        
        //添加长按手势
        UILongPressGestureRecognizer *recognize = [[UILongPressGestureRecognizer alloc] init];
        [[recognize rac_gestureSignal] subscribeNext:^(id x) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LongPress" object:nil];
        }];
        
        //长按响应时间
        recognize.minimumPressDuration = 1;
        [self addGestureRecognizer:recognize];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"deleteImage"] forState:UIControlStateNormal];
        _deleteBtn.frame= CGRectMake(0, 0, 44, 44);
        _deleteBtn.hidden = YES;
        [[_deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteTheImage" object:[NSNumber numberWithInteger:self.tag]];
        }];
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_deleteBtn setCenter:CGPointMake(CGRectGetMaxX(self.bounds) - 22, 22)];
}

- (void)deleteImage:(NSNotification *)notification
{
    NSNumber *number = notification.object;
    CGRect addBtnRect = CGRectMake(10.f, 170.f - IMAGEWIDTH - 10.f, IMAGEWIDTH, IMAGEWIDTH);
    
    if (self.tag == [number integerValue])
    {
        self.frame = addBtnRect;
        self.image = nil;
        _isGetBack = YES;
    }
    else if (self.tag > [number integerValue])
    {
        [UIView animateWithDuration:1.f animations:^{
            
            CGRect rect = self.frame;
            rect.origin.x -= IMAGEWIDTH + 10;
            self.frame = rect;
            
        } completion:^(BOOL finished) {
            [self pause];
        }];
    }
    else
    {
        
    }
    [self pause];
}

- (void)longPress
{
    if (!_isGetBack)
    {
        _deleteBtn.hidden = NO;
        [self shakeImage];
    }
}

- (void)shakeImage
{
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置属性，周期时长
    [animation setDuration:0.08];
    //抖动角度
    animation.fromValue = @(-M_1_PI/4);
    animation.toValue = @(M_1_PI/4);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.layer addAnimation:animation forKey:@"rotation"];
}

- (void)pause
{
    _deleteBtn.hidden = YES;
    [self.layer removeAnimationForKey:@"rotation"];
}

@end
