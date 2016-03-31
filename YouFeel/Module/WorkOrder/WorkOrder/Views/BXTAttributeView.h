//
//  AttributeCollectionView.h
//  天巢新1期
//
//  Created by 唐建平 on 15/12/15.
//  Copyright © 2015年 JP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTOrderTypeInfo.h"

@class BXTAttributeView;

@protocol AttributeViewDelegate<NSObject>

@optional

- (void)attributeViewSelectType:(BXTOrderTypeInfo *)selectType;

@end

@interface BXTAttributeView : UIView

@property(nonatomic,assign)id <AttributeViewDelegate>attribute_delegate;

+ (BXTAttributeView *)attributeViewWithTitleFont:(UIFont *)font attributeTexts:(NSArray *)texts viewWidth:(CGFloat)viewWidth delegate:(id <AttributeViewDelegate>)delegate;

@end
