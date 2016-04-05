//
//  BXTMineViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMineViewController.h"
#import "BXTHeaderFile.h"
#import "BXTMineDownView.h"
#import "BXTSettingTableViewCell.h"
#import "BXTMineCell.h"
#import "BXTFeebackInfo.h"
#import "UIImageView+WebCache.h"
#import "BXTUserInformViewController.h"
#import "BXTProjectManageViewController.h"
#import "BXTFeedbackViewController.h"
#import "BXTSettingViewController.h"
#import "BXTCommentListViewController.h"
#import "BXTAboutUsViewController.h"

@interface BXTMineViewController () <UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *feebackSource;

@property (strong, nonatomic) UIImageView *headImgView;

@end

@implementation BXTMineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTRepairButtonOther" object:nil];
}

- (void)dealloc
{
    LogBlue(@"设置界面释放了！！！！！！");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self navigationSetting:@"我的" andRightTitle:nil andRightImage:nil];
    [self initContentViews];
    
    self.feebackSource = [NSMutableArray array];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RequestFeeback" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self loadDataSoure];
    }];
    [self loadDataSoure];
}

- (void)loadDataSoure
{
    //    [self showLoadingMBP:@"请稍等..."];
    //    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    //    [request feedbackCommentList];
}

#pragma mark -
#pragma mark 初始化视图
- (void)initContentViews
{
    self.iconArray = [[NSArray alloc] initWithObjects:@"mine_personal", @"mine_tools", @"mine_pen", @"mine_cog", @"mine_about_us", nil];
    self.titleArray = [[NSArray alloc] initWithObjects:@"个人信息", @"项目管理", @"意见反馈", @"设置", @"关于我们", nil];
    
    // BXTMineHeaderView
    [self createLogoView];
    
    // currentTableView
    CGFloat height = valueForDevice(236, 215, 193, 193);
    self.currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height - KTABBARHEIGHT) style:UITableViewStyleGrouped];
    self.currentTableView.rowHeight = 50.f;
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    self.currentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.currentTableView];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HEADERIMAGE" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[BXTGlobal getUserProperty:U_HEADERIMAGE]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    }];
}

- (void)createLogoView
{
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, valueForDevice(236, 215, 193, 193))];
    logoView.userInteractionEnabled = YES;
    logoView.backgroundColor = colorWithHexString(@"#5DAFF9");
    [self.view addSubview:logoView];
    
    CGFloat width = valueForDevice(84, 76, 65, 65);
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, valueForDevice(53, 48, 40.8, 40.8), width, width)];
    self.headImgView.center = CGPointMake(SCREEN_WIDTH/2.f, self.headImgView.center.y);
    self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = width/2.f;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[BXTGlobal getUserProperty:U_HEADERIMAGE]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    [logoView addSubview:self.headImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headImgView.frame) + valueForDevice(12, 11, 8, 8), 200.f, 20.f)];
    nameLabel.center = CGPointMake(SCREEN_WIDTH/2.f, nameLabel.center.y);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = colorWithHexString(@"ffffff");
    nameLabel.font = [UIFont boldSystemFontOfSize:IS_IPHONE4 ? 15.f : 17.f];
    nameLabel.text = [BXTGlobal getUserProperty:U_NAME];
    [logoView addSubview:nameLabel];
    
    BXTMineDownView *downView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMineDownView" owner:nil options:nil] lastObject];
    downView.frame = CGRectMake((SCREEN_WIDTH-240)/2, CGRectGetMaxY(nameLabel.frame) + valueForDevice(12, 11, 8, 8), 240, 40);
    [logoView addSubview:downView];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTMineCell *mineCell = [BXTMineCell cellWithTableView:tableView];
    
    mineCell.iconView.image = [UIImage imageNamed:self.iconArray[indexPath.section]];
    mineCell.titleView.text =  self.titleArray[indexPath.section];
    mineCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return mineCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            BXTUserInformViewController *uivc = [[BXTUserInformViewController alloc] init];
            uivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:uivc animated:YES];
            break;
        }
        case 1:
        {
            BXTProjectManageViewController *pivc = [[BXTProjectManageViewController alloc] init];
            pivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pivc animated:YES];
            break;
        }
        case 2:
        {
            if (_feebackSource.count > 0)
            {
                BXTCommentListViewController *fbvc = [[BXTCommentListViewController alloc] initWithNibName:@"BXTCommentListViewController" bundle:nil dataSource:_feebackSource];
                fbvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fbvc animated:YES];
            }
            else
            {
                BXTFeedbackViewController *fbvc = [[BXTFeedbackViewController alloc] init];
                fbvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fbvc animated:YES];
            }
            break;
        }
        case 3:
        {
            BXTSettingViewController *stvc = [[BXTSettingViewController alloc] init];
            stvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stvc animated:YES];
            break;
        }
        case 4:
        {
            BXTAboutUsViewController *auvc = [[BXTAboutUsViewController alloc] init];
            auvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:auvc animated:YES];
            break;
        }
        default: break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    LogRed(@"dic......%@",dic);
    NSArray *data = [dic objectForKey:@"data"];
    [BXTFeebackInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"feebackID":@"id"};
    }];
    [BXTCommentInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"commentID":@"id"};
    }];
    [_feebackSource addObjectsFromArray:[BXTFeebackInfo mj_objectArrayWithKeyValuesArray:data]];
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
