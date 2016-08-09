//
//  BXTEnergyClassificationViewController.m
//  YouFeel
//
//  Created by Jason on 16/7/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyClassificationViewController.h"
#import "BXTHeaderFile.h"
#import "BXTMenuItemButton.h"
#import "UIImage+SubImage.h"
#import "BXTCustomButton.h"
#import "BXTSelectItemView.h"
#import "ANKeyValueTable.h"
#import "BXTMeterReadingListView.h"
#import "BXTEnergyMeterListInfo.h"
#import "BXTEnergyReadingSearchViewController.h"
#import "BXTEnergyReadingFilterInfo.h"
#import "BXTQRCodeViewController.h"

#define KBUTTONHEIGHT 46
#define METERTABLETAG 666
#define PRICETABLETAG 888

@interface BXTEnergyClassificationViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    BXTMenuItemButton *electricBtn;//电
    BXTMenuItemButton *waterBtn;//水
    BXTMenuItemButton *gasBtn;//燃气
    BXTMenuItemButton *heatBtn;//热能
    BXTMeterReadingListView *electricView;
    BXTMeterReadingListView *waterView;
    BXTMeterReadingListView *gasView;
    BXTMeterReadingListView *heatView;
    UIView *leftWhiteView;//左侧白色小方形块
    UIView *rightWhiteView;//右侧白色小方形块
    NSInteger currentPage;
}

@property (nonatomic, strong) NSArray           *colorArray;
//抄表方式数据
@property (nonatomic, strong) NSMutableArray    *meterArray;
//价格类型数据
@property (nonatomic, strong) NSMutableArray    *priceArray;
@property (nonatomic, strong) BXTSelectItemView *placeItemView;
@property (nonatomic, strong) BXTSelectItemView *filterItemView;
@property (nonatomic, strong) UITableView       *chooseTableView;
@property (nonatomic, strong) UIScrollView      *scrollerView;
/** ---- 1电、2水、3燃气、4热能 ---- */
@property (nonatomic, assign) NSInteger         btnTag;
@property (nonatomic, copy  ) NSString          *checkType;
@property (nonatomic, copy  ) NSString          *priceType;
@property (nonatomic, copy  ) NSString          *placeID;
//筛选条件
@property (nonatomic, copy  ) NSString          *filterCondition;
@property (nonatomic, assign) BOOL              isFilter;

@end

@implementation BXTEnergyClassificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"能源抄表" backColor:colorWithHexString(@"f45b5b") rightImage:[UIImage imageNamed:@"scan_energy"]];
    SaveValueTUD(EnergyReadingColorStr, @"#f45b5b");
    
    self.checkType = @"";
    self.priceType = @"";
    self.placeID = @"";
    self.filterCondition = @"";
    self.meterArray = [[NSMutableArray alloc] initWithObjects:@"默认",@"手动抄表",@"自动抄表", nil];
    self.priceArray = [[NSMutableArray alloc] initWithObjects:@"默认",@"单一",@"峰谷",@"阶梯", nil];
    
    [self initialEnergyClass];
    [self initialSearchBarAndFilter];
}

- (void)navigationRightButton
{
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc] init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    BXTQRCodeViewController *qrcVC = [[BXTQRCodeViewController alloc] init];
    qrcVC.style = style;
    qrcVC.isQQSimulator = YES;
    qrcVC.hidesBottomBarWhenPushed = YES;
    qrcVC.pushType = ReturnVCTypeOFMeterReading;
    [self.navigationController pushViewController:qrcVC animated:YES];
}

#pragma mark -
#pragma mark 初始化电能、水、燃气、热能
- (void)initialEnergyClass
{
    self.colorArray = @[colorWithHexString(@"f45b5b"),colorWithHexString(@"1683e2"),colorWithHexString(@"f5c809"),colorWithHexString(@"f1983e")];
    self.view.backgroundColor = self.colorArray[0];
    
    CGFloat width = (SCREEN_WIDTH - 20.f)/4.f;
    
    electricBtn = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawMiddle backgroudColor:self.colorArray[0]];
    electricBtn.tag = 0;
    [electricBtn setTitle:@"电能" forState:UIControlStateNormal];
    [electricBtn setTitleColor:self.colorArray[0] forState:UIControlStateNormal];
    [electricBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:electricBtn];
    
    waterBtn = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f + width, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawLeft backgroudColor:[UIColor whiteColor]];
    waterBtn.drawColor = self.colorArray[0];
    waterBtn.tag = 1;
    [waterBtn setTitle:@"水" forState:UIControlStateNormal];
    [waterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [waterBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:waterBtn];
    
    gasBtn = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f + 2.f * width, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawNot backgroudColor:self.colorArray[0]];
    gasBtn.tag = 2;
    [gasBtn setTitle:@"燃气" forState:UIControlStateNormal];
    [gasBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gasBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gasBtn];
    
    heatBtn = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f + 3.f * width, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawNot backgroudColor:self.colorArray[0]];
    heatBtn.tag = 3;
    [heatBtn setTitle:@"热能" forState:UIControlStateNormal];
    [heatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [heatBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:heatBtn];
    
    leftWhiteView = [[UIView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(electricBtn.frame), 10.f, 10.f)];
    leftWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftWhiteView];
}

