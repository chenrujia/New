//
//  BXTRemarksTableViewCell.m
//  BXT
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRemarksTableViewCell.h"
#import "BXTHeaderFile.h"

@implementation BXTRemarksTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.photosArray = [[NSMutableArray alloc] init];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., 60.f, 30)];
        _titleLabel.textColor = colorWithHexString(@"000000");
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        [self addSubview:_titleLabel];
        
        _remarkTV = [[UITextView alloc] init];
        _remarkTV.font = [UIFont boldSystemFontOfSize:16.];
        _remarkTV.textColor = colorWithHexString(@"909497");
        _remarkTV.text = @"请输入报修内容";
        [self addSubview:_remarkTV];
        
        _imgViewOne = [[UIImageView alloc] init];
        _imgViewOne.userInteractionEnabled = YES;
        _imgViewOne.layer.masksToBounds = YES;
        _imgViewOne.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewOne.tag = 0;
        [self addSubview:_imgViewOne];
        
        _imgViewTwo = [[UIImageView alloc] init];
        _imgViewTwo.userInteractionEnabled = YES;
        _imgViewTwo.layer.masksToBounds = YES;
        _imgViewTwo.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewTwo.tag = 1;
        [self addSubview:_imgViewTwo];
        
        _imgViewThree = [[UIImageView alloc] init];
        _imgViewThree.userInteractionEnabled = YES;
        _imgViewThree.layer.masksToBounds = YES;
        _imgViewThree.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewThree.tag = 2;
        [self addSubview:_imgViewThree];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        _addBtn.layer.borderWidth = 0.5f;
        [_addBtn setImage:[UIImage imageNamed:@"Add_button"] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"Add_button_selected"] forState:UIControlStateHighlighted];
        [self addSubview:_addBtn];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [_remarkTV setFrame:CGRectMake(110.f, 7, SCREEN_WIDTH - 110.f - 10.f, frame.size.height - 14.f - IMAGEWIDTH - 10.f)];
    [_addBtn setFrame:CGRectMake(10.f, frame.size.height - IMAGEWIDTH - 10.f, IMAGEWIDTH, IMAGEWIDTH)];
    if (!_imgViewOne.image)
    {
        [_imgViewOne setFrame:_addBtn.frame];
    }
    if (!_imgViewTwo.image)
    {
        [_imgViewTwo setFrame:_addBtn.frame];
    }
    if (!_imgViewThree.image)
    {
        [_imgViewThree setFrame:_addBtn.frame];
    }
    
    [super setFrame:frame];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
