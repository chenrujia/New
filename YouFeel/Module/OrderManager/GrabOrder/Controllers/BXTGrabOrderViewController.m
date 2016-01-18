//
//  BXTGrabOrderViewController.m
//  YFBX
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTGrabOrderViewController.h"
#import "BXTHeaderForVC.h"
#import "WZFlashButton.h"
#import "MDRadialProgressView.h"
#import "RGCardViewLayout.h"
#import "RGCollectionViewCell.h"
#import "BXTSelectBoxView.h"
#import "BXTDataRequest.h"

@interface BXTGrabOrderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,BXTBoxSelectedTitleDelegate,BXTDataResponseDelegate>
{
    AVAudioPlayer       *player;
    NSInteger           currentPage;
    NSArray             *comeTimeArray;
    BXTSelectBoxView    *boxView;
    NSMutableDictionary *markDic;
    UICollectionView    *itemsCollectionView;
    UIView              *gradBackView;
    UIView              *bgView;
    NSDate              *originDate;
}

@property (nonatomic ,strong) MDRadialProgressView *radialProgressView;
@property (nonatomic ,strong) UILabel              *timeLabel;
@property (nonatomic, strong) UIDatePicker         *datePicker;
@property (nonatomic, assign) NSTimeInterval       timeInterval;

@end

@implementation BXTGrabOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    ++[BXTGlobal shareGlobal].numOfPresented;
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (NSString *timeStr in [BXTGlobal readFileWithfileName:@"arriveArray"])
    {
        [timeArray addObject:[NSString stringWithFormat:@"%@分钟内", timeStr]];
    }
    [timeArray addObject:@"自定义"];
    comeTimeArray = timeArray;
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"]] error:nil];
    player.volume = 0.8f;
    player.numberOfLoops = -1;
    [self afterTimeWithSection:0];
    [self navigationSetting:@"实时抢单" andRightTitle:nil andRightImage:nil];
    [self createCollectionView];
    
    markDic = [NSMutableDictionary dictionaryWithObject:@"60" forKey:@"0"];
    
    [self addNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (player)
    {
        player = nil;
    }
}

