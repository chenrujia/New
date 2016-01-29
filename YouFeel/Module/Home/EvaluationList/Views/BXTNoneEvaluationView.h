//
//  BXTNoneEvaluationView.h
//  YouFeel
//
//  Created by Jason on 15/10/15.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTDataRequest.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BXTNoneEvaluationView : UIView<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    UITableView    *currentTable;
}

@property (nonatomic, strong) NSMutableArray *datasource;

@end
