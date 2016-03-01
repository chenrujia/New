//
//  BXTEPSummaryView.h
//  YouFeel
//
//  Created by 满孝意 on 16/2/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPieView.h"

@interface BXTEPSummaryView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *sumView;

@property (weak, nonatomic) IBOutlet UILabel *allView;
@property (weak, nonatomic) IBOutlet UILabel *runningView;
@property (weak, nonatomic) IBOutlet UILabel *stopView;
@property (weak, nonatomic) IBOutlet UILabel *unableView;

@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;

- (IBAction)btnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *footerVIew;

@end
