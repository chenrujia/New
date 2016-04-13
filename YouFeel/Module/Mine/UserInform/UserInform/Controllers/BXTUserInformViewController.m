//
//  BXTUserInformViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTUserInformViewController.h"
#import "BXTHeaderFile.h"
#import "BXTSettingTableViewCell.h"
#import "BXTUserInformCell.h"
#import "UIImageView+WebCache.h"
#import "BXTChangeNameViewController.h"
#import "BXTChangePhoneViewController.h"

@interface BXTUserInformViewController () <UITableViewDataSource,UITableViewDelegate, BXTDataResponseDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *detailArray;

@property (copy, nonatomic) NSString *sexStr;

@end

@implementation BXTUserInformViewController

- (void)dealloc
{
    LogBlue(@"设置界面释放了！！！！！！");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"个人信息" andRightTitle:nil andRightImage:nil];
    
    [BXTGlobal shareGlobal].maxPics = 1;
    self.isSettingVC = YES;
    self.selectPhotos = [NSMutableArray array];
    
    [self initContentViews];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ChangeNameSuccess" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        
        NSString *sexStr = [[BXTGlobal getUserProperty:U_SEX] isEqualToString:@"1"] ? @"男" : @"女" ;
        self.detailArray = [[NSMutableArray alloc] initWithObjects:@[@"", [BXTGlobal getUserProperty:U_NAME], sexStr, [BXTGlobal getUserProperty:U_USERNAME]], @[[BXTGlobal getUserProperty:U_USERNAME]], @[@"cccc"], nil];
        [self.tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -
#pragma mark 初始化视图
- (void)initContentViews
{
    self.titleArray = @[@[@"", @"姓   名", @"性   别", @"邮   箱"], @[@"手机号"], @[@"微信号"]];
    NSString *sexStr = [[BXTGlobal getUserProperty:U_SEX] isEqualToString:@"1"] ? @"男" : @"女" ;
    self.detailArray = [[NSMutableArray alloc] initWithObjects:@[@"", [BXTGlobal getUserProperty:U_NAME], sexStr, [BXTGlobal getUserProperty:U_USERNAME]], @[[BXTGlobal getUserProperty:U_USERNAME]], @[@"cccc"], nil];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 100.f;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        if (!cell)
        {
            cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailLable.textAlignment = NSTextAlignmentLeft;
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailLable.hidden = YES;
        cell.checkImgView.hidden = YES;
        CGRect titleRect = cell.titleLabel.frame;
        titleRect.origin.y = 40.f;
        [cell.titleLabel setFrame:titleRect];
        cell.titleLabel.text = @"头像";
        cell.headImageView.hidden = NO;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[BXTGlobal getUserProperty:U_HEADERIMAGE]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        
        return cell;
    }
    
    
    BXTUserInformCell *cell = [BXTUserInformCell cellWithTableView:tableView];
    
    cell.titleView.text = self.titleArray[indexPath.section][indexPath.row];
    cell.detailView.text = self.detailArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTChangeNameViewController *changeName = [[BXTChangeNameViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndResign" bundle:nil];
    BXTChangePhoneViewController *changePhone = [storyboard instantiateViewControllerWithIdentifier:@"BXTChangePhoneViewController"];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: [self addImages]; break;
            case 1: [self.navigationController pushViewController:changeName animated:YES]; break;
            case 2: [self changeSex]; break;
            case 3: break;
            default: break;
        }
    }
    else if (indexPath.section == 1) {
        [self.navigationController pushViewController:changePhone animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)changeSex
{
    [MYAlertAction showActionSheetWithTitle:nil message:nil chooseBlock:^(NSInteger buttonIdx) {
        NSLog(@"---------------- %ld", buttonIdx);
        if (buttonIdx == 1 || buttonIdx == 2) {
            /** 修改用户信息 **/
            BXTDataRequest *dataRequest = [[BXTDataRequest alloc] initWithDelegate:self];
            [dataRequest modifyUserInformWithName:@""
                                           gender:[NSString stringWithFormat:@"%ld", (long)buttonIdx]
                                           mobile:@""];
            self.sexStr = buttonIdx == 1 ? @"男" : @"女";
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@"男", @"女", nil];
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dict = response;
    NSLog(@"response:%@",dict);
    if ([dict[@"returncode"] intValue] == 0 && type == UploadHeadImage)
    {
        [BXTGlobal setUserProperty:dict[@"pic"] withKey:U_HEADERIMAGE];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HEADERIMAGE" object:nil];
        
        [self.tableView reloadData];
    }
    else if ([dict[@"returncode"] intValue] == 0 && type == ModifyUserInform)
    {
        [BXTGlobal setUserProperty:self.sexStr withKey:U_SEX];
        
        [BXTGlobal showText:@"修改信息成功" view:self.view completionBlock:^{
            self.detailArray = [[NSMutableArray alloc] initWithObjects:@[@"", [BXTGlobal getUserProperty:U_NAME], self.sexStr, [BXTGlobal getUserProperty:U_USERNAME]], @[[BXTGlobal getUserProperty:U_USERNAME]], @[@"cccc"], nil];
            
            [self.tableView reloadData];
        }];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    
}

- (void)didReceiveMemoryWarning {
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
