//
//  BXTEvaluationViewController.h
//  YouFeel
//
//  Created by Jason on 16/4/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPhotoBaseViewController.h"

@interface BXTEvaluationViewController : BXTPhotoBaseViewController

@property (nonatomic ,strong) NSString *repairID;

- (instancetype)initWithRepairID:(NSString *)reID;

/**
 *  其他事物 -- affairID
 */
@property (copy, nonatomic) NSString *affairID;

@end
