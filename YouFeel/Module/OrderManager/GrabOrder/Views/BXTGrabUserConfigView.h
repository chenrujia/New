//
//  BXTGrabUserConfigView.h
//  YouFeel
//
//  Created by Jason on 16/8/27.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTGrabUserConfigView : UIView

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel     *contentLabel;

- (instancetype)initWithFrame:(CGRect)frame imageSize:(CGSize)size imageName:(NSString *)name;

@end
