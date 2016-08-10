//
//  BXTMeterReadingListView.h
//  YouFeel
//
//  Created by Jason on 16/7/6.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMeterReadingListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSArray        *energyFilterArray;
@property (nonatomic, copy  ) NSString       *energyType;
@property (nonatomic, copy  ) NSString       *checkType;
@property (nonatomic, copy  ) NSString       *priceType;
@property (nonatomic, copy  ) NSString       *placeID;
@property (nonatomic, copy  ) NSString       *filterCondition;
@property (nonatomic, copy  ) NSString       *searchName;
@property (nonatomic, assign) NSInteger      currentPage;

- (instancetype)initWithFrame:(CGRect)frame
                   energyType:(NSString *)energy_type
                    checkType:(NSString *)check_type
                    priceType:(NSString *)price_type
              filterCondition:(NSString *)filter_condition
                   searchName:(NSString *)search_name;

- (void)changeCheckType:(NSString *)checkType;
- (void)changePriceType:(NSString *)priceType;
- (void)changePlaceID:(NSString *)placeID;
- (void)changeFilterCondition:(NSString *)filterCondition;
- (void)requestDatasource;

@end
