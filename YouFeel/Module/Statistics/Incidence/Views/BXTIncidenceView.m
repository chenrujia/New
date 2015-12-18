//
//  IncidenceView.m
//  YouFeel
//
//  Created by 满孝意 on 15/11/28.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTIncidenceView.h"
#import "BXTGlobal.h"

@implementation BXTIncidenceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleView = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, frame.size.width-200, 30)];
        self.titleView.text = @"每日排名";
        self.titleView.textAlignment = NSTextAlignmentCenter;
        self.titleView.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 50, frame.size.width-30, 0.5)];
        line.backgroundColor = colorWithHexString(@"#d9d9d9");
        [self addSubview:line];
        
        CGFloat viewW = frame.size.width - 50;
        CGFloat viewH  = 25;
        CGFloat viewX = 25;
        CGFloat viewY = 60;
        
        self.rangkingView = [[UILabel alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        self.rangkingView.text = @"排名：2";
        self.rangkingView.textColor = [UIColor darkGrayColor];
        self.rangkingView.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.rangkingView];
        
        self.groupView = [[UILabel alloc] initWithFrame:CGRectMake(viewX, viewY+viewH*1, viewW, viewH)];
        self.groupView.text = @"故障分类：2";
        self.groupView.textColor = [UIColor darkGrayColor];
        self.groupView.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.groupView];
        
        self.typeView = [[UILabel alloc] initWithFrame:CGRectMake(viewX, viewY+viewH*2, viewW, viewH)];
        self.typeView.text = @"故障类型：2";
        self.typeView.textColor = [UIColor darkGrayColor];
        self.typeView.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.typeView];
        
        self.repairView = [[UILabel alloc] initWithFrame:CGRectMake(viewX, viewY+viewH*3, viewW, viewH)];
        self.repairView.text = @"报修：2";
        self.repairView.textColor = [UIColor darkGrayColor];
        self.repairView.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.repairView];
        
        self.ratioView = [[UILabel alloc] initWithFrame:CGRectMake(viewX, viewY+viewH*4, viewW, viewH)];
        self.ratioView.text = @"比例：2";
        self.ratioView.textColor = [UIColor darkGrayColor];
        self.ratioView.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.ratioView];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-55, frame.size.width, 10)];
        line2.backgroundColor = [UIColor colorWithRed:0.93 green:0.95 blue:0.96 alpha:1.00];
        line2.layer.borderColor = [colorWithHexString(@"#d9d9d9")CGColor];
        line2.layer.borderWidth = 0.5;
        [self addSubview:line2];
        
        self.cancelView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelView.frame = CGRectMake(0, frame.size.height-45, frame.size.width, 45);
        [self.cancelView setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelView setTitleColor:[UIColor colorWithRed:0.25 green:0.68 blue:0.96 alpha:1.0] forState:UIControlStateNormal];
        [self.cancelView addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelView];
    }
    return self;
}

- (void)btnClick {
    if (self.transClick) {
        self.transClick();
    }
}

@end
