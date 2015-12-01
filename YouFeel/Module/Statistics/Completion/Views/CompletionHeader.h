//
//  CompletionHeader.h
//  YouFeel
//
//  Created by 满孝意 on 15/12/1.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPieView.h"

@interface CompletionHeader : UIView

typedef void(^blockTbtnClick)(NSInteger tag);
@property (nonatomic, copy) blockTbtnClick transBtnClick;

@property (weak, nonatomic) IBOutlet MYPieView *pieView;
@property (weak, nonatomic) IBOutlet UIButton *sumView;
@property (weak, nonatomic) IBOutlet UIButton *downView;
@property (weak, nonatomic) IBOutlet UIButton *undownView;
@property (weak, nonatomic) IBOutlet UIButton *specialView;

- (IBAction)btnClick:(UIButton *)sender;

@end
