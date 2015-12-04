//
//  WorkloadCell.h
//  YouFeel
//
//  Created by 满孝意 on 15/12/2.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTWorkloadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *downView;
@property (weak, nonatomic) IBOutlet UILabel *specialView;
@property (weak, nonatomic) IBOutlet UILabel *undownView;

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;

@end