//大白色背景、搜索框、筛选条件按钮
- (void)initialSearchBarAndFilter
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(electricBtn.frame), SCREEN_WIDTH - 20.f, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - KBUTTONHEIGHT - 10.f)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 10.f;
    [self.view addSubview:backView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 6.f, CGRectGetWidth(backView.frame), 44.f)];
    searchBar.placeholder = @"搜索";
    searchBar.layer.masksToBounds = YES;
    searchBar.layer.cornerRadius = 27.f;
    UIImage *searchBarBg = [UIImage imageWithColor:[UIColor whiteColor] andHeight:46.0f];
    UIImage *fontBg = [UIImage imageWithColor:colorWithHexString(@"DCDCDC") andHeight:32.f];
    //设置背景图片
    [searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    //设置文本框背景
    [searchBar setSearchFieldBackgroundImage:fontBg forState:UIControlStateNormal];
    [backView addSubview:searchBar];
    // searchBtn
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:searchBar.frame];
    @weakify(self);
    [[searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTEnergyReadingSearchViewController *erqsvc = [[BXTEnergyReadingSearchViewController alloc] initWithSearchPushType:self.btnTag + 1];
        [self.navigationController pushViewController:erqsvc animated:YES];
    }];
    [searchBar addSubview:searchBtn];
    
    NSArray *titles = @[@"抄表方式",@"价格类型",@"安装位置",@"智能筛选"];
    NSArray *images = @[@"select_triangle",@"select_triangle",@"select_triangle",@"meterFilter"];
    for (NSInteger i = 0; i < 4; i++)
    {
        BXTCustomButton *meterTypeBtn = [[BXTCustomButton alloc] initWithType:EnergyBtnType];
        meterTypeBtn.tag = i;
        meterTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (IS_IPHONE6P)
        {
            meterTypeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        }
        else if (IS_IPHONE6)
        {
            meterTypeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        }
        else
        {
            meterTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        }
        [meterTypeBtn setFrame:CGRectMake(i * (CGRectGetWidth(backView.frame)/4.f), CGRectGetMaxY(searchBar.frame), CGRectGetWidth(backView.frame)/4.f, 44.f)];
        [meterTypeBtn setTitle:titles[i] forState:UIControlStateNormal];
        [meterTypeBtn setTitleColor:colorWithHexString(@"#6E6E6E") forState:UIControlStateNormal];
        [meterTypeBtn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [meterTypeBtn addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:meterTypeBtn];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame) + 44.f, CGRectGetWidth(backView.frame), 0.7f)];
    lineView.backgroundColor = colorWithHexString(@"e2e6e8");
    [backView addSubview:lineView];
    
    self.scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(lineView.frame), CGRectGetWidth(backView.frame), CGRectGetHeight(backView.frame) - CGRectGetMaxY(lineView.frame))];
    self.scrollerView.contentSize = CGSizeMake(4 * CGRectGetWidth(backView.frame), 0);
    self.scrollerView.bounces = NO;
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.delegate = self;
    [backView addSubview:self.scrollerView];
    
    for (NSInteger i = 0; i < 4; i++)
    {
        NSString *energyType = [NSString stringWithFormat:@"%ld",(long)(i + 1)];
        BXTMeterReadingListView *meterView = [[BXTMeterReadingListView alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(self.scrollerView.frame), 0, CGRectGetWidth(self.scrollerView.frame), CGRectGetHeight(self.scrollerView.frame)) energyType:energyType checkType:self.checkType priceType:self.priceType filterCondition:self.filterCondition searchName:@""];
        if (i == 0)
        {
            electricView = meterView;
        }
        else if (i == 1)
        {
            waterView = meterView;
        }
        else if (i == 2)
        {
            gasView = meterView;
        }
        else
        {
            heatView = meterView;
        }
        [self.scrollerView addSubview:meterView];
    }
    
    rightWhiteView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20.f, CGRectGetMaxY(electricBtn.frame), 10.f, 10.f)];
    rightWhiteView.backgroundColor = [UIColor whiteColor];
    rightWhiteView.hidden = YES;
    [self.view addSubview:rightWhiteView];
}

