//
//  BXTGrabOrderViewController.m
//  YFBX
//
//  Created by Jason on 15/10/10.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTGrabOrderViewController.h"
#import "BXTHeaderForVC.h"
#include <math.h>
#import "WZFlashButton.h"
#import "MDRadialProgressView.h"
#import "RGCardViewLayout.h"
#import "RGCollectionViewCell.h"

@interface BXTGrabOrderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    AVAudioPlayer *player;
    NSInteger currentPage;
    NSMutableDictionary *markDic;
    UICollectionView *itemsCollectionView;
}

@property (nonatomic ,strong) MDRadialProgressView *radialProgressView;
@property (nonatomic ,strong) UILabel              *timeLabel;

@end

@implementation BXTGrabOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"mp3"]] error:nil];
    player.volume = 0.1f;
    player.numberOfLoops = -1;
    
    [self navigationSetting:@"实时抢单" andRightTitle:nil andRightImage:nil];
    [self createCollectionView];
    [self createSubviews];
    [self afterTimeWithSection:0];
    markDic = [NSMutableDictionary dictionaryWithObject:@"60" forKey:@"0"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[BXTGlobal shareGlobal].orderIDs removeAllObjects];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createCollectionView
{
    LogBlue(@"3count......%lu",(unsigned long)[BXTGlobal shareGlobal].orderIDs.count);
    RGCardViewLayout *flowLayout= [[RGCardViewLayout alloc] init];
    CGFloat bv_height = IS_IPHONE6 ? 180.f : 120.f;
    itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - bv_height) collectionViewLayout:flowLayout];
    [itemsCollectionView registerClass:[RGCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    itemsCollectionView.delegate = self;
    itemsCollectionView.dataSource = self;
    itemsCollectionView.pagingEnabled = YES;
    itemsCollectionView.showsHorizontalScrollIndicator = NO;
    itemsCollectionView.backgroundColor = colorWithHexString(@"eff3f6");
    [self.view addSubview:itemsCollectionView];
}

- (void)createSubviews
{
    CGFloat bv_height = IS_IPHONE6 ? 180.f : 120.f;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bv_height, SCREEN_WIDTH, bv_height)];
    backView.backgroundColor = colorWithHexString(@"febc2d");
    [self.view addSubview:backView];
    
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
    
    [backView addSubview:arc_View];
    
    CGFloat space = IS_IPHONE6 ? 30.f : 20.f;
    CGFloat grab_height = IS_IPHONE6 ? 53.3f : 45.6f;
    WZFlashButton *grab_button = [[WZFlashButton alloc] initWithFrame:CGRectMake(20.f, CGRectGetHeight(backView.frame) - grab_height - space, SCREEN_WIDTH - 40.f, grab_height)];
    [grab_button setBackgroundColor:colorWithHexString(@"f0640f")];
    [grab_button setText:@"抢单" withTextColor:[UIColor whiteColor]];
    grab_button.flashColor = [UIColor whiteColor];
    grab_button.layer.cornerRadius = 4.f;
    grab_button.layer.shadowColor = [UIColor blackColor].CGColor;
    grab_button.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    grab_button.layer.shadowOffset = CGSizeMake(0,3);
    [backView addSubview:grab_button];
}

#pragma mark -
#pragma mark 事件
- (void)afterTimeWithSection:(NSInteger)section
{
    [player play];
    __block NSInteger count = 60;
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
#pragma mark 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    LogBlue(@"4count......%lu",(unsigned long)[BXTGlobal shareGlobal].orderIDs.count);
    return [BXTGlobal shareGlobal].orderIDs.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RGCollectionViewCell *cell = (RGCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    
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
    return UIEdgeInsetsMake(0, 30, 0, 30);
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = IS_IPHONE6 ? 430.f : 330.f;
    return CGSizeMake(SCREEN_WIDTH - 60.f, height);
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([markDic.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]])
//    {
//        RGCollectionViewCell *willDisplayCell = (RGCollectionViewCell  *)cell;
//        NSInteger count = [[markDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]] integerValue];
//        if (count == 0)
//        {
//            willDisplayCell.backView.hidden = YES;
//        }
//        else
//        {
//            willDisplayCell.backView.hidden = NO;
//        }
//    }
//}

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
