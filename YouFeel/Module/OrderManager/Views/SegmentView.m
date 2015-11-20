//
//  SegmentView.m
//
//  Created by apple on 15-8-30.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "SegmentView.h"
#import "UIImage+SubImage.h"
#import "BXTHeaderFile.h"
#import "BXTGlobal.h"

@interface MyButton: UIButton
@end

@implementation MyButton
- (void)setHighlighted:(BOOL)highlighted{}
@end

@interface SegmentView()
{
    UIButton *_currentBtn;
    UIButton *_preformBtn;
}
@end

@implementation SegmentView
- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame])
    {
        self.titles = titles;
        self.tag = 100;
    }
    return self;
}

- (void)btnDown:(UIButton *)btn
{
    if (btn == _currentBtn) return;
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectedSegmentAtIndex:)])
    {
        [self.delegate segmentView:self didSelectedSegmentAtIndex:btn.tag];
    }
}

-(void)segemtBtnChange:(NSInteger)index
{
    UIButton *btn=(UIButton *)[self viewWithTag:index];
    if (btn == _currentBtn) return;
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
}


- (void)setTitles:(NSArray *)titles
{
    // 数组内容一致，直接返回
    if ([titles isEqualToArray:_titles]) return;
        
    _titles = titles;
    
    
    // 1.移除所有的按钮
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 2.添加新的按钮
    NSInteger count = titles.count;
    float btnWidth = (self.frame.size.width - (count - 1))/count;
    for (int i = 0; i<count; i++)
    {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        
        // 设置按钮的frame
        btn.frame = CGRectMake(i + i * btnWidth, 0, btnWidth, CGRectGetHeight(self.frame));
        NSString *normal = @"Rectangle_1";
        NSString *selected;
        if ([BXTGlobal shareGlobal].isRepair)
        {
            selected = @"Rectangle_3";
            [btn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateSelected];
            [btn setTitleColor:colorWithHexString(@"0a439c") forState:UIControlStateNormal];
        }
        else
        {
            selected = @"Rectangle_2";
            [btn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateSelected];
            [btn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        }
        [btn setBackgroundImage:[UIImage resizeImage:normal] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizeImage:selected] forState:UIControlStateSelected];
        
        // 设置文字
        // btn.adjustsImageWhenHighlighted = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        
        // 设置监听器
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        // 设置选中
        if (i == 0)
        {
            [self btnDown:btn];
        }
        // 添加按钮
        [self addSubview:btn];
        
        if (i < count - 1)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 0, 1.f, CGRectGetHeight(self.frame))];
            lineView.backgroundColor = colorWithHexString(@"3cafff");
            [self addSubview:lineView];
        }
    }
}
@end
