//
//  BXTNoneEvaluationView.h
//  YouFeel
//
//  Created by Jason on 15/10/15.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDataRequest.h"

@interface BXTNoneEvaluationView : UIView<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>
{
    NSMutableArray *datasource;
    UITableView *currentTable;
}
@end
