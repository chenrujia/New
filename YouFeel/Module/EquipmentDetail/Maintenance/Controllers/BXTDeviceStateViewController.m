//
//  BXTDeviceStateViewController.m
//  YouFeel
//
//  Created by Jason on 16/3/3.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDeviceStateViewController.h"
#import "BXTSettingTableViewCell.h"
#import "BXTInfoNotesTableViewCell.h"

@interface BXTDeviceStateViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    NSMutableArray    *markArray;
}

@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) NSArray     *datasource;
@property (nonatomic, strong) NSString    *name;
@property (nonatomic, strong) NSString    *state;
@property (nonatomic, strong) NSString    *notes;

@end

@implementation BXTDeviceStateViewController

- (instancetype)initWithArray:(NSArray *)array deviceState:(NSString *)state stateBlock:(ChangeDeviceState)block
{
    self = [super init];
    if (self)
    {
        self.datasource = array;
        self.state = state;
        self.cdStateBlock = block;
        self.notes = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"设备当前状态" andRightTitle:nil andRightImage:nil];
    
    markArray = [NSMutableArray array];
    if (self.datasource.count > 0)
    {
        for (NSInteger i = 0; i < self.datasource.count; i++)
        {
            NSDictionary *dic = self.datasource[i];
            if ([[dic objectForKey:@"id"] isEqualToString:self.state])
            {
                [markArray addObject:@"1"];
            }
            else
            {
                [markArray addObject:@"0"];
            }
        }
    }
    
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [_currentTableView registerClass:[BXTSettingTableViewCell class] forCellReuseIdentifier:@"DeviceStateCell"];
    _currentTableView.delegate = self;
    _currentTableView.dataSource = self;
    _currentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_currentTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.5f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
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
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40.f, 50.f);
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [doneBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        doneBtn.layer.masksToBounds = YES;
        doneBtn.layer.cornerRadius = 4.f;
        @weakify(self);
        [[doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.cdStateBlock(self.name,self.state,self.notes);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [view addSubview:doneBtn];
        
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return 92.f;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 1;
    }
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        if (!cell)
        {
            cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        NSDictionary *stateInfo = self.datasource[indexPath.row];
        cell.titleLabel.text = stateInfo[@"state"];
        if ([markArray[indexPath.row] integerValue])
        {
            cell.checkImgView.hidden = NO;
        }
        else
        {
            cell.checkImgView.hidden = YES;
        }
        cell.detailLable.hidden = YES;
        
        return cell;
    }
    else
    {
        BXTInfoNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoNotesCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"BXTInfoNotesTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoNotesCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"InfoNotesCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.notesTV.delegate = self;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = [markArray indexOfObject:@"1"];
    [markArray replaceObjectAtIndex:index withObject:@"0"];
    NSDictionary *dic = self.datasource[indexPath.row];
    self.name = [dic objectForKey:@"state"];
    self.state = [dic objectForKey:@"id"];
    [markArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [_currentTableView reloadData];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.notes = textView.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
