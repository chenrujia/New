//
//  AttributeCollectionView.m
//  天巢新1期
//
//  Created by 唐建平 on 15/12/15.
//  Copyright © 2015年 JP. All rights reserved.
//

#import "BXTAttributeView.h"
#import "UIView+Extnesion.h"
#import "BXTCustomButton.h"
#import "BXTPublicSetting.h"

#define marginW 40
#define marginH 15

@interface BXTAttributeView ()

@property (nonatomic ,weak  ) UIButton *btn;
@property (nonatomic, strong) NSArray  *dataSource;

@end

@implementation BXTAttributeView

+ (BXTAttributeView *)attributeViewWithTitleFont:(UIFont *)font attributeTexts:(NSArray *)texts viewWidth:(CGFloat)viewWidth
{
    int count = 0;
    float btnW = 0;
    BXTAttributeView *view = [[BXTAttributeView alloc]init];
    view.dataSource = texts;
    
    for (int i = 0; i < texts.count; i++)
    {
        BXTCustomButton *btn = [[BXTCustomButton alloc]init];
        btn.tag = i;
        [btn addTarget:view action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        BXTOrderTypeInfo *orderTypeInfo = texts[i];
        [btn setTitle:orderTypeInfo.faulttype forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        CGSize strsize = MB_MULTILINE_TEXTSIZE(orderTypeInfo.faulttype, [UIFont boldSystemFontOfSize:13], CGSizeMake(1000.f, 300), NSLineBreakByWordWrapping);
        btn.width = strsize.width + marginW;
        btn.height = strsize.height+ marginH;
        
        if (i == 0)
        {
            btn.x = 15.f;
            btnW += CGRectGetMaxX(btn.frame);
        }
        else
        {
            btnW += CGRectGetMaxX(btn.frame) + 20.f;
            if (btnW > viewWidth)
            {
                count++;
                btn.x = 15.f;
                btnW = CGRectGetMaxX(btn.frame);
            }
            else
            {
                btn.x += btnW - btn.width;
            }
        }
        btn.userInteractionEnabled = YES;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setImage:[UIImage imageNamed:@"wo_ellipse"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"wo_ellipse_select"] forState:UIControlStateSelected];
        btn.y += count * btn.height + marginH;
        btn.tag = i;
        [view addSubview:btn];
        
        if (i == 0)
        {
            [view btnClick:btn];
        }
        else if (i == texts.count - 1)
        {
            view.height = CGRectGetMaxY(btn.frame) + 10;
            view.x = 0;
            view.width = viewWidth;
        }
    }
    
    return view;
}

- (void)btnClick:(UIButton *)sender
{
    if (![self.btn isEqual:sender])
    {
        self.btn.selected = NO;
        sender.selected = YES;
    }
    else if([self.btn isEqual:sender])
    {
        if (sender.selected == YES)
        {
            sender.selected = NO;
        }
        else
        {
            sender.selected = YES;
        }
    }
    if ([self.attribute_delegate respondsToSelector:@selector(attributeViewSelectType:)])
    {
        BXTOrderTypeInfo *orderTypeInfo = _dataSource[sender.tag];
        [self.attribute_delegate attributeViewSelectType:orderTypeInfo];
    }
    self.btn = sender;
}

@end
