//
//  BXTMeterReadingListView.h
//  YouFeel
//
//  Created by Jason on 16/7/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMeterReadingListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *datasource;

- (instancetype)initWithFrame:(CGRect)frame datasource:(NSArray *)datasource;

@end
