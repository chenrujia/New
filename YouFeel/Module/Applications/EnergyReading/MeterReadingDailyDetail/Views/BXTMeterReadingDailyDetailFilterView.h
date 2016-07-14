//
//  BXTMeterReadingDailyDetailFilterView.h
//  YouFeel
//
//  Created by 满孝意 on 16/7/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMeterReadingDailyDetailFilterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeView;

@property (weak, nonatomic) IBOutlet UIButton *lastMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextMonthBtn;

+ (instancetype)viewForBXTMeterReadingDailyDetailFilterView;

@end
