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

#define KBUTTONHEIGHT 46.f
#define METERTABLETAG 666
#define PRICETABLETAG 888
#define LISTVIEWTAG 1000

@interface BXTEnergyClassificationViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, BXTDataResponseDelegate>
{
    BXTMenuItemButton *btnOne;
    BXTMenuItemButton *btnTwo;
    BXTMenuItemButton *btnThree;
    BXTMenuItemButton *btnFour;
    UIView *leftView;
    UIView *rightView;
    NSInteger currentPage;
}

@property (nonatomic, strong) NSArray           *colorArray;
//抄表方式数据
@property (nonatomic, strong) NSMutableArray    *meterArray;
//价格类型数据
@property (nonatomic, strong) NSMutableArray    *priceArray;
@property (nonatomic, strong) BXTSelectItemView *chooseItemView;
@property (nonatomic, strong) UITableView       *chooseTableView;
@property (nonatomic, strong) UIScrollView      *scrollerView;

/** ---- 1电、2水、3燃气、4热能 ---- */
@property (nonatomic, assign) NSInteger btnTag;
@property (nonatomic, copy) NSString *checkType;
@property (nonatomic, copy) NSString *priceType;
@property (nonatomic, copy) NSString *placeID;
@property (nonatomic, copy) NSString *measurementPath;

@property (nonatomic, strong) NSArray *filterArrayOne;
@property (nonatomic, strong) NSArray *filterArrayTwo;
@property (nonatomic, strong) NSArray *filterArrayThree;
@property (nonatomic, strong) NSArray *filterArrayFour;

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
    self.measurementPath = @"";
    self.filterArrayOne = [[NSArray alloc] init];
    self.filterArrayTwo = [[NSArray alloc] init];
    self.filterArrayThree = [[NSArray alloc] init];
    self.filterArrayFour = [[NSArray alloc] init];
    
    [self initialEnergyClass];
    [self initialSearchBarAndFilter];
    [self requestDatasoure];
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
    
    btnOne = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawMiddle backgroudColor:self.colorArray[0]];
    btnOne.tag = 0;
    [btnOne setTitle:@"电能" forState:UIControlStateNormal];
    [btnOne setTitleColor:self.colorArray[0] forState:UIControlStateNormal];
    [btnOne addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOne];
    
    btnTwo = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f + width, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawLeft backgroudColor:[UIColor whiteColor]];
    btnTwo.drawColor = self.colorArray[0];
    btnTwo.tag = 1;
    [btnTwo setTitle:@"水" forState:UIControlStateNormal];
    [btnTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTwo addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTwo];
    
    btnThree = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f + 2.f * width, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawNot backgroudColor:self.colorArray[0]];
    btnThree.tag = 2;
    [btnThree setTitle:@"燃气" forState:UIControlStateNormal];
    [btnThree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnThree addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnThree];
    
    btnFour = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f + 3.f * width, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawNot backgroudColor:self.colorArray[0]];
    btnFour.tag = 3;
    [btnFour setTitle:@"热能" forState:UIControlStateNormal];
    [btnFour setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFour addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFour];
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(btnOne.frame), 10.f, 10.f)];
    leftView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftView];
}