- (void)addNotifications
{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SUBGROUP_NOTIFICATION" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSNotification *notify = x;
        CGFloat arc_height = IS_IPHONE6 ? 168.f : 112.f;
        UIView *arc_View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, arc_height, arc_height)];
        arc_View.center = CGPointMake(SCREEN_WIDTH/2.f, 0);
        arc_View.layer.masksToBounds = YES;
        arc_View.layer.cornerRadius = arc_height/2.f;
        arc_View.backgroundColor = colorWithHexString(@"febc2d");
        
        self.radialProgressView = ({
            
            CGFloat radia_height = IS_IPHONE6 ? 130.f : 86.7f;
            MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(0, 0, radia_height, radia_height)];
            radialView.center = CGPointMake(arc_height/2.f, arc_height/2.f);
            radialView.progressTotal = 20;
            radialView.progressCurrent = 0;
            radialView.completedColor = [UIColor whiteColor];
            radialView.incompletedColor = colorWithHexString(@"ffcc59");
            radialView.thickness = 10;
            radialView.backgroundColor = colorWithHexString(@"febc2d");
            radialView.sliceDividerHidden = NO;
            radialView.sliceDividerColor = colorWithHexString(@"febc2d");
            radialView.sliceDividerThickness = 1;
            [arc_View addSubview:radialView];
            radialView;
            
        });
        
        self.timeLabel = ({
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30.f)];
            label.center = CGPointMake(arc_height/2.f, arc_height/2.f);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:20.f];
            label.text = @"60s";
            [arc_View addSubview:label];
            label;
            
        });
        
        CGFloat grab_buttonH = SCREEN_WIDTH/4.57;
        UIButton *grab_button = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-grab_buttonH, SCREEN_WIDTH, grab_buttonH)];
        [grab_button setBackgroundImage:[UIImage imageNamed:@"Grab_btn"] forState:UIControlStateNormal];
        [grab_button addTarget:self action:@selector(reaciveOrder) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:grab_button];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, grab_buttonH-30, SCREEN_WIDTH-120, 30)];
        contentLabel.text = notify.object;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [grab_button addSubview:contentLabel];
        
    }];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ShowError" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self showMBP:@"数据出错了！！" withBlock:^(BOOL hidden) {
            [[BXTGlobal shareGlobal].newsOrderIDs removeObjectAtIndex:[BXTGlobal shareGlobal].numOfPresented-1];
            --[BXTGlobal shareGlobal].numOfPresented;
            if ([BXTGlobal shareGlobal].numOfPresented < 1)
            {
                [[BXTGlobal shareGlobal].newsOrderIDs removeAllObjects];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createCollectionView
{
    RGCardViewLayout *flowLayout= [[RGCardViewLayout alloc] init];
    itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) collectionViewLayout:flowLayout];
    [itemsCollectionView registerClass:[RGCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    itemsCollectionView.delegate = self;
    itemsCollectionView.dataSource = self;
    itemsCollectionView.pagingEnabled = YES;
    itemsCollectionView.showsHorizontalScrollIndicator = NO;
    itemsCollectionView.backgroundColor = colorWithHexString(@"eff3f6");
    [self.view addSubview:itemsCollectionView];
}

- (void)createDatePicker
{
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
    bgView.tag = 101;
    [self.view addSubview:bgView];
    
    originDate = [NSDate date];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-50-40, SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = colorWithHexString(@"ffffff");
    titleLabel.text = @"请选择到达时间";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame)-1, SCREEN_WIDTH-30, 1)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [bgView addSubview:line];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216-50, SCREEN_WIDTH, 216)];
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    _datePicker.backgroundColor = colorWithHexString(@"ffffff");
    _datePicker.minimumDate = [NSDate date];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [[_datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        // 获取分钟数
        self.timeInterval = [self.datePicker.date timeIntervalSince1970];
    }];
    [bgView addSubview:_datePicker];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = colorWithHexString(@"ffffff");
    [bgView addSubview:toolView];
    // sure
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = 10001;
    sureBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    sureBtn.layer.borderWidth = 0.5;
    [toolView addSubview:sureBtn];
    // cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(datePickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.borderColor = [colorWithHexString(@"#d9d9d9") CGColor];
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.tag = 10002;
    [toolView addSubview:cancelBtn];
}

#pragma mark -
#pragma mark 事件
- (void)reaciveOrder
{
    /**接单**/
    gradBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    gradBackView.backgroundColor = [UIColor blackColor];
    gradBackView.alpha = 0.6f;
    gradBackView.tag = 101;
    [self.view addSubview:gradBackView];
    
    
    if (boxView)
    {
        [boxView boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray];
        [self.view bringSubviewToFront:boxView];
    }
    else
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"请选择到达时间" boxSelectedViewType:Other listDataSource:comeTimeArray markID:nil actionDelegate:self];
        [self.view addSubview:boxView];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
    }];
}

- (void)navigationLeftButton
{
    [[BXTGlobal shareGlobal].newsOrderIDs removeObjectAtIndex:[BXTGlobal shareGlobal].numOfPresented-1];
    --[BXTGlobal shareGlobal].numOfPresented;
    if ([BXTGlobal shareGlobal].numOfPresented < 1)
    {
        [[BXTGlobal shareGlobal].newsOrderIDs removeAllObjects];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)datePickerBtnClick:(UIButton *)button
{
    if (button.tag == 10001)
    {
        [self showLoadingMBP:@"奋力争抢中..."];
        //NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)timeInterval/60+1];
        NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)_timeInterval];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        NSInteger index = [BXTGlobal shareGlobal].numOfPresented - 1;
        NSString *orderID = [[BXTGlobal shareGlobal].newsOrderIDs objectAtIndex:index];
        NSString *userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
        NSArray *users = @[userID];
        [request reaciveOrderID:orderID
                    arrivalTime:timeStr
                      andUserID:userID
                       andUsers:users
                      andIsGrad:YES];
    }
    _datePicker = nil;
    [bgView removeFromSuperview];
}

