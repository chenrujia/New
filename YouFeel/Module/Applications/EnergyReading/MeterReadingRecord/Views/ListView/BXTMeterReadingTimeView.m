//
//  BXTMeterReadingTimeView.m
//  HHHHHH
//
//  Created by 满孝意 on 16/7/4.
//  Copyright © 2016年 满孝意. All rights reserved.
//

#import "BXTMeterReadingTimeView.h"
#import "BXTGlobal.h"

@implementation BXTMeterReadingTimeView

+ (instancetype)viewForMeterReadingTime
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BXTMeterReadingTimeView" owner:nil options:nil] lastObject];
}

- (void)setLists:(BXTRecordListsInfo *)lists
{
    _lists = lists;
    
    self.nameView.text = lists.name;
    self.valueView.text = [NSString stringWithFormat:@"%@ %@", lists.total_num, self.unit];
    self.numView.text = [NSString stringWithFormat:@"%@ %@", lists.use_amount, self.unit];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:[BXTGlobal transformationTime:@"yyyy\ndd/MM\nHH:mm" withTime:lists.create_time]];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:18.0]
                          range:NSMakeRange(5, 2)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor whiteColor]
                          range:NSMakeRange(5, 5)];
    
    self.timeView.attributedText = AttributedStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.roundView.layer.cornerRadius = self.roundView.frame.size.width / 2;
}

@end