//大白色背景、搜索框、筛选条件按钮
- (void)initialSearchBarAndFilter
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(btnOne.frame), SCREEN_WIDTH - 20.f, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - KBUTTONHEIGHT - 10.f)];
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
    
    NSArray *titles = @[@"抄表方式",@"价格类型",@"安装位置",@"筛选   "];
    NSArray *images = @[@"select_triangle",@"select_triangle",@"select_triangle",@"filter"];
    for (NSInteger i = 0; i < 4; i++)
    {
        BXTCustomButton *meterTypeBtn = [[BXTCustomButton alloc] initWithType:EnergyBtnType];
        meterTypeBtn.tag = i;
        if (i == 3)
        {
            meterTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            meterTypeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        }
        meterTypeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
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
        BXTMeterReadingListView *meterView = [[BXTMeterReadingListView alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(self.scrollerView.frame), 0, CGRectGetWidth(self.scrollerView.frame), CGRectGetHeight(self.scrollerView.frame)) datasource:nil];
        meterView.tag = i + LISTVIEWTAG;
        [self.scrollerView addSubview:meterView];
    }
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20.f, CGRectGetMaxY(btnOne.frame), 10.f, 10.f)];
    rightView.backgroundColor = [UIColor whiteColor];
    rightView.hidden = YES;
    [self.view addSubview:rightView];
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
    
    CGRect viewRect = CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT);
    CGRect tableRect =  CGRectMake(0, 20, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT - 20.f - 64.f);
    
    
    // TODO: -----------------  调试  -----------------
    __weak __typeof(self) weakSelf = self;
    self.chooseItemView = [[BXTSelectItemView alloc] initWithFrame:viewRect tableViewFrame:tableRect datasource:datasource isProgress:NO type:PlaceSearchType block:^(BXTBaseClassifyInfo *classifyInfo, NSString *name) {
        
        if (isFilter) {
            self.measurementPath = classifyInfo.itemID;
        }
        else {
            self.placeID = classifyInfo.itemID;
        }
        
        [self getResourceWithTag:self.btnTag+1 hasMeasurementList:NO];
        NSLog(@"-------------------------- %@", classifyInfo.itemID);
        
        
        UIView *view = [weakSelf.view viewWithTag:101];
        [UIView animateWithDuration:0.3f animations:^{
            [weakSelf.chooseItemView setFrame:CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            [weakSelf.chooseItemView removeFromSuperview];
            weakSelf.chooseItemView = nil;
            [view removeFromSuperview];
        }];
    }];
    self.chooseItemView.backgroundColor = colorWithHexString(@"eff3f6");
    [self.view addSubview:self.chooseItemView];
    
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.chooseItemView setFrame:CGRectMake(SCREEN_WIDTH/4.f, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
    }];
}

#pragma mark -
#pragma mark 在这里处理数据请求
- (void)requestDatasoure
{
    self.meterArray = [[NSMutableArray alloc] initWithObjects:@"默认",@"手动抄表",@"自动抄表", nil];
    self.priceArray = [[NSMutableArray alloc] initWithObjects:@"默认",@"单一",@"峰谷",@"阶梯", nil];
    
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**电**/
        [self getResourceWithTag:1 hasMeasurementList:YES];
    });
    dispatch_async(concurrentQueue, ^{
        /**水**/
        [self getResourceWithTag:2 hasMeasurementList:YES];
    });
    dispatch_async(concurrentQueue, ^{
        /**燃气**/
        [self getResourceWithTag:3 hasMeasurementList:YES];
    });
    dispatch_async(concurrentQueue, ^{
        /**热能**/
        [self getResourceWithTag:4 hasMeasurementList:YES];
    });
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:REFRESHTABLEVIEWOFLIST object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self getResourceWithTag:self.btnTag + 1 hasMeasurementList:YES];
    }];
}

- (void)getResourceWithTag:(NSInteger )tag hasMeasurementList:(BOOL)isRight
{
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        [request energyMeterListsWithType:[NSString stringWithFormat:@"%ld", (long)tag]
                                checkType:self.checkType
                                priceType:self.priceType
                                  placeID:self.placeID
                          measurementPath:self.measurementPath
                               searchName:@""];
    });
    dispatch_async(concurrentQueue, ^{
        /**筛选条件**/
        if (isRight) {
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request energyMeasuremenLevelListsWithType:[NSString stringWithFormat:@"%ld", (long)tag]];
        }
    });
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == EnergyMeterListsOne)
    {
        [BXTGlobal hideMBP];
        [self dealData:data tag:LISTVIEWTAG];
    }
    if (type == EnergyMeterListsTwo)
    {
        [self dealData:data tag:LISTVIEWTAG + 1];
    }
    if (type == EnergyMeterListsThree)
    {
        [self dealData:data tag:LISTVIEWTAG + 2];
    }
    if (type == EnergyMeterListsFour)
    {
        [self dealData:data tag:LISTVIEWTAG + 3];
    }
    if (type == EnergyMeasuremenLevelListsOne)
    {
        NSMutableArray *listArray = [[NSMutableArray alloc] init];
        [BXTEnergyReadingFilterInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"filterID":@"id"};
        }];
        [listArray addObjectsFromArray:[BXTEnergyReadingFilterInfo mj_objectArrayWithKeyValuesArray:data]];
        self.filterArrayOne = listArray;
    }
    if (type == EnergyMeasuremenLevelListsTwo)
    {
        NSMutableArray *listArray = [[NSMutableArray alloc] init];
        [BXTEnergyReadingFilterInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"filterID":@"id"};
        }];
        [listArray addObjectsFromArray:[BXTEnergyReadingFilterInfo mj_objectArrayWithKeyValuesArray:data]];
        self.filterArrayTwo = listArray;
    }
    if (type == EnergyMeasuremenLevelListsThree)
    {
        NSMutableArray *listArray = [[NSMutableArray alloc] init];
        [BXTEnergyReadingFilterInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"filterID":@"id"};
        }];
        [listArray addObjectsFromArray:[BXTEnergyReadingFilterInfo mj_objectArrayWithKeyValuesArray:data]];
        self.filterArrayThree = listArray;
    }
    if (type == EnergyMeasuremenLevelListsFour)
    {
        NSMutableArray *listArray = [[NSMutableArray alloc] init];
        [BXTEnergyReadingFilterInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"filterID":@"id"};
        }];
        [listArray addObjectsFromArray:[BXTEnergyReadingFilterInfo mj_objectArrayWithKeyValuesArray:data]];
        self.filterArrayFour = listArray;
    }
    
    [self.chooseTableView reloadData];
}

