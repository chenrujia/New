//
//  BXTSearchItemViewController.h
//  YouFeel
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTPlaceInfo.h"
#import "BXTAllDepartmentInfo.h"
#import "BXTSelectItemView.h"

@interface BXTSearchItemViewController : BXTBaseViewController<UISearchBarDelegate>

@property (weak, nonatomic  ) IBOutlet UISwitch    *autoSwitch;
@property (weak, nonatomic  ) IBOutlet UIButton    *commitBtn;
@property (weak, nonatomic  ) IBOutlet UISearchBar *searchBarView;
@property (nonatomic, copy  ) NSString             *faultTypeID;
@property (nonatomic, assign) SearchVCType         searchType;
@property (nonatomic, copy  ) ChooseItem           selectItemBlock;
//判断是否是从维修过程过来的
@property (nonatomic, assign) BOOL                 isProgress;

- (void)userChoosePlace:(NSArray *)array isProgress:(BOOL)progress type:(SearchVCType)type block:(ChooseItem)itemBlock;
- (IBAction)commitClick:(id)sender;
- (IBAction)switchValueChanged:(id)sender;

@end
