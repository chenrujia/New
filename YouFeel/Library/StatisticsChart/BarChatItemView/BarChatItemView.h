//
//  BarChatItemView.h
//  BarChatItemDemo
//
//  Created by 满孝意 on 15/11/25.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarChatItemView : UIView
{
    UIView          *lastTapView;
    UILabel         *valueLabel;
    BOOL            selected;
    NSMutableArray  *ItemShowViewArray;
    
    UIScrollView    *contentSV;
    UIView          *contentView;
}

typedef void (^blockT)(NSInteger index);
@property(nonatomic, copy) blockT transSelected2;

@property(nonatomic,retain)NSArray *dateArray;
@property(nonatomic,retain)NSArray *ItemArray;
@property(nonatomic,retain)NSArray *dataArray;

@end
