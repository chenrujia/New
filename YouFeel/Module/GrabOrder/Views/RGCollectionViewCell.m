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

@implementation RGCollectionViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = colorWithHexString(@"ffffff");
        self.layer.cornerRadius = 10.f;
        self.layer.masksToBounds = YES;

        [self requestDetail];

        CGFloat space = IS_IPHONE6 ? 15.f : 10.f;
        CGFloat height = IS_IPHONE6 ? 200.f : 133;
        
        self.imageView = ({
        
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, frame.size.width - space * 2.f, height)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.layer.masksToBounds = YES;
            [self addSubview:imgView];
            imgView;
            
        });
        
        self.repairID = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_imageView.frame) + 15.f, CGRectGetWidth(_imageView.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.location = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_repairID.frame) + 10.f, CGRectGetWidth(_repairID.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.cause = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_location.frame) + 10.f, CGRectGetWidth(_location.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
        self.level = ({
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_cause.frame) + 10.f, CGRectGetWidth(_cause.frame), 20)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont boldSystemFontOfSize:17.f];
            [self addSubview:label];
            label;
        
        });
        
//        self.backView = ({
//        
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 140.f + 4.f, CGRectGetMinY(_level.frame) + 15.f, 140.f, 42.f)];
//            view.backgroundColor = colorWithHexString(@"9bba30");
//            view.layer.cornerRadius = 5;
//            [self addSubview:view];
//            view;
//        
//        });
//        
//        
//        UIImageView *coinImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 10.f, 22.f, 22.f)];
//        coinImgView.image = [UIImage imageNamed:@"Coin_icon"];
//        [_backView addSubview:coinImgView];
//        
//        self.coinLabel = ({
//            
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coinImgView.frame), 10.f, CGRectGetWidth(_backView.frame) - CGRectGetMaxX(coinImgView.frame), 22)];
//            label.textColor = colorWithHexString(@"ffffff");
//            label.textAlignment = NSTextAlignmentCenter;
//            label.font = [UIFont boldSystemFontOfSize:14.f];
//            label.text = @"可获得25金币";
//            [_backView addSubview:label];
//            label;
//            
//        });
        
    }
    return self;
}

#pragma mark -
#pragma mark 事件
- (void)requestDetail
{
    /**获取详情**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairDetail:[NSString stringWithFormat:@"%ld",(long)21]];
}

#pragma mark -
#pragma mark 代理
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    LogRed(@"dic......%@",dic);
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairDetail && data.count > 0)
    {
        NSDictionary *dictionary = data[0];
        
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        DCObjectMapping *map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"repairID" onClass:[BXTRepairDetailInfo class]];
        [config addObjectMapping:map];
        
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTRepairDetailInfo class] andConfiguration:config];
        BXTRepairDetailInfo *repairDetail = [parser parseDictionary:dictionary];
        
        NSArray *imgArray = repairDetail.fault_pic;
        if (imgArray.count > 0)
        {
            NSDictionary *image_dic = imgArray[0];
            [_imageView sd_setImageWithURL:[NSURL URLWithString:[image_dic objectForKey:@"photo_file"]]];
        }
        
        _repairID.text = [NSString stringWithFormat:@"工单号:%@",repairDetail.orderid];
        _location.text = [NSString stringWithFormat:@"位置:%@",repairDetail.place_name];
        _cause.text = [NSString stringWithFormat:@"故障描述:%@",repairDetail.cause];
        
        NSString *str;
        NSRange range;
        if (repairDetail.urgent == 1)
        {
            str = @"等级:紧急";
            range = [str rangeOfString:@"紧急"];
        }
        else if (repairDetail.urgent == 2)
        {
            str = @"等级:一般";
            range = [str rangeOfString:@"一般"];
        }
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
        _level.attributedText = attributeStr;
    }
}

- (void)requestError:(NSError *)error
{
    
}

@end