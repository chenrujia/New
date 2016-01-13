//
//  BXTMaintenanceViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"
#import "BXTMaintenceInfo.h"

@interface BXTMaintenanceViewController : BXTPhotoBaseViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) BXTMaintenceInfo *maintenceInfo;
@property (nonatomic, strong) NSString         *notes;
@property (nonatomic, assign) BOOL             isUpdate;//更新还是添加接口

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil maintence:(BXTMaintenceInfo *)mainInfo;

@end
