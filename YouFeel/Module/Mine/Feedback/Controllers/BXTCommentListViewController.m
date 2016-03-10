//
//  BXTCommentListViewController.m
//  YouFeel
//
//  Created by Jason on 16/3/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTCommentListViewController.h"
#import "BXTCommentTableViewCell.h"
#import "BXTFeebackInfo.h"
#import "BXTFeedbackViewController.h"


@interface BXTCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *commentArray;

@end

@implementation BXTCommentListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataSource:(NSArray *)array
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.commentArray = array;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"意见反馈" andRightTitle:nil andRightImage:nil];
    self.currentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.currentTable setBackgroundColor:colorWithHexString(@"eff3f6")];
    [self.currentTable registerNib:[UINib nibWithNibName:@"BXTCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _commentArray.count - 1)
    {
        return 80.f;
    }
    
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == _commentArray.count - 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40.f, 50.f);
        [doneBtn setTitle:@"继续反馈" forState:UIControlStateNormal];
        [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        doneBtn.layer.masksToBounds = YES;
        doneBtn.layer.cornerRadius = 4.f;
        @weakify(self);
        [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            BXTFeedbackViewController *fbvc = [[BXTFeedbackViewController alloc] init];
            [self.navigationController pushViewController:fbvc animated:YES];
        }];
        [view addSubview:doneBtn];
        
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTFeebackInfo *feebackInfo = _commentArray[indexPath.section];
    
    UIFont *font = [UIFont systemFontOfSize:17.f];
    CGFloat f_width = SCREEN_WIDTH*(2.f/3.f) - 15.f - 10.f;
    CGFloat c_width = SCREEN_WIDTH*(2.f/3.f) - 15.f - 10.f - 20.f;
    if (feebackInfo.sub_comment_list.count > 0)
    {
        CGSize f_size = MB_MULTILINE_TEXTSIZE(feebackInfo.content, font, CGSizeMake(f_width, 1000), NSLineBreakByWordWrapping);
        BXTCommentInfo *commentInfo = feebackInfo.sub_comment_list[0];
        CGSize c_size = MB_MULTILINE_TEXTSIZE(commentInfo.content, font, CGSizeMake(c_width, 1000), NSLineBreakByWordWrapping);
        return 30.f + f_size.height + 18.f + c_size.height + 46.f;
    }
    else
    {
        CGSize f_size = MB_MULTILINE_TEXTSIZE(feebackInfo.content, font, CGSizeMake(f_width, 1000), NSLineBreakByWordWrapping);
        return 30.f + f_size.height + 10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _commentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.backgroundColor = colorWithHexString(@"eff3f6");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BXTFeebackInfo *feebackInfo = _commentArray[indexPath.section];
    cell.feebackTime.text = feebackInfo.upload_data;
    cell.feebackNotes.text = feebackInfo.content;
    
    if (feebackInfo.sub_comment_list.count > 0)
    {
        cell.qpBackView.hidden = NO;
        BXTCommentInfo *commentInfo = feebackInfo.sub_comment_list[0];
        cell.commentNotes.text = commentInfo.content;
        cell.commentTime.text = commentInfo.upload_data;
        UIFont *font = [UIFont systemFontOfSize:17.f];
        CGFloat width = SCREEN_WIDTH*(2.f/3.f) - 15.f - 10.f - 20.f;
        CGSize c_size = MB_MULTILINE_TEXTSIZE(commentInfo.content, font, CGSizeMake(width, 1000), NSLineBreakByWordWrapping);
        cell.bv_height.constant = c_size.height + 40.f;
        [cell.qpBackView layoutIfNeeded];
    }
    else
    {
        cell.qpBackView.hidden = YES;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
