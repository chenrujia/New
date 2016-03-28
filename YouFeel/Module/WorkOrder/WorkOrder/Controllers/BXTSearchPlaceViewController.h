//
//  BXTSearchPlaceViewController.h
//  YouFeel
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTPlace.h"

typedef void (^ChoosePlace)(BXTPlace *placeInfo);

@interface BXTSearchPlaceViewController : BXTBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (nonatomic, copy) ChoosePlace selectPlace;

- (void)userChoosePlaceInfo:(ChoosePlace)place;

- (IBAction)commitClick:(id)sender;
- (IBAction)switchValueChanged:(id)sender;

@end
