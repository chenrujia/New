//
//  BXTMaintenanceViewController.h
//  YouFeel
//
//  Created by Jason on 16/1/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"
#import "BXTDeviceMaintenceInfo.h"

@interface BXTMaintenanceViewController : BXTPhotoBaseViewController  <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) BXTDeviceMaintenceInfo *maintenceInfo;
@property (nonatomic, strong) NSString         *notes;
@property (nonatomic, strong) NSString         *instruction;//状态说明
@property (nonatomic, assign) BOOL             isUpdate;//更新还是添加接口
@property (nonatomic, strong) NSString         *deviceID;
@property (nonatomic, strong) NSString         *state;
@property (nonatomic, strong) NSString         *name;
@property (nonatomic, strong) NSArray          *deviceStates;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                      maintence:(BXTDeviceMaintenceInfo *)maintence
                       deviceID:(NSString *)devID
                deviceStateList:(NSArray *)states
               safetyGuidelines:(NSString *)safety;

@end
