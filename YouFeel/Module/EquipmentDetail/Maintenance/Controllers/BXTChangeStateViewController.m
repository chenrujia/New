//
//  BXTChangeStateViewController.m
//  YouFeel
//
//  Created by Jason on 16/1/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTChangeStateViewController.h"

@interface BXTChangeStateViewController ()

@end

@implementation BXTChangeStateViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                      withNotes:(NSString *)notes
                      withTitle:(NSString *)title
                     withDetail:(NSString *)detail
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.notes = notes;
        self.titleText = title;
        self.detailText = detail;
    }
    return self;
}

- (void)valueChanged:(ChangeText)block
{
    self.changeText = block;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"现状" andRightTitle:nil andRightImage:nil];
    _commitBtn.layer.cornerRadius = 6.f;
    self.textview.text = self.notes;
    self.titleLabel.text = _titleText;
    self.detailLabel.text = _detailText;
    [self.detailLabel layoutIfNeeded];
    
    @weakify(self);
    [self.textview.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        self.notes = x;
    }];
   
    [[_commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.changeText(self.notes);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
