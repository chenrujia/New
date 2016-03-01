//
//  BXTMTProfessionViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/2/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMTProfessionViewController.h"
#import "BXTMTProfessionBaseViewController.h"
#import "BXTMTProfessionTopView.h"

static CGFloat const titleH = 44;
static CGFloat const navBarH = 114;
static CGFloat const maxTitleScale = 1.3;

#define YCKScreenW [UIScreen mainScreen].bounds.size.width
#define YCKScreenH [UIScreen mainScreen].bounds.size.height

@interface BXTMTProfessionViewController () <UIScrollViewDelegate,BXTDataResponseDelegate>

@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray *subgroupArray;
@property (nonatomic, strong) NSMutableArray *subgroupIDArray;

// 选中按钮
@property (nonatomic, weak) UIButton *selTitleButton;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation BXTMTProfessionViewController

- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad {
    // 隐藏年月日选择项
    self.hideDatePicker = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.subgroupArray = [[NSMutableArray alloc] init];
    self.subgroupIDArray = [[NSMutableArray alloc] init];
    
    [self showLoadingMBP:@"数据加载中..."];
    
    if (!self.isSystemPush)
    {
        /**专业分组**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request propertyGrouping];
    }
    else
    {
        /**系统分组**/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request faultTypeListWithRTaskType:@"2"];
    }
    
}

#pragma mark -
#pragma mark - 设置头部标题栏
- (void)setupTitleScrollView
{
    BXTMTProfessionTopView *topView = [[[NSBundle mainBundle] loadNibNamed:@"BXTMTProfessionTopView" owner:nil options:nil] lastObject];
    topView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 100);
    if (!self.isSystemPush) {
        topView.titleView.text = @"维保专业分组统计";
    }
    else {
        topView.titleView.text = @"维保系统分组统计";
    }
    [self.view addSubview:topView];
    
    // 判断是否存在导航控制器来判断y值
    CGFloat y = self.navigationController ? navBarH : 0;
    CGRect rect = CGRectMake(0, y, YCKScreenW, titleH);
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleScrollView];
    
    self.titleScrollView = titleScrollView;
}

// 设置内容
- (void)setupContentScrollView
{
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y, YCKScreenW, YCKScreenH - navBarH);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:contentScrollView];
    
    self.contentScrollView = contentScrollView;
}

#pragma mark -
#pragma mark - 添加子控制器
- (void)addChildViewController
{
    for (int i=0; i<self.subgroupArray.count; i++)
    {
        BXTMTProfessionBaseViewController *vc = [[BXTMTProfessionBaseViewController alloc] init];
        vc.title = self.subgroupArray[i];
        vc.isSystemPush = self.isSystemPush;
        if (!self.isSystemPush) {
            vc.transSubgroupID = self.subgroupIDArray[i];
        }
        else {
            vc.transFaulttypeTypeID = self.subgroupIDArray[i];
        }
        [self addChildViewController:vc];
    }
}

// 设置标题
- (void)setupTitle
{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = 100;
    CGFloat h = titleH;
    
    for (int i = 0; i < count; i++)
    {
        UIViewController *vc = self.childViewControllers[i];
        
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
        if (i == 0)
        {
            [self chick:btn];
        }
        
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}

// 按钮点击
- (void)chick:(UIButton *)btn
{
    [self selTitleBtn:btn];
    
    NSUInteger i = btn.tag;
    CGFloat x = i * YCKScreenW;
    
    [self setUpOneChildViewController:i];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
}

// 选中按钮
- (void)selTitleBtn:(UIButton *)btn
{
    [self.selTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selTitleButton.transform = CGAffineTransformIdentity;
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(maxTitleScale, maxTitleScale);
    
    self.selTitleButton = btn;
    [self setupTitleCenter:btn];
}

- (void)setUpOneChildViewController:(NSUInteger)i
{
    CGFloat x = i * YCKScreenW;
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, YCKScreenW, YCKScreenH - self.contentScrollView.frame.origin.y);
    
    [self.contentScrollView addSubview:vc.view];
}

- (void)setupTitleCenter:(UIButton *)btn
{
    CGFloat offset = btn.center.x - YCKScreenW * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - YCKScreenW;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger i = self.contentScrollView.contentOffset.x / YCKScreenW;
    [self selTitleBtn:self.buttons[i]];
    [self setUpOneChildViewController:i];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger leftIndex = offsetX / YCKScreenW;
    NSInteger rightIndex = leftIndex + 1;
    
    //    NSLog(@"%zd,%zd",leftIndex,rightIndex);
    
    UIButton *leftButton = self.buttons[leftIndex];
    
    UIButton *rightButton = nil;
    if (rightIndex < self.buttons.count) {
        rightButton = self.buttons[rightIndex];
    }
    
    CGFloat scaleR = offsetX / YCKScreenW - leftIndex;
    CGFloat scaleL = 1 - scaleR;
    CGFloat transScale = maxTitleScale - 1;
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - 父类点击事件
- (void)datePickerBtnClick:(UIButton *)button
{
    if (button.tag == 10001)
    {
        /**饼状图**/
        if (!selectedDate)
        {
            selectedDate = [NSDate date];
        }
        [self.rootCenterButton setTitle:[self weekdayStringFromDate:selectedDate] forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BXTMTProfessionBaseViewController" object:nil userInfo:@{@"date": [self transTimeWithDate:selectedDate]}];
    }
    [super datePickerBtnClick:button];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == PropertyGrouping && data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            [self.subgroupArray addObject:dataDict[@"subgroup"]];
            [self.subgroupIDArray addObject:dataDict[@"id"]];
        }
    }
    else if (type == FaultType && data.count > 0)
    {
        for (NSDictionary *dataDict in data)
        {
            [self.subgroupArray addObject:dataDict[@"faulttype_type"]];
            [self.subgroupIDArray addObject:dataDict[@"id"]];
        }
    }
    
    [self setupTitleScrollView];
    [self setupContentScrollView];
    [self addChildViewController];
    [self setupTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * YCKScreenW, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
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
