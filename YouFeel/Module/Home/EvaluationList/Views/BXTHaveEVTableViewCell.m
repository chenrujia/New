//
//  BXTHaveEVTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/10/16.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTHaveEVTableViewCell.h"
#import "BXTHeaderForVC.h"

@implementation BXTHaveEVTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"ffffff");
        
        self.repairID = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 200.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
            
        });
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 50.f, SCREEN_WIDTH - 20, 0.7f)];
        lineView.backgroundColor = colorWithHexString(@"dee3e5");
        [self addSubview:lineView];
        
        self.place = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineView.frame) + 8.f, SCREEN_WIDTH - 30.f, 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
            
        });
        
        self.cause = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_place.frame) + 10.f, CGRectGetWidth(_place.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
            
        });
        
        UILabel *evaScore = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_cause.frame) + 10.f, 90.f, 20)];
        evaScore.textColor = colorWithHexString(@"000000");
        evaScore.font = [UIFont boldSystemFontOfSize:17.f];
        evaScore.text = @"综合评价：";
        [self addSubview:evaScore];

        self.ratingControl = ({
        
            UIImage *dot = [UIImage imageNamed:@"star_selected"];
            UIImage *star = [UIImage imageNamed:@"star"];
            AMRatingControl *rateView = [[AMRatingControl alloc] initWithLocation:CGPointMake(70, CGRectGetMaxY(_cause.frame) + 2.f)
                                                                                  emptyImage:dot
                                                                                  solidImage:star
                                                                                andMaxRating:5];
            rateView.userInteractionEnabled = NO;
            rateView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            [self addSubview:rateView];
            rateView;
        
        });
        
        UIView *lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 100.f, SCREEN_WIDTH - 20, 0.7f)];
        lineViewTwo.backgroundColor = colorWithHexString(@"dee3e5");
        [self addSubview:lineViewTwo];
        
        self.notes = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(lineViewTwo.frame) + 10.f, CGRectGetWidth(_cause.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
