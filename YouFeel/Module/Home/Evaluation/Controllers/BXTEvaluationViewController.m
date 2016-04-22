//
//  BXTEvaluationViewController.m
//  BXT
//
//  Created by Jason on 15/9/11.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTEvaluationViewController.h"
#import "BXTHeaderFile.h"
#import "AMRatingControl.h"
#import "BXTDataRequest.h"

@interface BXTEvaluationViewController ()<AMRateDelegate,UITextViewDelegate,BXTDataResponseDelegate>

@property (nonatomic ,strong) NSString       *notes;
@property (nonatomic ,strong) NSMutableArray *rateArray;

@end

@implementation BXTEvaluationViewController

- (instancetype)initWithRepairID:(NSString *)reID
{
    self = [super init];
    if (self)
    {
        [BXTGlobal shareGlobal].maxPics = 3;
        self.repairID = reID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.notes = @"";
    self.rateArray = [NSMutableArray arrayWithObjects:@"5",@"5",@"5", nil];
    [self createSubviews];
    [self navigationSetting:@"评价" andRightTitle:nil andRightImage:nil];
    
    //侦听删除事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"DeleteTheImage" object:nil];
}

- (void)navigationLeftButton
{
    if (self.delegateSignal)
    {
        [self.delegateSignal sendNext:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteImage:(NSNotification *)notification
{
    NSNumber *number = notification.object;
    [self handleData:[number integerValue]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -
#pragma mark 初始化视图
- (void)createSubviews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.backgroundColor = colorWithHexString(@"ffffff");
    [self.view addSubview:scrollView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    backView.backgroundColor = colorWithHexString(@"ffffff");
    [scrollView addSubview:backView];
    
    NSArray *titleArray = @[@"反应速度",@"专业水平",@"服务态度"];
    for (NSInteger i = 0; i < 3; i++)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 30 + 60 * i, 80.f, 20.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:17.f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = titleArray[i];
        [backView addSubview:titleLabel];
        
        UIImage *dot = [UIImage imageNamed:@"star_selected"];
        UIImage *star = [UIImage imageNamed:@"star"];
        AMRatingControl *imagesRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(120, 24 + 60 * i)
                                                                              emptyImage:dot
                                                                              solidImage:star
                                                                            andMaxRating:5];
        imagesRatingControl.tag = i;
        imagesRatingControl.rating = 5;
        imagesRatingControl.delegate = self;
        [backView addSubview:imagesRatingControl];
    }
    
    UIView *lineViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 209.5f, SCREEN_WIDTH, 0.5f)];
    lineViewOne.backgroundColor = colorWithHexString(@"909497");
    [backView addSubview:lineViewOne];
    
    //图片视图
    BXTPhotosView *photoView = [[BXTPhotosView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineViewOne.frame) + 20.f, SCREEN_WIDTH, 100)];
    photoView.backgroundColor = [UIColor orangeColor];
    [photoView.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:photoView];
    
    //添加图片点击事件
    @weakify(self);
    UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] init];
    [[tapGROne rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self loadMWPhotoBrowser:photoView.imgViewOne.tag];
    }];
    [photoView.imgViewOne addGestureRecognizer:tapGROne];
    UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] init];
    [[tapGRTwo rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self loadMWPhotoBrowser:photoView.imgViewTwo.tag];
    }];
    [photoView.imgViewTwo addGestureRecognizer:tapGRTwo];
    UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] init];
    [[tapGRThree rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self loadMWPhotoBrowser:photoView.imgViewThree.tag];
    }];
    [photoView.imgViewThree addGestureRecognizer:tapGRThree];
    self.photosView = photoView;
    
    UIView *lineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photosView.frame), SCREEN_WIDTH, 0.5f)];
    lineViewTwo.backgroundColor = colorWithHexString(@"909497");
    [backView addSubview:lineViewTwo];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, CGRectGetMaxY(lineViewTwo.frame) + 40.f, SCREEN_WIDTH - 40, 50.f);
    if (IS_IPHONE4)
    {
        commitBtn.frame = CGRectMake(20, CGRectGetMaxY(lineViewTwo.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
    }
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [commitBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:colorWithHexString(@"3cafff")];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 4.f;
    [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showLoadingMBP:@"正在提交..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request evaluateRepair:self.rateArray
                evaluationNotes:self.notes
                       repairID:self.repairID
                     imageArray:self.resultPhotos];
    }];
    [backView addSubview:commitBtn];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(commitBtn.frame)+70);
}

#pragma mark -
#pragma mark AMRateDeletage
- (void)rateNumber:(NSInteger)rate withRateControl:(AMRatingControl *)ctr
{
    [self.rateArray replaceObjectAtIndex:ctr.tag withObject:[NSString stringWithFormat:@"%ld",(long)rate]];
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
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [self hideMBP];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestDetail" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenEvaluationBtn" object:nil];
        @weakify(self);
        [self showMBP:@"评价成功！" withBlock:^(BOOL hidden) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        [self hideMBP];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
