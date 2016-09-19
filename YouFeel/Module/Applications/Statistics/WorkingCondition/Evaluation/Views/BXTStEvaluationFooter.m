//
//  EvaluationFooter.m
//  YouFeel
//
//  Created by 满孝意 on 15/11/27.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTStEvaluationFooter.h"
#import "BXTGlobal.h"

@implementation BXTStEvaluationFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.roundView.layer.cornerRadius = 5;
    self.roundView.backgroundColor = colorWithHexString(@"#0C88CE");
    
    self.roundView1.layer.cornerRadius = 5;
    self.roundView1.backgroundColor = colorWithHexString(@"#F86494");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
