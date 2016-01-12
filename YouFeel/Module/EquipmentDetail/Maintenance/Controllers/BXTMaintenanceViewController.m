//
//  BXTMaintenanceViewController.m
//  YouFeel
//
//  Created by Jason on 16/1/11.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenanceViewController.h"
#import "BXTRemarksTableViewCell.h"
#import "BXTSettingTableViewCell.h"
#import "BXTInspectionInfo.h"
#import <objc/runtime.h>
#import "BXTCheckProjectInfo.h"
#import "BXTHeaderForVC.h"
#import "BXTChangeStateViewController.h"

@interface BXTMaintenanceViewController ()<BXTDataResponseDelegate>

@end

@implementation BXTMaintenanceViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil maintence:(BXTMaintenceInfo *)mainInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.notes = @"";
        self.maintenceInfo = mainInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维保作业" andRightTitle:nil andRightImage:nil];
    _commitBtn.layer.cornerRadius = 6.f;
    @weakify(self);
    [[_commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (BXTInspectionInfo *inspectionInfo in self.maintenceInfo.inspection_info)
        {
            for (BXTCheckProjectInfo *checkProjectInfo in inspectionInfo.check_arr)
            {
                NSString *key = checkProjectInfo.check_key;
                NSString *value = checkProjectInfo.default_description;
                NSDictionary *dic = @{key:value};
                [dataArray addObject:dic];
            }
        }
        [self showLoadingMBP:@"正在上传..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request addInspectionRecord:self.maintenceInfo.maintenceID andInspectionID:self.maintenceInfo.inspection_item_id andInspectionData:dataArray andNotes:self.notes andImages:self.photosArray];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == _maintenceInfo.inspection_info.count + 1)
    {
        return 0.1f;
    }
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == _maintenceInfo.inspection_info.count + 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.f)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15., 10., 100.f, 30)];
    titleLabel.textColor = colorWithHexString(@"000000");
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    BXTInspectionInfo *inspectionInfo = _maintenceInfo.inspection_info[section - 1];
    titleLabel.text = inspectionInfo.check_item;
    [view addSubview:titleLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 + _maintenceInfo.inspection_info.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == _maintenceInfo.inspection_info.count + 1)
    {
        return 1;
    }
    BXTInspectionInfo *inspection = _maintenceInfo.inspection_info[section - 1];
    return inspection.check_arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _maintenceInfo.inspection_info.count + 1)
    {
        return 170;
    }
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _maintenceInfo.inspection_info.count + 1)
    {
        BXTRemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTenanceCell"];
        if (!cell)
        {
            cell = [[BXTRemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainTenanceCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.remarkTV.delegate = self;
        cell.titleLabel.text = @"备   注";
        
        @weakify(self);
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
        [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:cell.imgViewOne.tag];
        }];
        [cell.imgViewOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
        [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:cell.imgViewTwo.tag];
        }];
        [cell.imgViewTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
        [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMWPhotoBrowser:cell.imgViewThree.tag];
        }];
        [cell.imgViewThree addGestureRecognizer:tapGRThree];
        
        [cell.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTenanceCell"];
        if (!cell)
        {
            cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainTenanceCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailLable.textAlignment = NSTextAlignmentRight;
        }
        if (indexPath.section == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.frame = CGRectMake(15.f, 15.f, 120.f, 20);
            cell.titleLabel.text = @"设备操作规范";
        }
        else
        {
            cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
            BXTInspectionInfo *inspection = _maintenceInfo.inspection_info[indexPath.section - 1];
            BXTCheckProjectInfo *checkProject = inspection.check_arr[indexPath.row];
            cell.titleLabel.frame = CGRectMake(15.f, 15.f, 120.f, 20);
            cell.titleLabel.text = checkProject.check_con;
            cell.detailLable.text = checkProject.default_description;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0 && indexPath.section != _maintenceInfo.inspection_info.count + 1)
    {
        BXTInspectionInfo *inspectionInfo = _maintenceInfo.inspection_info[indexPath.section - 1];
        BXTCheckProjectInfo *checkProject = inspectionInfo.check_arr[indexPath.row];
        BXTChangeStateViewController *changeStateVC = [[BXTChangeStateViewController alloc] initWithNibName:@"BXTChangeStateViewController" bundle:nil withTitle:inspectionInfo.check_item withDetail:checkProject.check_con];
        @weakify(self);
        [changeStateVC valueChanged:^(NSString *text) {
            @strongify(self);
            
            checkProject.default_description = text;
            NSMutableArray *tempIns = [NSMutableArray arrayWithArray:inspectionInfo.check_arr];
            [tempIns replaceObjectAtIndex:indexPath.row withObject:checkProject];
            inspectionInfo.check_arr = tempIns;
            NSMutableArray *tempInsInfos = [NSMutableArray arrayWithArray:self.maintenceInfo.inspection_info];
            [tempInsInfos replaceObjectAtIndex:indexPath.section - 1 withObject:inspectionInfo];
            self.maintenceInfo.inspection_info = tempInsInfos;
            
            [self.currentTable reloadData];
        }];
        [self.navigationController pushViewController:changeStateVC animated:YES];
    }
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入报修内容"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.notes = textView.text;
    if (textView.text.length < 1)
    {
        textView.text = @"请输入报修内容";
    }
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    LogBlue(@"dic.....%@",dic);
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
