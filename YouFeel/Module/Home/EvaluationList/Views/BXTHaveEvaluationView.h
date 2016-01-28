//
//  BXTHaveEvaluationView.h
//  YouFeel
//
//  Created by Jason on 15/10/15.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDataRequest.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BXTHaveEvaluationView : UIView<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
{
    NSMutableArray *datasource;
    UITableView    *currentTable;
}
@end
