//
//  CompletionHeader.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/1.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTCompletionHeader.h"
#import "BXTGlobal.h"

@implementation BXTCompletionHeader

- (void)awakeFromNib {
    // Initialization code
    self.roundView1.layer.cornerRadius = 5;    
    self.roundView2.layer.cornerRadius = 5;
    self.roundView3.layer.cornerRadius = 5;
    self.roundView4.layer.cornerRadius = 5;
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.transBtnClick) {
        self.transBtnClick(sender.tag);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
