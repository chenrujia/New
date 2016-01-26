//
//  CompletionFooter.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/1.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTCompletionFooter.h"
#import "BXTGlobal.h"

@implementation BXTCompletionFooter

- (void)awakeFromNib {
    // Initialization code
    
    self.pointView.layer.cornerRadius = 10.25;
    self.pointView.layer.masksToBounds = YES;
    self.pointView.backgroundColor = colorWithHexString(@"#FD7070");
    
    self.pointView1.layer.cornerRadius = 10.25;
    self.pointView1.layer.masksToBounds = YES;
    self.pointView1.backgroundColor = colorWithHexString(@"#F9D063");
    
    self.pointView2.layer.cornerRadius = 10.25;
    self.pointView2.layer.masksToBounds = YES;
    self.pointView2.backgroundColor = colorWithHexString(@"#0FCCC0");
    
    self.roundView.layer.cornerRadius = 5;
    self.roundView.layer.masksToBounds = YES;
    self.roundView.backgroundColor = colorWithHexString(@"#0FCCC0");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
