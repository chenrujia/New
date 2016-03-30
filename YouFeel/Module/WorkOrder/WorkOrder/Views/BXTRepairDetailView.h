//
//  BXTRepairDetailView.h
//  YouFeel
//
//  Created by Jason on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//  为解决一个蛋疼问题而生的文件

#import <UIKit/UIKit.h>

typedef void (^RepairNotesBlock)(NSString *notes);

@interface BXTRepairDetailView : UIView <UITextViewDelegate>

@property (nonatomic, copy) RepairNotesBlock notesBlock;

- (instancetype)initWithFrame:(CGRect)frame block:(RepairNotesBlock)block;

@end
