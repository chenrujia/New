//
//  RGCollectionViewCell.m
//  RGCardViewLayout
//
//  Created by ROBERA GELETA on 1/23/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import "RGCollectionViewCell.h"
#import "BXTHeaderForVC.h"
#import "UIImageView+WebCache.h"
#import "BXTRepairDetailInfo.h"
#import "BXTGlobal.h"
#import "UIView+Nav.h"

@implementation RGCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"ffffff");
        
        CGFloat space = IS_IPHONE6 ? 15.f : 10.f;
        CGFloat height = IS_IPHONE6 ? 263.f : 175;
        CGFloat moreH = IS_IPHONE6 ? 80.f : 70;
        
        self.scrollView = ({
            
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-moreH)];
            [self addSubview:scrollView];
            scrollView;
            
        });
        
        self.imageView = ({
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, frame.size.width - space * 2.f, height)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.layer.masksToBounds = YES;
            [self.scrollView addSubview:imgView];
            imgView;
            
        });
        
        self.repairTime = ({
            
            UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(170-25/2, CGRectGetMaxY(_imageView.frame) - 45.f, 25, 25)];
            label0.backgroundColor = colorWithHexString(@"c30e06");
            label0.layer.cornerRadius = 25/2;
            label0.layer.masksToBounds = YES;
            [self.imageView addSubview:label0];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) - 45.f, 170, 25)];
            label.backgroundColor = colorWithHexString(@"c30e06");
            label.textColor = colorWithHexString(@"ffffff");
            label.font = [UIFont systemFontOfSize:15.f];
            [self.imageView addSubview:label];
            label;
            
        });
        
        self.faulttype = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-15-80, CGRectGetMaxY(_imageView.frame) + 10.f, 60, 25)];
            label.textColor = colorWithHexString(@"3cb7ff");
            label.font = [UIFont systemFontOfSize:16.f];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.borderColor = [colorWithHexString(@"3cb7ff") CGColor];
            label.layer.borderWidth = 1.f;
            label.layer.cornerRadius = 5.f;
            [self.scrollView addSubview:label];
            label;
            
        });
        
        self.repairID = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_imageView.frame) + 15.f, CGRectGetWidth(_imageView.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:17.f];
            [self.scrollView addSubview:label];
            label;
            
        });
        
        self.location = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_repairID.frame) + 10.f, CGRectGetWidth(_repairID.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:17.f];
            [self.scrollView addSubview:label];
            label;
            
        });
        
        self.cause = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_location.frame) + 10.f, CGRectGetWidth(_location.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:17.f];
            [self.scrollView addSubview:label];
            label;
            
        });
        
        self.notes = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_cause.frame) + 10.f, CGRectGetWidth(_cause.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.font = [UIFont systemFontOfSize:17.f];
            [self.scrollView addSubview:label];
            label;
            
        });
        
        self.level = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_notes.frame) + 10.f, CGRectGetWidth(_notes.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:17.f];
            [self.scrollView addSubview:label];
            label;
            
        });
        
        self.remarks = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_level.frame) + 10.f, CGRectGetWidth(_level.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.font = [UIFont systemFontOfSize:17.f];
            [self.scrollView addSubview:label];
            label;
            
        });
    }
    return self;
}

#pragma mark -
#pragma mark 事件
- (void)requestDetailWithOrderID:(NSString *)orderID
{
    /**获取详情**/
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairDetail:orderID];
}

