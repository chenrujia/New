//
//  BXTMeterReadingTimeView.h
//  HHHHHH
//
//  Created by 满孝意 on 16/7/4.
//  Copyright © 2016年 满孝意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTMeterReadingRecordListInfo.h"

@interface BXTMeterReadingTimeView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeView;

@property (weak, nonatomic) IBOutlet UIView *roundView;

@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
/** ---- value - 值 ---- */
@property (weak, nonatomic) IBOutlet UILabel *valueView;
/** ---- num - 量 ---- */
@property (weak, nonatomic) IBOutlet UILabel *numView;
@property (weak, nonatomic) IBOutlet UIButton *showViewBtn;

@property (nonatomic, strong) BXTRecordListsInfo *lists;

+ (instancetype)viewForMeterReadingTime;

@end