- (void)initialTableView:(NSInteger)tag
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    self.chooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT + KBUTTONHEIGHT + 93.f, SCREEN_WIDTH - 20.f, 0.f) style:UITableViewStylePlain];
    [self.chooseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EnergyCell"];
    self.chooseTableView.tag = tag;
    self.chooseTableView.delegate = self;
    self.chooseTableView.dataSource = self;
    [self.view addSubview:self.chooseTableView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.chooseTableView setFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT + KBUTTONHEIGHT + 90.f, SCREEN_WIDTH - 20.f, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - KBUTTONHEIGHT - 100.f)];
    }];
}

- (void)initialPlaceOrFilter:(NSArray *)datasource isFilter:(BOOL)isFilter
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    self.isFilter = isFilter;
    
    CGRect viewRect = CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT);
    CGRect tableRect =  CGRectMake(0, 20, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT - 20.f - 64.f);
    
    __weak __typeof(self) weakSelf = self;
    if (isFilter)
    {
        if (!self.filterItemView)
        {
            self.filterItemView = [[BXTSelectItemView alloc] initWithFrame:viewRect tableViewFrame:tableRect datasource:datasource isProgress:NO type:FilterSearchType defaultSelected:self.filterCondition block:^(BXTBaseClassifyInfo *classifyInfo, NSString *name) {
                if (classifyInfo)
                {
                    self.filterCondition = classifyInfo.itemID;
                }
                else
                {
                    self.filterCondition = @"";
                }
                BXTMeterReadingListView *meterListView = [self currentMeterListView];
                [meterListView changeFilterCondition:self.filterCondition];

                UIView *view = [weakSelf.view viewWithTag:101];
                [UIView animateWithDuration:0.3f animations:^{
                    [weakSelf.filterItemView setFrame:CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                }];
            }];
            self.filterItemView.backgroundColor = colorWithHexString(@"eff3f6");
            [self.view addSubview:self.filterItemView];
        }
        else
        {
            [self.view bringSubviewToFront:self.filterItemView];
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.filterItemView setFrame:CGRectMake(SCREEN_WIDTH/4.f, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
        }];
    }
    else
    {
        if (!self.placeItemView)
        {
            self.placeItemView = [[BXTSelectItemView alloc] initWithFrame:viewRect tableViewFrame:tableRect datasource:datasource isProgress:NO type:FilterSearchType defaultSelected:self.placeID block:^(BXTBaseClassifyInfo *classifyInfo, NSString *name) {
                if (classifyInfo)
                {
                    self.placeID = classifyInfo.itemID;
                }
                else
                {
                    self.placeID = @"";
                }
                BXTMeterReadingListView *meterListView = [self currentMeterListView];
                [meterListView changePlaceID:self.placeID];
                
                UIView *view = [weakSelf.view viewWithTag:101];
                [UIView animateWithDuration:0.3f animations:^{
                    [weakSelf.placeItemView setFrame:CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                }];
            }];
            self.placeItemView.backgroundColor = colorWithHexString(@"eff3f6");
            [self.view addSubview:self.placeItemView];
        }
        else
        {
            [self.view bringSubviewToFront:self.placeItemView];
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.placeItemView setFrame:CGRectMake(SCREEN_WIDTH/4.f, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
        }];
    }
}

- (BXTMeterReadingListView *)currentMeterListView
{
    BXTMeterReadingListView *meterListView;
    if (self.btnTag == 0)
    {
        meterListView = electricView;
    }
    else if (self.btnTag == 1)
    {
        meterListView = waterView;
    }
    else if (self.btnTag == 2)
    {
        meterListView = gasView;
    }
    else if (self.btnTag == 3)
    {
        meterListView = heatView;
    }
    return meterListView;
}

#pragma mark -
#pragma mark 切换电能、水、燃气、热能
- (void)menuButtonClick:(UIButton *)btn
{
    self.btnTag = btn.tag;
    
    NSArray *colorArray = @[@"f45b5b", @"1683e2", @"f5c809", @"f1983e"];
    SaveValueTUD(EnergyReadingColorStr, colorArray[btn.tag]);
    
    self.view.backgroundColor = self.colorArray[btn.tag];
    [self navigationSetting:nil backColor:self.colorArray[btn.tag] rightImage:nil];
    [btn setTitleColor:self.colorArray[btn.tag] forState:UIControlStateNormal];
    
    [self.scrollerView setContentOffset:CGPointMake(btn.tag * CGRectGetWidth(self.scrollerView.frame), 0) animated:YES];
    
    if (btn == electricBtn)
    {
        leftWhiteView.hidden = NO;
        rightWhiteView.hidden = YES;
        
        [waterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [gasBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [heatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [electricBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
        [waterBtn changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawLeft];
        [gasBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [heatBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
    }
    else if (btn == waterBtn)
    {
        leftWhiteView.hidden = YES;
        rightWhiteView.hidden = YES;
        
        [electricBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [gasBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [heatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [electricBtn changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawRight];
        [waterBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
        [gasBtn changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawLeft];
        [heatBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
    }
    else if (btn == gasBtn)
    {
        leftWhiteView.hidden = YES;
        rightWhiteView.hidden = YES;
        
        [electricBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [waterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [heatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [electricBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [waterBtn changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawRight];
        [gasBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
        [heatBtn changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawLeft];
    }
    else if (btn == heatBtn)
    {
        leftWhiteView.hidden = YES;
        rightWhiteView.hidden = NO;
        
        [electricBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [waterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [gasBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [electricBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [waterBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [gasBtn changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawRight];
        [heatBtn changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
    }
}

#pragma mark -
#pragma mark 点击下面的四个筛选条件
- (void)filterButtonClick:(UIButton *)btn
{
    if (btn.tag == 0)
    {
        [self initialTableView:METERTABLETAG];
    }
    else if (btn.tag == 1)
    {
        [self initialTableView:PRICETABLETAG];
    }
    else if (btn.tag == 2)
    {
        NSArray *datasource = [[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE];
        [self initialPlaceOrFilter:datasource isFilter:NO];
    }
    else if (btn.tag == 3)
    {
        //TODO: 这里的数据是假的，是接口返回的筛选条件
        switch (self.btnTag) {
            case 0: [self initialPlaceOrFilter:electricView.energyFilterArray isFilter:YES]; break;
            case 1: [self initialPlaceOrFilter:waterView.energyFilterArray isFilter:YES]; break;
            case 2: [self initialPlaceOrFilter:gasView.energyFilterArray isFilter:YES]; break;
            case 3: [self initialPlaceOrFilter:heatView.energyFilterArray isFilter:YES]; break;
            default: break;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (self.chooseTableView)
        {
            [UIView animateWithDuration:0.3f animations:^{
                [self.chooseTableView setFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT + KBUTTONHEIGHT + 93.f, SCREEN_WIDTH - 20.f, 0)];
            } completion:^(BOOL finished) {
                [self.chooseTableView removeFromSuperview];
                self.chooseTableView = nil;
                [view removeFromSuperview];
            }];
        }
        BXTSelectItemView *tempItemView;
        if (self.isFilter)
        {
            tempItemView = self.filterItemView;
        }
        else
        {
            tempItemView = self.placeItemView;
        }
        if (tempItemView)
        {
            [UIView animateWithDuration:0.3f animations:^{
                [tempItemView setFrame:CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == METERTABLETAG)
    {
        return self.meterArray.count;
    }
    else if (tableView.tag == PRICETABLETAG)
    {
        return self.priceArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnergyCell" forIndexPath:indexPath];
    
    if (tableView.tag == METERTABLETAG)
    {
        cell.textLabel.text = self.meterArray[indexPath.row];
    }
    else if (tableView.tag == PRICETABLETAG)
    {
        cell.textLabel.text = self.priceArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView.tag == METERTABLETAG)
    {
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        self.checkType = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        BXTMeterReadingListView *meterListView = [self currentMeterListView];
        [meterListView changeCheckType:self.checkType];
    }
    else if (tableView.tag == PRICETABLETAG)
    {
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        self.priceType = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        BXTMeterReadingListView *meterListView = [self currentMeterListView];
        [meterListView changePriceType:self.priceType];
    }
    
    UIView *view = [self.view viewWithTag:101];
    if (view)
    {
        if (self.chooseTableView)
        {
            [UIView animateWithDuration:0.3f animations:^{
                [self.chooseTableView setFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT + KBUTTONHEIGHT + 93.f, SCREEN_WIDTH - 20.f, 0)];
            } completion:^(BOOL finished) {
                [self.chooseTableView removeFromSuperview];
                self.chooseTableView = nil;
                [view removeFromSuperview];
            }];
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page == currentPage) return;
    currentPage = page;
    
    if (currentPage == 0)
    {
        [self menuButtonClick:electricBtn];
    }
    else if (currentPage == 1)
    {
        [self menuButtonClick:waterBtn];
    }
    else if (currentPage == 2)
    {
        [self menuButtonClick:gasBtn];
    }
    else if (currentPage == 3)
    {
        [self menuButtonClick:heatBtn];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
