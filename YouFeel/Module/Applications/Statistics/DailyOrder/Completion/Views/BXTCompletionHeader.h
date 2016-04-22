//
//  CompletionHeader.h
//  YouFeel
//
//  Created by 满孝意 on 15/12/1.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPieView.h"

@interface BXTCompletionHeader : UIView

typedef void(^blockTbtnClick)(NSInteger tag);
@property (nonatomic, copy) blockTbtnClick transBtnClick;

@property (weak, nonatomic) IBOutlet MYPieView *pieView;
@property (weak, nonatomic) IBOutlet UILabel *roundTitleView;

@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;
@property (weak, nonatomic) IBOutlet UIView *roundView4;

@property (weak, nonatomic) IBOutlet UILabel *sumView;
@property (weak, nonatomic) IBOutlet UILabel *goodJobView;
@property (weak, nonatomic) IBOutlet UILabel *badJobView;
@property (weak, nonatomic) IBOutlet UILabel *unCompleteView;

@property (weak, nonatomic) IBOutlet UIButton *sumBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodJobBtn;
@property (weak, nonatomic) IBOutlet UIButton *badJobBtn;
@property (weak, nonatomic) IBOutlet UIButton *unCompleteBtn;

- (IBAction)btnClick:(UIButton *)sender;

@end