- (void)afterTimeWithSection:(NSInteger)section
{
    [player play];
    __block NSInteger count = 20;
    __weak BXTGrabOrderViewController *weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 3), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_time, ^{
        count--;
        if (count <= 0)
        {
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf stopPlayWithSection:section];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateTimeNumber:count withSection:section];
        });
    });
    dispatch_resume(_time);
}

- (void)updateTimeNumber:(NSInteger)timeNumber withSection:(NSInteger)section
{
    [markDic setObject:[NSString stringWithFormat:@"%ld",(long)timeNumber] forKey:[NSString stringWithFormat:@"%ld",(long)section]];
    if (section == currentPage)
    {
        [self updateProcess:timeNumber];
    }
}

- (void)stopPlayWithSection:(NSInteger)section
{
    if (section == currentPage)
    {
        [player stop];
        NSArray *dataArray = [markDic allValues];
        BOOL isAllComplete = YES;
        for (NSString *time in dataArray)
        {
            if (![time isEqualToString:@"1"])
            {
                isAllComplete = NO;
                break;
            }
        }
        if (isAllComplete)
        {
            //[self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)updateProcess:(NSInteger)timeNumber
{
    if (timeNumber <= 0)
    {
        [player stop];
        _timeLabel.text = @"Over";
        _radialProgressView.progressCurrent = 20;
        [_radialProgressView setNeedsDisplay];
    }
    else
    {
        [player play];
        _timeLabel.text = [NSString stringWithFormat:@"%lds",(long)timeNumber];
        NSInteger rows = 20 - ceil(timeNumber/3);
        _radialProgressView.progressCurrent = rows;
        [_radialProgressView setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RGCollectionViewCell *cell = (RGCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger index = [BXTGlobal shareGlobal].numOfPresented - 1;
    NSString *orderID = [[BXTGlobal shareGlobal].newsOrderIDs objectAtIndex:index];
    [cell requestDetailWithOrderID:orderID];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-KNAVIVIEWHEIGHT);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page == currentPage) return;
    currentPage = page;
    NSString *currentKey = [NSString stringWithFormat:@"%ld",(long)currentPage];
    if (![markDic.allKeys containsObject:currentKey])
    {
        [player stop];
        [self afterTimeWithSection:currentPage];
        [markDic setObject:@"60" forKey:currentKey];
    }
    else
    {
        NSString *timeNumber = [markDic objectForKey:currentKey];
        [self updateProcess:[timeNumber integerValue]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (_datePicker)
        {
            [_datePicker removeFromSuperview];
            _datePicker = nil;
        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
            }];
        }
        
        [view removeFromSuperview];
    }
}

- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    [gradBackView removeFromSuperview];
    gradBackView = nil;
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    }];
    
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *tempStr = (NSString *)obj;
        if ([tempStr isEqualToString:@"自定义"]) {
            [self createDatePicker];
            return;
        }
        NSString *timeStr = [tempStr stringByReplacingOccurrencesOfString:@"分钟内" withString:@""];
        NSTimeInterval timer = [[NSDate date] timeIntervalSince1970] + [timeStr intValue]*60;
        timeStr = [NSString stringWithFormat:@"%.0f", timer];
        
        [self showLoadingMBP:@"奋力争抢中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        NSInteger index = [BXTGlobal shareGlobal].numOfPresented - 1;
        NSString *orderID = [[BXTGlobal shareGlobal].newsOrderIDs objectAtIndex:index];
        NSString *userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
        NSArray *users = @[userID];
        [request reaciveOrderID:orderID
                    arrivalTime:timeStr
                      andUserID:userID
                       andUsers:users
                      andIsGrad:YES];
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    if (type == ReaciveOrder)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReaciveOrderSuccess" object:nil];
            [self showMBP:@"抢单成功！" withBlock:^(BOOL hidden) {
                [self navigationLeftButton];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"041"])
        {
            [self showMBP:@"工单已被抢！" withBlock:^(BOOL hidden) {
                [self navigationLeftButton];
            }];
        }
        else if ([[dic objectForKey:@"returncode"] isEqualToString:@"002"])
        {
            [self showMBP:@"工单已取消！" withBlock:^(BOOL hidden) {
                [self navigationLeftButton];
            }];
        }
    }
}

- (void)requestError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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