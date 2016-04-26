//
//  BXTWorkLoadShowView.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTWorkLoadShowView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *sumView;

@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;

@property (weak, nonatomic) IBOutlet UILabel *goodJobView;
@property (weak, nonatomic) IBOutlet UILabel *badJobView;
@property (weak, nonatomic) IBOutlet UILabel *unCompleteView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
