//
//  BXTCertificationManageViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"

@interface BXTCertificationManageViewController : BXTBaseViewController

@property (copy, nonatomic) NSString *transID;
@property (strong, nonatomic) RACSubject *delegateSignal;

@end
