//
//  BXTProjectCertificationViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTMyProject.h"

@interface BXTProjectCertificationViewController : BXTBaseViewController

/** ---- 需要传值 ---- */
@property (strong, nonatomic) BXTMyProject *transMyProject;

@property (strong, nonatomic) RACSubject *delegateSignal;

@end
