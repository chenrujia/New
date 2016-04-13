//
//  BXTManListViewController.h
//  YouFeel
//
//  Created by Jason on 16/4/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

typedef NS_ENUM(NSInteger, ControllerType) {
    DetailType,//增员（已经接过单，需要帮手）
    RepairType,//增员（创建新工单时，自己报自己修时，需要增员）
    AssignType//派单
};

@interface BXTManListViewController : BXTBaseViewController<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>

@property (weak, nonatomic) IBOutlet UIView      *contentView;
@property (weak, nonatomic) IBOutlet UIButton    *commitButton;
@property (weak, nonatomic) IBOutlet UITableView *currentTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_width;

@property (nonatomic, strong) NSMutableArray *manIDArray;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                       repairID:(NSString *)orderID
                        manList:(NSArray *)manArray
                 controllerType:(ControllerType)type;

@end
