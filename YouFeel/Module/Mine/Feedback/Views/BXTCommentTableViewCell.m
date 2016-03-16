//
//  BXTCommentTableViewCell.m
//  YouFeel
//
//  Created by Jason on 16/3/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTCommentTableViewCell.h"
#import "BXTPublicSetting.h"

@implementation BXTCommentTableViewCell

- (void)awakeFromNib
{
    UIImage *image = [UIImage imageNamed:@"ConversationBack"];
    //端盖:用来指定图片中的哪一部分不用拉伸。
    CGFloat top = 15; // 顶端盖高度
    CGFloat bottom = 80 ; // 底端盖高度
    CGFloat left = 15; // 左端盖宽度
    CGFloat right = 15; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *newImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.backImgView.image = newImage;
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 6.f;
    
    self.notes_width.constant = SCREEN_WIDTH*(2.f/3.f) - 15.f - 10.f;
    [self.feebackNotes layoutIfNeeded];
    
    self.bv_width.constant = SCREEN_WIDTH*(2.f/3.f) - 15.f - 10.f;
    [self.qpBackView layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
