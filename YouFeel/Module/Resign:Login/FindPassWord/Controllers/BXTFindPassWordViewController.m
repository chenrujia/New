//
//  BXTFindPassWordViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTFindPassWordViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTResignTableViewCell.h"
#import "BXTChangePassWordViewController.h"

@interface BXTFindPassWordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BXTDataResponseDelegate>

@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (nonatomic ,strong) NSString *userName;
@property (nonatomic ,strong) NSString *codeNumber;
@property (nonatomic ,strong) UIButton *codeBtn;

@end

@implementation BXTFindPassWordViewController

- (void)dealloc
{
    NSLog(@"找回密码界面释放了！！！！！！");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"找回密码" andRightTitle:nil andRightImage:nil];
    [_currentTable registerNib:[UINib nibWithNibName:@"BXTResignTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    _currentTable.rowHeight = 50.f;
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;//section头部高度
    }
    return 10.f;//section头部高度
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16.f)];
    }
    else
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    }
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 80.f;
    }
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *nextTapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextTapBtn.frame = CGRectMake(20, 30, SCREEN_WIDTH - 40, 50.f);
        [nextTapBtn setTitle:@"提交" forState:UIControlStateNormal];
        nextTapBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [nextTapBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [nextTapBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        nextTapBtn.layer.masksToBounds = YES;
        nextTapBtn.layer.cornerRadius = 4.f;
        @weakify(self);
        [[nextTapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([BXTGlobal validateMobile:self.userName])
            {
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request findPassWordWithMobile:self.userName andWithCode:self.codeNumber];
            }
            else
            {
                [BXTGlobal showText:@"手机号格式不对" completionBlock:nil];
            }
        }];
        [view addSubview:nextTapBtn];
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTResignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0)
    {
        cell.nameLabel.text = @"手机号";
        cell.textField.placeholder = @"请输入有效的手机号码";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        @weakify(self);
        [cell.textField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            self.userName = x;
        }];
        cell.codeButton.hidden = YES;
    }
    else
    {
        cell.nameLabel.text = @"验证码";
        cell.textField.placeholder = @"请输入短信验证码";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        @weakify(self);
        [cell.textField.rac_textSignal subscribeNext:^(NSString *text) {
            @strongify(self);
            self.codeNumber = text;
        }];
        cell.codeButton.hidden = NO;
        self.codeBtn = cell.codeButton;
        [[cell.codeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if ([BXTGlobal validateMobile:self.userName])
            {
                BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
                [request mobileVerCode:self.userName type:@"2"];
                self.codeBtn.userInteractionEnabled = NO;
                [self.codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            else
            {
                if ([BXTGlobal isBlankString:self.userName]) {
                    [BXTGlobal showText:@"手机号不能为空" completionBlock:nil];
                }
                else {
                    [BXTGlobal showText:@"手机号格式错误" completionBlock:nil];
                }
            }
        }];
    }
    
    cell.boyBtn.hidden = YES;
    cell.girlBtn.hidden = YES;
    cell.textField.delegate = self;
    
    return cell;
}

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    
    if (type == FindPassword)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            NSArray *data = [dic objectForKey:@"data"];
            NSDictionary *dictionary = data[0];
            [BXTGlobal setUserProperty:self.userName withKey:U_USERNAME];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
            BXTChangePassWordViewController *changePassWordVC = (BXTChangePassWordViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTChangePassWordViewController"];
            [changePassWordVC dataWithUserID:[dictionary objectForKey:@"id"] withKey:[dictionary objectForKey:@"key"]];
            [self.navigationController pushViewController:changePassWordVC animated:YES];
        }
        else
        {
            [BXTGlobal showText:@"验证码输入有误！" completionBlock:nil];
        }
    }
    else if (type == GetVerificationCode)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [self updateTime];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"026"])
        {
            @weakify(self);
            [BXTGlobal showText:@"手机号还未注册" completionBlock:^{
                @strongify(self);
                self.codeBtn.userInteractionEnabled = YES;
                [self.codeBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            }];
        }
    }
}

- (void)updateTime
{
    __block NSInteger count = 60;
    @weakify(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 3), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_time, ^{
        @strongify(self);
        count--;
        if (count <= 0)
        {
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.codeBtn.userInteractionEnabled = YES;
                [self.codeBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取 %ld",(long)count] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(_time);
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    
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
