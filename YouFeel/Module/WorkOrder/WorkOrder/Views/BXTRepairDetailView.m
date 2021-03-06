//
//  BXTRepairDetailView.m
//  YouFeel
//
//  Created by Jason on 16/3/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTRepairDetailView.h"
#import "BXTPublicSetting.h"
#import "BXTGlobal.h"

@implementation BXTRepairDetailView

- (instancetype)initWithFrame:(CGRect)frame block:(RepairNotesBlock)block
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.notesBlock = block;
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40.f, frame.size.height)];
        tv.backgroundColor = colorWithHexString(@"C3E6FF");
        tv.text = @"请输入报修内容（少于200字）";
        tv.textColor = colorWithHexString(@"3cafff");
        tv.font = [UIFont systemFontOfSize:17.f];
        tv.layer.cornerRadius = 3.f;
        tv.delegate = self;
        [self addSubview:tv];
    }
    return self;
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入报修内容（少于200字）"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1)
    {
        textView.text = @"请输入报修内容（少于200字）";
    }
    self.notesBlock(textView.text);
}

@end
