//
//  BXTChangeStateViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef void (^ChangeText)(NSString * text);

@interface BXTChangeStateViewController : BXTBaseViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel    *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel    *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton   *commitBtn;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (nonatomic, strong) NSString   *titleText;
@property (nonatomic, strong) NSString   *detailText;
@property (nonatomic, strong) NSString   *notes;
@property (nonatomic, copy  ) ChangeText changeText;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                      withNotes:(NSString *)notes
                      withTitle:(NSString *)title
                     withDetail:(NSString *)detail;

- (void)valueChanged:(ChangeText)block;

@end
