//
//  BXTMeterReadingHeaderView.h
//  YouFeel
//
//  Created by 满孝意 on 16/6/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMeterReadingHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *bgViewBtn;
@property (weak, nonatomic) IBOutlet UIImageView *openImage;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *codeView;
@property (weak, nonatomic) IBOutlet UILabel *rateView;

@property (weak, nonatomic) IBOutlet UIView *bgFooterView;

@property (weak, nonatomic) IBOutlet UILabel *setPlaceView;
@property (weak, nonatomic) IBOutlet UILabel *serviceView;
@property (weak, nonatomic) IBOutlet UILabel *rangeView;

@end
