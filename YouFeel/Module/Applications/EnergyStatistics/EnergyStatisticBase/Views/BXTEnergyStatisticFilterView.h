//
//  BXTEnergyStatisticFilterView.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTEnergyStatisticFilterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *lastTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *thisTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextTimeBtn;

+ (instancetype)viewForEnergyStatisticFilterView;

@end
