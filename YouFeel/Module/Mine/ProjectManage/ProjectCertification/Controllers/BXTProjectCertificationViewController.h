//
//  BXTProjectCertificationViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTMyProject.h"
#import "BXTProjectInfo.h"

@interface BXTProjectCertificationViewController : BXTBaseViewController

/** ---- 需要传值 ---- */
@property (strong, nonatomic) BXTMyProject *transMyProject;

/** ---- 从 项目详情 跳入时需要传值 ---- */
@property (strong, nonatomic) BXTProjectInfo *transProjectInfo;

@property (strong, nonatomic) RACSubject *delegateSignal;

@end
