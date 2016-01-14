//
//  BXTMaintenanceBookViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/12.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDetailBaseViewController.h"

@interface BXTMaintenanceBookViewController : BXTDetailBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (nonatomic, strong) NSString *deviceID;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil deviceID:(NSString *)devID;

@end
