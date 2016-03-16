//
//  BXTCommentListViewController.h
//  YouFeel
//
//  Created by Jason on 16/3/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTCommentListViewController : BXTBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *currentTable;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataSource:(NSArray *)array;

@end
