//
//  BXTEvaluationViewController.m
//  YouFeel
//
//  Created by Jason on 16/4/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEvaluationViewController.h"
#import "AMRatingControl.h"
#import "BXTPhotosView.h"

@interface BXTEvaluationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,AMRateDelegate,BXTDataResponseDelegate>

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
        self.notes = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"评价" andRightTitle:nil andRightImage:nil];
    
    self.notes = @"";
    if (!self.affairID) {
        self.affairID = @"";
    }
    self.rateArray = [NSMutableArray arrayWithObjects:@"5",@"5",@"5", nil];
    //侦听删除事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"DeleteTheImage" object:nil];
    
    UITableView *currentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    [currentTable setDelegate:self];
    [currentTable setDataSource:self];
    [self.view addSubview:currentTable];
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

- (void)deleteImage:(NSNotification *)notification
{
    NSNumber *number = notification.object;
    [self handleData:[number integerValue]];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01f)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 80.f;
    }
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *nextTapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextTapBtn.frame = CGRectMake(20, 30, SCREEN_WIDTH - 40, 50.f);
        [nextTapBtn setTitle:@"提交" forState:UIControlStateNormal];
        nextTapBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [nextTapBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [nextTapBtn setBackgroundColor:colorWithHexString(@"3cafff")];
        nextTapBtn.layer.masksToBounds = YES;
        nextTapBtn.layer.cornerRadius = 4.f;
        @weakify(self);
        [[nextTapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [BXTGlobal showLoadingMBP:@"正在提交..."];
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request evaluateRepair:self.rateArray
                    evaluationNotes:self.notes
                           repairID:self.repairID
                         imageArray:self.resultPhotos
                          affairsID:self.affairID];
        }];
        [view addSubview:nextTapBtn];
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12.f)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 200.f;
    }
    else if (indexPath.section == 1)
    {
        return 90.f;
    }
    return 100.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AMRateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0)
    {
        NSArray *titleArray = @[@"响应速度",@"服务态度",@"维修质量"];
        for (NSInteger i = 0; i < 3; i++)
        {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 25 + 60 * i, 80.f, 20.f)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:17.f];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = titleArray[i];
            [cell.contentView addSubview:titleLabel];
            
            UIImage *dot = [UIImage imageNamed:@"star_selected"];
            UIImage *star = [UIImage imageNamed:@"star"];
            AMRatingControl *imagesRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(120, 20 + 60 * i)
                                                                                  emptyImage:dot
                                                                                  solidImage:star
                                                                                andMaxRating:5];
            imagesRatingControl.tag = i;
            imagesRatingControl.rating = 5;
            imagesRatingControl.delegate = self;
            [cell.contentView addSubview:imagesRatingControl];
        }
    }
    else if (indexPath.section == 1)
    {
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20.f, 90.f)];
        tv.text = @"请输入评价内容";
        tv.font = [UIFont systemFontOfSize:17];
        tv.layer.cornerRadius = 3.f;
        tv.delegate = self;
        [cell.contentView addSubview:tv];
    }
    else
    {
        BXTPhotosView *photoView = [[BXTPhotosView alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 64.f)];
        [photoView.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:photoView];
        
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
    }
    
    return cell;
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
    if ([textView.text isEqualToString:@"请输入评价内容"])
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
        textView.text = @"请输入评价内容";
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [BXTGlobal hideMBP];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestDetail" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
        @weakify(self);
        [BXTGlobal showText:@"评价成功！" completionBlock:^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        [BXTGlobal hideMBP];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
