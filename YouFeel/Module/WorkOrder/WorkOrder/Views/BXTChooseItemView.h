//
//  BXTChooseItemView.h
//  YouFeel
//
//  Created by Jason on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChooseViewType) {
    DeviceListType,
    DatePickerType
};

@interface BXTChooseItemView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) ChooseViewType viewType;
@property (nonatomic, strong) UITableView *currentTable;

- (instancetype)initWithFrame:(CGRect)frame type:(ChooseViewType)cvType array:(NSArray *)array;

@end
