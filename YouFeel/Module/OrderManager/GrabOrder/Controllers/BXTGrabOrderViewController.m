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

@interface BXTGrabOrderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,BXTDataResponseDelegate>
{
    AVAudioPlayer       *player;
    NSInteger           currentPage;
    NSArray             *comeTimeArray;
    NSMutableDictionary *markDic;
    UICollectionView    *itemsCollectionView;
    UIView              *gradBackView;
    UIView              *bgView;
    NSDate              *originDate;
}

@property (nonatomic ,strong) MDRadialProgressView *radialProgressView;
@property (nonatomic ,strong) UILabel              *timeLabel;
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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
            label.font = [UIFont systemFontOfSize:20.f];
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
            if ([BXTGlobal shareGlobal].newsOrderIDs.count > [BXTGlobal shareGlobal].numOfPresented-1)
            {
                [[BXTGlobal shareGlobal].newsOrderIDs removeObjectAtIndex:[BXTGlobal shareGlobal].numOfPresented-1];
                --[BXTGlobal shareGlobal].numOfPresented;
                if ([BXTGlobal shareGlobal].numOfPresented < 1)
                {
                    [[BXTGlobal shareGlobal].newsOrderIDs removeAllObjects];
                }
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

#pragma mark -
#pragma mark 事件
- (void)navigationLeftButton
{
    if ([BXTGlobal shareGlobal].newsOrderIDs.count >= [BXTGlobal shareGlobal].numOfPresented)
    {
        [[BXTGlobal shareGlobal].newsOrderIDs removeObjectAtIndex:[BXTGlobal shareGlobal].numOfPresented-1];
        --[BXTGlobal shareGlobal].numOfPresented;
        if ([BXTGlobal shareGlobal].numOfPresented < 1)
        {
            [[BXTGlobal shareGlobal].newsOrderIDs removeAllObjects];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
    if ([BXTGlobal shareGlobal].newsOrderIDs.count - 1 >= index)
    {
        NSString *orderID = [[BXTGlobal shareGlobal].newsOrderIDs objectAtIndex:index];
        [cell requestDetailWithOrderID:orderID];
    }
    
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
            [self showMBP:@"抢单失败，工单已取消！" withBlock:^(BOOL hidden) {
                [self navigationLeftButton];
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
