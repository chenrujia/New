//
//  BXTMMProcessViewController.h
//  YouFeel
//
//  Created by Jason on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"

@interface BXTMMProcessViewController : BXTPhotoBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                       repairID:(NSString *)repairID
                        placeID:(NSString *)placeID
                      placeName:(NSString *)placeName
                    faultTypeID:(NSString *)faultTypeID
                  faultTypeName:(NSString *)faultTypeName
                     deviceList:(NSArray *)devices;

- (IBAction)doneClick:(id)sender;

@end
