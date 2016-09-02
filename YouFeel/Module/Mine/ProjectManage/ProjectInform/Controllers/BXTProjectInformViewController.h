//
//  BXTProjectInformViewController.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTBaseViewController.h"
#import "BXTMyProject.h"

@interface BXTProjectInformViewController : BXTBaseViewController

@property (strong, nonatomic) BXTMyProject *transMyProject;
/** ---- 隐藏切换按钮，默认显示 ---- */
@property (nonatomic, assign) BOOL hiddenChangeBtn;

@end
