//
//  HySideScrollingImagePicker.h
//  TestProject
//
//  Created by Apple on 15/6/25.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

//Blocks
typedef void(^SeletedImages)(NSArray *GetImages, NSInteger Buttonindex);

typedef void(^SeletedButtonIndex)(NSInteger Buttonindex);

typedef void(^CompleteAnimationBlock)(BOOL Complete);

@interface HySideScrollingImagePicker : UIView

@property (nonatomic,assign) BOOL isMultipleSelection;
/**
 *  是否只能选择一张，默认可多选
 */
@property (nonatomic,assign) BOOL isSinglePicture;

@property (nonatomic,strong) SeletedImages SeletedImages;

- (instancetype)initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray *)Titles;

- (void)DismissBlock:(CompleteAnimationBlock)block;

@end

@interface HyActionSheet : UIView

@property (nonatomic,strong)    SeletedButtonIndex ButtonIndex;

- (instancetype)initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray *)Titles AttachTitle:(NSString *)AttachTitle;

- (void)ChangeTitleColor:(UIColor *)color AndIndex:(NSInteger )index;

@end
