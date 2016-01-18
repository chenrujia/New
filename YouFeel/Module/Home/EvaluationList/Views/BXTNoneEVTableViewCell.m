//
//  BXTNoneEVTableViewCell.m
//  YouFeel
//
//  Created by Jason on 15/10/16.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTNoneEVTableViewCell.h"
#import "BXTHeaderFile.h"
#import "UIImageView+WebCache.h"

@implementation BXTNoneEVTableViewCell

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
        
        self.evaButton = ({
        
            CGFloat width = IS_IPHONE6 ? 84.f : 56.f;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setFrame:CGRectMake(SCREEN_WIDTH - width - 15.f, 12.f, width, 30.f)];
            [button setTitle:@"评价" forState:UIControlStateNormal];
            [button setTitleColor:colorWithHexString(@"3aaeff") forState:UIControlStateNormal];
            button.layer.borderColor = colorWithHexString(@"3aaeff").CGColor;
            button.layer.borderWidth = 0.7f;
            button.layer.cornerRadius = 4.f;
            [self addSubview:button];
            button;
        
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
        
        [self reloadImageBackView];
        
        self.line = ({
        
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 160.f, SCREEN_WIDTH - 20, 0.7f)];
            view.backgroundColor = colorWithHexString(@"dee3e5");
            [self addSubview:view];
            view;
        
        });
        
        
        self.repairState = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(_line.frame) + 8.f, 100.f, 17.f)];
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:13.f];
            [self addSubview:label];
            label;
            
        });
        
        self.consumeTime = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100.f - 15.f, CGRectGetMaxY(_line.frame) + 8.f, 100.f, 17.f)];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = colorWithHexString(@"000000");
            label.font = [UIFont systemFontOfSize:13.f];
            [self addSubview:label];
            label;
            
        });
    }
    return self;
}

- (void)reloadImageBackView
{
    [_imgBackView removeFromSuperview];
    _imgBackView = nil;
    
    self.imgBackView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_cause.frame) + 10.f, SCREEN_WIDTH, 73.f)];
        [self addSubview:view];
        view;
        
    });
}

- (void)setPicsArray:(NSArray *)picsArray
{
    _picsArray = picsArray;
    
    if (_picsArray.count > 0)
    {
        CGFloat width = 73.3f;
        CGFloat space = 35.f;
        
        for (NSInteger i = 0; i < _picsArray.count; i++)
        {
            NSDictionary *dic = _picsArray[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f + i * (width + space), 0, width, width)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"photo_file"]]];
            [self.imgBackView addSubview:imageView];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