- (void)dealData:(NSArray *)data tag:(NSInteger)tag
{
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    [BXTEnergyMeterListInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"energyMeterID":@"id"};
    }];
    [listArray addObjectsFromArray:[BXTEnergyMeterListInfo mj_objectArrayWithKeyValuesArray:data]];
    
    // 赋值
    for (BXTMeterReadingListView *listView in self.scrollerView.subviews)
    {
        if ([listView isKindOfClass:[BXTMeterReadingListView class]])
        {
            if (listView.tag == tag)
            {
                listView.datasource = (NSArray *)listArray;
            }
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
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
    
    if (btn == btnOne)
    {
        leftView.hidden = NO;
        rightView.hidden = YES;
        
        [btnTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnThree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnFour setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btnOne changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
        [btnTwo changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawLeft];
        [btnThree changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [btnFour changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
    }
    else if (btn == btnTwo)
    {
        leftView.hidden = YES;
        rightView.hidden = YES;
        
        [btnOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnThree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnFour setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btnOne changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawRight];
        [btnTwo changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
        [btnThree changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawLeft];
        [btnFour changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
    }
    else if (btn == btnThree)
    {
        leftView.hidden = YES;
        rightView.hidden = YES;
        
        [btnOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnFour setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btnOne changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [btnTwo changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawRight];
        [btnThree changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
        [btnFour changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawLeft];
    }
    else if (btn == btnFour)
    {
        leftView.hidden = YES;
        rightView.hidden = NO;
        
        [btnOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnThree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btnOne changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [btnTwo changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [btnThree changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawRight];
        [btnFour changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
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
            case 0: [self initialPlaceOrFilter:self.filterArrayOne isFilter:YES]; break;
            case 1: [self initialPlaceOrFilter:self.filterArrayTwo isFilter:YES]; break;
            case 2: [self initialPlaceOrFilter:self.filterArrayThree isFilter:YES]; break;
            case 3: [self initialPlaceOrFilter:self.filterArrayFour isFilter:YES]; break;
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
        if (self.chooseItemView)
        {
            [UIView animateWithDuration:0.3f animations:^{
                [self.chooseItemView setFrame:CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
            } completion:^(BOOL finished) {
                [self.chooseItemView removeFromSuperview];
                self.chooseItemView = nil;
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
    if (tableView.tag == METERTABLETAG)
    {
        NSLog(@"------------ %@", self.meterArray[indexPath.row]);
        self.checkType = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    else if (tableView.tag == PRICETABLETAG)
    {
        NSLog(@"------------ %@", self.priceArray[indexPath.row]);
        self.priceType = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    [self getResourceWithTag:self.btnTag + 1 hasMeasurementList:NO];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [self menuButtonClick:btnOne];
    }
    else if (currentPage == 1)
    {
        [self menuButtonClick:btnTwo];
    }
    else if (currentPage == 2)
    {
        [self menuButtonClick:btnThree];
    }
    else if (currentPage == 3)
    {
        [self menuButtonClick:btnFour];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
