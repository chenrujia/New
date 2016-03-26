//
//  BXTSearchPlaceViewController.h
//  YouFeel
//
//  Created by Jason on 16/3/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTSearchPlaceViewController : BXTBaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITableView *currentTable;

- (IBAction)commitClick:(id)sender;

@end
