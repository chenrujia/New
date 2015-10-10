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

- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, weak) id<SegmentViewDelegate> delegate;

-(void)segemtBtnChange:(NSInteger)index;

@end