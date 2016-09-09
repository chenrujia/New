//
//  BXTGrabOrderViewModel.m
//  YouFeel
//
//  Created by Jason on 16/9/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTGrabOrderViewModel.h"
#import "BXTHeaderFile.h"
#import "MJExtension.h"

@implementation BXTGrabOrderViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        // 配置铃声
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"]] error:nil];
        self.player.volume = 0.8f;
        self.player.numberOfLoops = -1;
        
        ++[BXTGlobal shareGlobal].numOfPresented;
        NSInteger index = [BXTGlobal shareGlobal].numOfPresented - 1;
        if ([BXTGlobal shareGlobal].newsOrderIDs.count - 1 >= index)
        {
            self.orderID = [[BXTGlobal shareGlobal].newsOrderIDs objectAtIndex:index];
            [self initialBind];
        }
    }
    return self;
}

- (void)initialBind
{
    // 工单详情
    @weakify(self);
	RACCommand *detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            BXTDataRequest *request = [[BXTDataRequest alloc] init];
            [request repairDetail:self.orderID success:^(RequestType type, id response) {
                NSDictionary *dic = (NSDictionary *)response;
                NSArray *data = [dic objectForKey:@"data"];
                NSDictionary *dictionary = data[0];
                BXTRepairDetailInfo *repairDetail = [BXTRepairDetailInfo mj_objectWithKeyValues:dictionary];
                self.orderDetail = repairDetail;
                [self afterTime];
                
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } fail:^(RequestType type, NSError *error) {
                [subscriber sendError:error];
            }];
            
            return nil;
            
        }];
    }];
    
    [[detailCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES)
        {
            // 正在执行
            [BXTGlobal showLoadingMBP:@"加载中..."];
        }
        else
        {
            // 执行完成
            [BXTGlobal hideMBP];
        }
    }];
    
    self.detailRequestCommand = detailCommand;
    
    // 接单
    RACCommand *grabCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           @strongify(self);
            BXTDataRequest *request = [[BXTDataRequest alloc] init];
            [request reaciveOrderID:self.orderID success:^(RequestType type, id response) {
                NSDictionary *dic = (NSDictionary *)response;
                [subscriber sendNext:dic];
                [subscriber sendCompleted];
            } fail:^(RequestType type, NSError *error) {
                [subscriber sendError:error];
            }];
            
            return nil;
        }];
    }];
    
    [[grabCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES)
        {
            // 正在执行
            [BXTGlobal showLoadingMBP:@"加载中..."];
        }
    }];
    
    self.grabOrderCommand = grabCommand;
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
        NSRange range = [_orderDetail.fault_time_name rangeOfString:timesArray[1]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:_orderDetail.fault_time_name];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"44b2fe") range:range];
        self.r_p_time = attributeStr;
        self.appointmentHidden = [_orderDetail.is_appointment isEqualToString:@"2"] ? NO : YES;
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
