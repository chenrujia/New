//
//  IncidenceView.h
//  YouFeel
//
//  Created by 满孝意 on 15/11/28.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTIncidenceView : UIView

@property (nonatomic, strong) UILabel *rangkingView;
@property (nonatomic, strong) UILabel *groupView;
@property (nonatomic, strong) UILabel *typeView;
@property (nonatomic, strong) UILabel *repairView;
@property (nonatomic, strong) UILabel *ratioView;
@property (nonatomic, strong) UIButton *cancelView;

typedef void (^blockTClick)(void);
@property(nonatomic, copy) blockTClick transClick;

@end
