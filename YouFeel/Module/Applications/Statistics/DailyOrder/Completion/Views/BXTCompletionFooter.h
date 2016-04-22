//
//  CompletionFooter.h
//  YouFeel
//
//  Created by 满孝意 on 15/12/1.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXTCompletionFooter : UIView

@property (weak, nonatomic) IBOutlet UILabel *pointView;
@property (weak, nonatomic) IBOutlet UILabel *pointView1;
@property (weak, nonatomic) IBOutlet UILabel *pointView2;

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *sumView;
@property (weak, nonatomic) IBOutlet UILabel *goodJobView;
@property (weak, nonatomic) IBOutlet UILabel *badJobView;
@property (weak, nonatomic) IBOutlet UILabel *unCompleteView;

@end
