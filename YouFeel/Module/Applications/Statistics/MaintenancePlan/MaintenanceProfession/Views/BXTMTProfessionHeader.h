//
//  BXTMTProfessionHeader.h
//  YouFeel
//
//  Created by 满孝意 on 16/3/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPieView.h"

@interface BXTMTProfessionHeader : UIView

@property (weak, nonatomic) IBOutlet MYPieView *pieView;
@property (weak, nonatomic) IBOutlet UILabel *roundTitleView;

@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;
@property (weak, nonatomic) IBOutlet UIView *roundView4;

@property (weak, nonatomic) IBOutlet UILabel *allNumLabelView;
@property (weak, nonatomic) IBOutlet UILabel *downLabelView;
@property (weak, nonatomic) IBOutlet UILabel *doingLabelView;
@property (weak, nonatomic) IBOutlet UILabel *undownLabelView;
@property (weak, nonatomic) IBOutlet UILabel *unbeginLabelView;

@end
