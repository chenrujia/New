//
//  BXTMenViewController.h
//  YouFeel
//
//  Created by Jason on 16/4/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTMenViewController : BXTBaseViewController<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>

@property (nonatomic, strong) NSMutableArray *manIDArray;

@property (weak, nonatomic) IBOutlet UILabel *choosedLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UITableView *currentTableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil repairID:(NSString *)orderID repairUserList:(NSArray *)repairUserArray dispatchUserList:(NSArray *)dispatchUserArray;

- (IBAction)commitClick:(id)sender;

@end
