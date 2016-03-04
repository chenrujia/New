//
//  BXTMaintenceProjectTableViewCell.h
//  YouFeel
//
//  Created by Jason on 16/1/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTMaintenceProjectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *maintenceProject;
@property (weak, nonatomic) IBOutlet UILabel *nowState;
@property (weak, nonatomic) IBOutlet UILabel *repairNotes;
@property (weak, nonatomic) IBOutlet UILabel *repairResult;
@property (weak, nonatomic) IBOutlet UILabel *workInstuction;

@end
