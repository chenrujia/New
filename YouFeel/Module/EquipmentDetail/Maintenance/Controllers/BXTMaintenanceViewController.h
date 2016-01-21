//
//  BXTMaintenanceViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDetailBaseViewController.h"
#import "BXTMaintenceInfo.h"

@interface BXTMaintenanceViewController : BXTDetailBaseViewController  <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) BXTMaintenceInfo *maintenceInfo;
@property (nonatomic, strong) NSString         *notes;
@property (nonatomic, assign) BOOL             isUpdate;//更新还是添加接口
@property (nonatomic, strong) NSString         *deviceID;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                      maintence:(BXTMaintenceInfo *)maintence
                       deviceID:(NSString *)devID;

@end
