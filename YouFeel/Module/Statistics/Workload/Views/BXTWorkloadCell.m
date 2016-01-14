//
//  WorkloadCell.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/2.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTWorkloadCell.h"
#import "BXTGlobal.h"

@implementation BXTWorkloadCell

- (void)awakeFromNib {
    // Initialization code
    self.roundView.layer.cornerRadius = 5;
    self.roundView.backgroundColor = colorWithHexString(@"#00D0C0");
    
    self.roundView1.layer.cornerRadius = 5;
    self.roundView1.backgroundColor = colorWithHexString(@"#F9D063");
    
    self.roundView2.layer.cornerRadius = 5;
    self.roundView2.backgroundColor = colorWithHexString(@"#F86494");
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