#pragma mark -
#pragma mark 代理
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (data.count > 0)
    {
        [self hideTheMBP];
        NSDictionary *dictionary = data[0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SUBGROUP_NOTIFICATION" object:dictionary[@"faulttype_type_name"]];
        [BXTRepairDetailInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"orderID":@"id"};
        }];
        [BXTMaintenanceManInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"mmID":@"id"};
        }];
        [BXTDeviceMMListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"deviceMMID":@"id"};
        }];
        [BXTAdsNameInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"adsNameID":@"id"};
        }];
        [BXTRepairPersonInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"rpID":@"id"};
        }];
        [BXTFaultPicInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"picID":@"id"};
        }];
        BXTRepairDetailInfo *repairDetail = [BXTRepairDetailInfo mj_objectWithKeyValues:dictionary];
        
        NSArray *imgArray = repairDetail.fault_pic;
        UIImage *placeImage;
        if (IS_IPHONE6P)
        {
            placeImage = [UIImage imageNamed:@"grabIphoneplus"];
        }
        else if (IS_IPHONE6)
        {
            placeImage = [UIImage imageNamed:@"grabIphone6"];
        }
        else if (IS_IPHONE5)
        {
            placeImage = [UIImage imageNamed:@"grabIphone5s"];
        }
        else
        {
            placeImage = [UIImage imageNamed:@"grabIphone4s"];
        }
        if (imgArray.count > 0)
        {
            BXTFaultPicInfo *picInfo = imgArray[0];
            [_imageView sd_setImageWithURL:[NSURL URLWithString:picInfo.photo_file] placeholderImage:placeImage];
        }
        else
        {
            [_imageView setImage:placeImage];
        }
        
        //???: 这个时间没了
//        NSString *content = [NSString stringWithFormat:@"工单响应截止时间%@", [self transTimeStampToTime:repairDetail.long_time]];
//        _repairTime.text = content;
        
        NSString *subgroup_name = @"其他";
        if (![BXTGlobal isBlankString:repairDetail.subgroup_name])
        {
            subgroup_name = repairDetail.subgroup_name;
        }
        NSString *contents0 = subgroup_name;
        
        UIFont *font0 = [UIFont systemFontOfSize:16.f];
        CGSize size0 = MB_MULTILINE_TEXTSIZE(contents0, font0, CGSizeMake(SCREEN_WIDTH - 40.f, 1000.f), NSLineBreakByWordWrapping);
        _faulttype.frame = CGRectMake(_imageView.frame.size.width-size0.width-15, CGRectGetMaxY(_imageView.frame)+10, size0.width+10, 25);
        _faulttype.text = contents0;
        
        _repairID.text = [NSString stringWithFormat:@"工单号：%@",repairDetail.orderid];
        _location.text = [NSString stringWithFormat:@"位置：%@",repairDetail.place_name];
        NSString *contents = [NSString stringWithFormat:@"故障描述：%@",repairDetail.cause];
        UIFont *font = [UIFont systemFontOfSize:17.f];
        CGSize size = MB_MULTILINE_TEXTSIZE(contents, font, CGSizeMake(SCREEN_WIDTH - 40.f, 1000.f), NSLineBreakByWordWrapping);
        
        _cause.text = [NSString stringWithFormat:@"故障类型：%@",repairDetail.faulttype_name];
        _notes.frame = CGRectMake(15.f, CGRectGetMaxY(_cause.frame) + 10.f, CGRectGetWidth(_cause.frame), size.height);
        _level.frame = CGRectMake(15.f, CGRectGetMaxY(_notes.frame) + 10.f, CGRectGetWidth(_notes.frame), 20);
        _notes.text = contents;
        
        NSString *contents2 = [NSString stringWithFormat:@"备注：%@", repairDetail.cause];
        CGSize size2 = MB_MULTILINE_TEXTSIZE(contents2, font, CGSizeMake(SCREEN_WIDTH - 40.f, 1000.f), NSLineBreakByWordWrapping);
        _remarks.frame = CGRectMake(15.f, CGRectGetMaxY(_level.frame) + 10.f, CGRectGetWidth(_level.frame), size2.height);
        _remarks.text = contents2;
        
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, CGRectGetMaxY(_remarks.frame));
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowError" object:nil];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowError" object:nil];
}

- (NSString *)transTimeStampToTime:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]]];
    return dateTime;
}

@end