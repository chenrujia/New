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
#import "BXTStandardViewController.h"
#import "BXTChangeStateViewController.h"
#import "SDWebImageManager.h"

@interface BXTMaintenanceViewController ()<BXTDataResponseDelegate>

@end

@implementation BXTMaintenanceViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                      maintence:(BXTMaintenceInfo *)maintence
                       deviceID:(NSString *)devID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.notes = @"";
        self.maintenceInfo = maintence;
        self.deviceID = devID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"维保作业" andRightTitle:nil andRightImage:nil];
    self.currentTableView = self.currentTable;
    for (NSDictionary *imgDic in _maintenceInfo.pic)
    {
        NSString *img_url_str = [imgDic objectForKey:@"photo_thumb_file"];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:img_url_str] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image)
            {
                [self.selectPhotos addObject:image];
                [self.currentTableView reloadData];
            }
        }];
    }
    _commitBtn.layer.cornerRadius = 4.f;
    @weakify(self);
    [[_commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        for (BXTInspectionInfo *inspectionInfo in self.maintenceInfo.inspection_info)
        {
            for (BXTCheckProjectInfo *checkProjectInfo in inspectionInfo.check_arr)
            {
                NSString *key = checkProjectInfo.check_key;
                NSString *value = checkProjectInfo.default_description;
                [dictionary setObject:value forKey:key];
            }
        }
        NSString *jsonStr = [self dataTOjsonString:dictionary];
        [self showLoadingMBP:@"正在上传..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        if (self.isUpdate)
        {
            [request updateInspectionRecordID:self.maintenceInfo.maintenceID
                                     deviceID:self.deviceID
                              andInspectionID:self.maintenceInfo.inspection_item_id
                            andInspectionData:jsonStr
                                     andNotes:self.notes
                                    andImages:self.resultPhotos];
        }
        else
        {
            [request addInspectionRecord:self.maintenceInfo.maintenceID
                                deviceID:self.deviceID
                         andInspectionID:self.maintenceInfo.inspection_item_id
                       andInspectionData:jsonStr
                                andNotes:self.notes
                               andImages:self.resultPhotos];
        }
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
        cell.remarkTV.text = _maintenceInfo.notes;
        self.indexPath = indexPath;
        
        [cell handleImagesFrame:_maintenceInfo.pic];
        
        @weakify(self);
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
        [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            //展示大图
            self.mwPhotosArray = [self containAllPhotos:_maintenceInfo.pic];
            [self loadMWPhotoBrowser:cell.imgViewOne.tag];
        }];
        [cell.imgViewOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
        [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            self.mwPhotosArray = [self containAllPhotos:_maintenceInfo.pic];
            [self loadMWPhotoBrowser:cell.imgViewTwo.tag];
        }];
        [cell.imgViewTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
        [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            self.mwPhotosArray = [self containAllPhotos:_maintenceInfo.pic];
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        BXTChangeStateViewController *changeStateVC = [[BXTChangeStateViewController alloc] initWithNibName:@"BXTChangeStateViewController" bundle:nil withNotes:checkProject.default_description withTitle:inspectionInfo.check_item withDetail:checkProject.check_con];
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
    else if (indexPath.section == 0)
    {
        BXTStandardViewController *standardVC = [[BXTStandardViewController alloc] init];
        [self.navigationController pushViewController:standardVC animated:YES];
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

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        if (type == Add_Inspection)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:nil];
            [self showMBP:@"新建维保作业成功！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else if (type == Update_Inspection)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:nil];
            [self showMBP:@"更新维保作业成功！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
    else if ([[dic objectForKey:@"returncode"] isEqual:@"006"])
    {
        [self showMBP:@"此次作业已经提交，不得重复提交！" withBlock:nil];
    }
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
