//
//  ProfessionFooter.m
//  YouFeel
//
//  Created by 满孝意 on 15/11/28.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTProfessionFooter.h"
#import "BXTGlobal.h"

@implementation BXTProfessionFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.roundView.layer.cornerRadius = 5;
    self.roundView1.layer.cornerRadius = 5;
    self.roundView2.layer.cornerRadius = 5;
    self.roundView3.layer.cornerRadius = 5;
    
    self.pointView.layer.cornerRadius = 10.25;
    self.pointView.layer.masksToBounds = YES;
    self.pointView.backgroundColor = colorWithHexString(@"#F9D063");
    
    self.pointView1.layer.cornerRadius = 10.25;
    self.pointView1.layer.masksToBounds = YES;
    self.pointView1.backgroundColor = colorWithHexString(@"#FD7070");
    
    self.pointView2.layer.cornerRadius = 10.25;
    self.pointView2.layer.masksToBounds = YES;
    self.pointView2.backgroundColor = colorWithHexString(@"#0FCCC0");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
