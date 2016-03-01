//
//  BXTMTCompletionFooter.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AksStraightPieChart.h"

@interface BXTMTCompletionFooter : UIView

@property (weak, nonatomic) IBOutlet AksStraightPieChart *pieView;

@property (weak, nonatomic) IBOutlet UIView *imageView1;
@property (weak, nonatomic) IBOutlet UIView *imageView2;
@property (weak, nonatomic) IBOutlet UIView *imageView3;
@property (weak, nonatomic) IBOutlet UIView *imageView4;

@property (weak, nonatomic) IBOutlet UILabel *allView;
@property (weak, nonatomic) IBOutlet UILabel *downView;
@property (weak, nonatomic) IBOutlet UILabel *doingView;
@property (weak, nonatomic) IBOutlet UILabel *undownView;

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;



@end
