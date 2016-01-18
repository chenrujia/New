//
//  SegmentView.h
//
//  Created by apple on 15-8-30.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentView;

@protocol SegmentViewDelegate <NSObject>
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index;
@end

@interface SegmentView : UIView

/**
 *  初始化SegmentView
 *
 *  @param isWhite 1为白底
 */
- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles isWhiteBGColor:(BOOL)isWhite;

@property (nonatomic, strong) NSArray *titles;
/**
 *  需要白色背景
 */
@property (nonatomic, assign) BOOL isBgColorWhite;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, weak) id<SegmentViewDelegate> delegate;

-(void)segemtBtnChange:(NSInteger)index;

@end