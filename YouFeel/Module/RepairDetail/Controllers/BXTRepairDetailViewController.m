//
//  BXTRepairDetailViewController.m
//  BXT
//
//  Created by Jason on 15/9/7.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairDetailViewController.h"
#import "BXTDrawView.h"
#import "BXTRepairDetailInfo.h"
#import "BXTHeaderForVC.h"
#import "UIImageView+WebCache.h"
#import "BXTEvaluationViewController.h"

@interface BXTRepairDetailViewController ()<BXTDataResponseDelegate>

@property (nonatomic ,strong) UIButton            *evaluationBtn;
@property (nonatomic ,strong) UIView              *evaBackView;
@property (nonatomic ,strong) BXTRepairInfo       *repairInfo;

@end

@implementation BXTRepairDetailViewController

- (void)dataWithRepair:(BXTRepairInfo *)repair
{
    self.repairInfo = repair;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"工单详情" andRightTitle:nil andRightImage:nil];
    _cancelRepair.layer.cornerRadius = 6.f;
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HiddenEvaluationBtn" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.evaBackView removeFromSuperview];
        self.evaBackView = nil;
        [self.evaluationBtn removeFromSuperview];
        self.evaluationBtn = nil;
    }];
    
    /**获取报修列表**/
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairDetail:[NSString stringWithFormat:@"%ld",(long)_repairInfo.repairID]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -
#pragma mark 事件处理
- (void)loadingUsers
{
    NSString *repairDateStr = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.dispatching_time];
    _arrangeTime.text = [NSString stringWithFormat:@"派工时间:%@",repairDateStr];
    //是否填写过维修过程
    if (!_workTime.hidden)
    {
        _mmProcess.text = [NSString stringWithFormat:@"维修备注:%@",self.repairDetail.workprocess];
        [_mmProcess layoutIfNeeded];
        _workTime.text = [NSString stringWithFormat:@"维修工时:%@小时",self.repairDetail.man_hours];
        NSString *time_str = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.end_time];
        _completeTime.text = [NSString stringWithFormat:@"完成时间:%@",time_str];
    }
    else
    {
        _line_two_top.constant = 10.f;
        [_contentView layoutIfNeeded];
    }
    
    NSInteger count = self.repairDetail.repair_user_arr.count;
    if (count == 0)
    {
        _lineTwo.hidden = YES;
        _maintenanceMan.hidden = YES;
        if (CGRectGetMaxY(_arrangeTime.frame) + 20.f + 100.f < SCREEN_HEIGHT - KNAVIVIEWHEIGHT)
        {
            _sco_content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT;
        }
        [_contentView layoutIfNeeded];
        return;
    }
    //根据count的个数动态调整sco_content_height
    _sco_content_height.constant = CGRectGetMaxY(_maintenanceMan.frame) + RepairHeight * count + 60.f;
    [_contentView layoutIfNeeded];
    for (NSInteger i = 0; i < count; i++)
    {
        UIView *userBack = [self viewForUser:i andMaintenanceMaxY:CGRectGetMaxY(_maintenanceMan.frame) andLevelWidth:CGRectGetWidth(_level.frame)];
        [_contentView addSubview:userBack];
    }
    //如果此时sco_content_height不如屏幕大
    if (CGRectGetMaxY(_maintenanceMan.frame) + RepairHeight * count < SCREEN_HEIGHT - KNAVIVIEWHEIGHT)
    {
        _sco_content_height.constant = SCREEN_HEIGHT - KNAVIVIEWHEIGHT;
    }
    [_contentView layoutIfNeeded];
}

