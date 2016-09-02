//
//  BXTOrderDetailViewModel.m
//  YouFeel
//
//  Created by Jason on 16/9/1.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTOrderDetailViewModel.h"
#import "BXTOrderDetailDataManager.h"
#import "BXTHeaderFile.h"

@interface BXTOrderDetailViewModel ()

@property (nonatomic, strong) BXTOrderDetailDataManager *orderDetailManager;
@property (nonatomic, strong) BXTOrderDetailDataManager *acceptOrderManager;

@end

@implementation BXTOrderDetailViewModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.refreshSubject = [RACSubject subject];
        
        // 配置铃声
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"]] error:nil];
        self.player.volume = 0.8f;
        self.player.numberOfLoops = -1;
        
        // 请求工单详情
        ++[BXTGlobal shareGlobal].numOfPresented;
        NSInteger index = [BXTGlobal shareGlobal].numOfPresented - 1;
        if ([BXTGlobal shareGlobal].newsOrderIDs.count - 1 >= index)
        {
            self.orderID = [[BXTGlobal shareGlobal].newsOrderIDs objectAtIndex:index];
            BXTOrderDetailDataManager *dataManager = [[BXTOrderDetailDataManager alloc] initWithOrderID:self.orderID requestType:OrderDetailType];
            @weakify(self);
            [dataManager.successSubject subscribeNext:^(BXTRepairDetailInfo *info) {
                @strongify(self);
                self.orderDetail = info;
                [self afterTime];
            }];
            [dataManager.failSubject subscribeNext:^(id x) {
                
            }];
            
            self.orderDetailManager = dataManager;
        }
    }
    return self;
}

#pragma mark -
#pragma mark 接单请求
- (void)acceptOrder
{
    if (!_backSubject)
    {
        self.backSubject = [RACSubject subject];
    }
    
    BXTOrderDetailDataManager *dataManager = [[BXTOrderDetailDataManager alloc] initWithOrderID:self.orderID requestType:AcceptOrderType];
    @weakify(self);
    [dataManager.successSubject subscribeNext:^(id x) {
        @strongify(self);
        [self.backSubject sendNext:nil];
    }];
    [dataManager.failSubject subscribeNext:^(id x) {
        
    }];
    
    self.acceptOrderManager = dataManager;
}

- (void)setOrderDetail:(BXTRepairDetailInfo *)orderDetail
{
    _orderDetail = orderDetail;
    if (_orderDetail)
    {
        BXTRepairPersonInfo *repairPerson = _orderDetail.fault_user_arr[0];
        self.r_p_headURL = repairPerson.head_pic;
        self.r_p_name = repairPerson.name;
        self.r_p_departmantName = repairPerson.department_name;
        UIFont *font = [UIFont systemFontOfSize:17.f];
        CGSize jobSize = MB_MULTILINE_TEXTSIZE(repairPerson.duty_name, font, CGSizeMake(200, 20), NSLineBreakByWordWrapping);
        self.r_p_job_width = jobSize.width + 10;
        self.r_p_jobName = repairPerson.duty_name;
        NSArray *timesArray = [_orderDetail.fault_time_name componentsSeparatedByString:@" "];
        self.r_p_yearMonth = timesArray[0];
        self.r_p_hours = timesArray[1];
        self.appointmentHidden = [_orderDetail.is_appointment isEqualToString:@"1"] ? NO : YES;
        
        [self.refreshSubject sendNext:nil];
    }
}

#pragma mark -
#pragma mark 铃声
- (void)afterTime
{
    [self.player play];
    __block NSInteger count = 20;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 3), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_time, ^{
        count--;
        if (count <= 0)
        {
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.player stop];
            });
        }
    });
    dispatch_resume(_time);
}

@end