#pragma mark -
#pragma mark BXTDataRequestDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == RepairDetail && data.count > 0)
    {
        NSDictionary *dictionary = data[0];
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        DCObjectMapping *map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"repairID" onClass:[BXTRepairDetailInfo class]];
        [config addObjectMapping:map];
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTRepairDetailInfo class] andConfiguration:config];
        self.repairDetail = [parser parseDictionary:dictionary];
        //各种赋值
        _repairID.text = [NSString stringWithFormat:@"工单号:%@",self.repairDetail.orderid];
        NSString *currentDateStr = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.repair_time];
        _time.text = [NSString stringWithFormat:@"报修时间:%@",currentDateStr];
        if (self.repairDetail.stores_name.length)
        {
            _place.text = [NSString stringWithFormat:@"位置:%@-%@-%@",self.repairDetail.area_name,self.repairDetail.place_name,self.repairDetail.stores_name];
        }
        else
        {
            _place.text = [NSString stringWithFormat:@"位置:%@-%@",self.repairDetail.area_name,self.repairDetail.place_name];
        }
        [_place layoutIfNeeded];
        _name.text = [NSString stringWithFormat:@"报修人:%@",self.repairDetail.fault];
        _mobile.text = [NSString stringWithFormat:@"手机号:%@",self.repairDetail.visitmobile];
        _faultType.text = [NSString stringWithFormat:@"故障类型:%@",self.repairDetail.faulttype_name];
        [_faultType layoutIfNeeded];
        _cause.text = [NSString stringWithFormat:@"故障描述:%@",self.repairDetail.cause];
        [_cause layoutIfNeeded];
        if (self.repairDetail.urgent == 2)
        {
            _level.text = @"等级:一般";
        }
        else
        {
            NSString *str = @"等级:紧急";
            NSRange range = [str rangeOfString:@"紧急"];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
            _level.attributedText = attributeStr;
        }
        _notes.text = [NSString stringWithFormat:@"报修内容:%@",self.repairDetail.notes];
        [_notes layoutIfNeeded];
        //是否包含故障图片
        NSArray *imgArray = [self containAllArray];
        if (imgArray.count > 0)
        {
            NSInteger i = 0;
            _images_scrollview.contentSize = CGSizeMake((ImageWidth + 25) * imgArray.count + 25.f, ImageHeight);
            for (NSDictionary *dictionary in imgArray)
            {
                if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
                {
                    UIImageView *imgView = [self imageViewWith:i andDictionary:dictionary];
                    [_images_scrollview addSubview:imgView];
                    i++;
                }
            }
            [_contentView layoutIfNeeded];
            
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineOne.frame) + 10, SCREEN_WIDTH, StateViewHeight) withRepairState:self.repairDetail.repairstate withIsRespairing:self.repairDetail.isRepairing];
            [_contentView addSubview:drawView];

            if (!self.repairDetail.man_hours.length)
            {
                _mmProcess.hidden = YES;
                _workTime.hidden = YES;
                _completeTime.hidden = YES;
            }
            
            [self loadingUsers];
        }
        else
        {
            _line_one_top.constant = 10.f;
            [_contentView layoutIfNeeded];
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineOne.frame) + 10.f, SCREEN_WIDTH, 90.f) withRepairState:self.repairDetail.repairstate withIsRespairing:self.repairDetail.isRepairing];
            [_contentView addSubview:drawView];
            
            if (!self.repairDetail.man_hours.length)
            {
                _mmProcess.hidden = YES;
                _workTime.hidden = YES;
                _completeTime.hidden = YES;
            }
            
            [self loadingUsers];
        }
        //取消报修按钮
        if (self.repairDetail.repairstate != 1)
        {
            _cancelRepair.hidden = YES;
        }
        //评价按钮
        if (self.repairDetail.repairstate == 3)
        {
            self.evaBackView = [[UIView alloc] initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 200.f/3.f, SCREEN_WIDTH, 200.f/3.f)];
            _evaBackView.backgroundColor = [UIColor blackColor];
            _evaBackView.alpha = 0.6;
            [self.view addSubview:_evaBackView];
            
            self.evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_evaluationBtn setFrame:CGRectMake(0, 0, 200.f, 40.f)];
            [_evaluationBtn setCenter:CGPointMake(SCREEN_WIDTH/2.f,CGRectGetMinY(_evaBackView.frame) + _evaBackView.bounds.size.height/2.f)];
            [_evaluationBtn setTitle:@"发表评价" forState:UIControlStateNormal];
            [_evaluationBtn setTitleColor:colorWithHexString(@"3bb0ff") forState:UIControlStateNormal];
            [_evaluationBtn setBackgroundColor:[UIColor whiteColor]];
            _evaluationBtn.layer.cornerRadius = 4.f;
            _evaluationBtn.layer.masksToBounds = YES;
            @weakify(self);
            [[_evaluationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                BXTEvaluationViewController *evaluationVC = [[BXTEvaluationViewController alloc] initWithRepairID:[NSString stringWithFormat:@"%ld",(long)self.repairDetail.repairID]];
                [self.navigationController pushViewController:evaluationVC animated:YES];
            }];
            [self.view addSubview:_evaluationBtn];
        }
    }
    else if (type == DeleteRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestRepairList" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
