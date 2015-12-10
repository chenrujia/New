//
//  BXTAllOrdersViewController.m
//  YouFeel
//
//  Created by Jason on 15/11/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTAllOrdersViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTManagerOMView.h"
#include <math.h>

@interface BXTAllOrdersViewController ()<BXTDataResponseDelegate>
{
    BXTManagerOMView *omView;
    UIView           *alertBackView;
    UIButton         *startTime;
    UIButton         *endTime;
    NSString         *startStr;//开始时间戳
    NSString         *endStr;//结束时间戳
    NSArray          *orderTypeName;
    NSMutableArray   *groupArray;
    NSMutableArray   *selectGroups;
    NSMutableArray   *orderTypeBtns;
    UILabel          *groupsLabel;
    UILabel          *orderTypeLabel;
    NSInteger        selectOrderIndex;
    UIDatePicker     *datePicker;
    BOOL             isStart;
    NSString         *selectOT;
    CGFloat          alertHeight;
}
@end

@implementation BXTAllOrdersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IPHONE6P)
    {
        alertHeight = 576.f;
    }
    else if (IS_IPHONE6)
    {
        alertHeight = 512.f;
    }
    else
    {
        alertHeight = 360.f;
    }
    startStr = @"";
    endStr = @"";
    selectOT = @"";
    orderTypeName = @[@"未完成",@"已完成",@"特殊工单"];
    groupArray = [NSMutableArray array];
    selectGroups = [NSMutableArray array];
    orderTypeBtns = [NSMutableArray array];
    //请求分组列表
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request propertyGrouping];
    
    UIImage *rightImage = [UIImage imageNamed:@"w_small_round"];
    [self navigationSetting:@"全部工单" andRightTitle:nil andRightImage:rightImage];
    
    
    if (self.isSpecialPush)
    {
        NSArray *transArray = [[NSArray alloc] initWithObjects:self.transStartTime, self.transEndTime, self.transType, nil];
        omView = [[BXTManagerOMView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) andOrderType:AllType WithArray:transArray];
    }
    else
    {
        omView = [[BXTManagerOMView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) andOrderType:AllType WithArray:nil];
    }
    [self.view addSubview:omView];
}

#pragma mark -
#pragma mark 事件处理
- (void)navigationRightButton
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    if (!alertBackView)
    {
        alertBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, alertHeight)];
        alertBackView.backgroundColor = colorWithHexString(@"eff3f6");
        [self.view addSubview:alertBackView];
        
        CGFloat scrollViewHeight;
        CGFloat timeBackHeight;
        CGFloat line_y;
        CGFloat groupBackHeight;
        CGFloat orderTypeBackHeight;
        CGFloat doneBtnheight = 0.0;
        if (IS_IPHONE6P)
        {
            timeBackHeight = 272.f;
            line_y = 55.f;
            groupBackHeight = 114.f;
            orderTypeBackHeight = 122;
            doneBtnheight = 55.f;
            scrollViewHeight = alertHeight - doneBtnheight - 13.f;
        }
        else if (IS_IPHONE6P)
        {
            timeBackHeight = 262.f;
            line_y = 45.f;
            groupBackHeight = 94.f;
            orderTypeBackHeight = 96;
            doneBtnheight = 50.f;
            scrollViewHeight = alertHeight - doneBtnheight - 13.f;
        }
        else
        {
            timeBackHeight = 262.f;
            line_y = 45.f;
            groupBackHeight = 94.f;
            orderTypeBackHeight = 96;
            doneBtnheight = 50.f;
            scrollViewHeight = 336.f;
        }
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrollViewHeight)];
        if (IS_IPHONE6)
        {
            scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollViewHeight);
        }
        else
        {
            NSInteger row = floor(groupArray.count/4.f);
            scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, timeBackHeight + groupBackHeight + orderTypeBackHeight + row * 40.f);
        }
        [alertBackView addSubview:scrollView];
        
        //时间范围白色背景图
        UIView *timeRangeBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, timeBackHeight)];
        timeRangeBack.backgroundColor = colorWithHexString(@"ffffff");
        [scrollView addSubview:timeRangeBack];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, line_y, SCREEN_WIDTH, 1.0f)];
        lineView.backgroundColor = colorWithHexString(@"e1e5e7");
        [timeRangeBack addSubview:lineView];
        
        UILabel *timeAange = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (line_y - 20)/2.f, 100, 20)];
        timeAange.font = [UIFont boldSystemFontOfSize:17.f];
        timeAange.text = @"时间范围";
        [timeRangeBack addSubview:timeAange];
        
        startTime = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        startTime.tag = 1;
        [startTime setFrame:CGRectMake(SCREEN_WIDTH - 105.f - 100.f - 15.f, (line_y - 44)/2.f, 105, 44)];
        [startTime setBackgroundColor:colorWithHexString(@"ffffff")];
        startTime.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [startTime setTitle:@"开始时间" forState:UIControlStateNormal];
        [startTime setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        [startTime addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [timeRangeBack addSubview:startTime];
        
        endTime = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        endTime.tag = 0;
        [endTime setFrame:CGRectMake(CGRectGetMaxX(startTime.frame), (line_y - 44)/2.f, 100, 44)];
        [endTime setBackgroundColor:colorWithHexString(@"ffffff")];
        endTime.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [endTime setTitle:@"结束时间" forState:UIControlStateNormal];
        [endTime setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        [endTime addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [timeRangeBack addSubview:endTime];
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), SCREEN_WIDTH, 216)];
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
        datePicker.backgroundColor = colorWithHexString(@"ffffff");
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSLog(@"%@",[[NSDate date] description]);
        [datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
        [timeRangeBack addSubview:datePicker];

        //专业分组白色背景图
        NSInteger row = floor(groupArray.count/4.f);
        UIView *groupBack = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeRangeBack.frame), SCREEN_WIDTH, groupBackHeight + row * 40)];
        groupBack.backgroundColor = colorWithHexString(@"ffffff");
        [scrollView addSubview:groupBack];
        
        UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0f)];
        lineTwo.backgroundColor = colorWithHexString(@"e1e5e7");
        [groupBack addSubview:lineTwo];
        
        UIView *lineTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, line_y, SCREEN_WIDTH, 1.0f)];
        lineTwoView.backgroundColor = colorWithHexString(@"e1e5e7");
        [groupBack addSubview:lineTwoView];
        
        UILabel *proGroup = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (line_y - 20)/2.f, 100, 20)];
        proGroup.font = [UIFont boldSystemFontOfSize:17.f];
        proGroup.text = @"专业分组";
        [groupBack addSubview:proGroup];
        
        groupsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 215.f, (line_y - 20)/2.f, 200, 20.f)];
        groupsLabel.font = [UIFont boldSystemFontOfSize:17.f];
        groupsLabel.textAlignment = NSTextAlignmentRight;
        groupsLabel.textColor = colorWithHexString(@"3cafff");
        [groupBack addSubview:groupsLabel];

        CGFloat width = (SCREEN_WIDTH - 75.f)/4.f;
        for (NSInteger index = 0; index < groupArray.count; index++)
        {
            //行号
            NSInteger row = index/4; //行号为框框的序号对列数取商
            //列号
            NSInteger col = index%4; //列号为框框的序号对列数取余
            
            CGFloat appX = 15.f + col * (width + 15.f); // 每个框框靠左边的宽度为 (平均间隔＋框框自己的宽度）
            CGFloat appY = CGRectGetMaxY(lineTwoView.frame) + (IS_IPHONE6P ? 15 : 10) + row * (30.f + 10.f); // 每个框框靠上面的高度为 平均间隔＋框框自己的高度
            
            BXTGroupingInfo *groupInfo = groupArray[index];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setFrame:CGRectMake(appX, appY, width, 30.f)];
            [btn setBackgroundColor:colorWithHexString(@"eff3f6")];
            [btn setTitle:groupInfo.subgroup forState:UIControlStateNormal];
            [btn setTitleColor:colorWithHexString(@"929697") forState:UIControlStateNormal];
            btn.tag = index;
            btn.layer.cornerRadius = 4.f;
            [btn addTarget:self action:@selector(groupClick:) forControlEvents:UIControlEventTouchUpInside];
            [groupBack addSubview:btn];
        }
        
        //工单分类白色背景图
        UIView *orderTypeBack = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(groupBack.frame), SCREEN_WIDTH, orderTypeBackHeight)];
        orderTypeBack.backgroundColor = colorWithHexString(@"ffffff");
        [scrollView addSubview:orderTypeBack];
        
        UIView *lineThree = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0f)];
        lineThree.backgroundColor = colorWithHexString(@"e1e5e7");
        [orderTypeBack addSubview:lineThree];
        
        UIView *lineThreeView = [[UIView alloc] initWithFrame:CGRectMake(0, line_y, SCREEN_WIDTH, 1.0f)];
        lineThreeView.backgroundColor = colorWithHexString(@"e1e5e7");
        [orderTypeBack addSubview:lineThreeView];
        
        UILabel *orderName = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (line_y - 20)/2.f, 100, 20)];
        orderName.font = [UIFont boldSystemFontOfSize:17.f];
        orderName.text = @"工单分类";
        [orderTypeBack addSubview:orderName];
        
        orderTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 115.f, (line_y - 20)/2.f, 100, 20.f)];
        orderTypeLabel.font = [UIFont boldSystemFontOfSize:17.f];
        orderTypeLabel.textAlignment = NSTextAlignmentRight;
        orderTypeLabel.textColor = colorWithHexString(@"3cafff");
        [orderTypeBack addSubview:orderTypeLabel];
        
        for (NSInteger index = 0; index < orderTypeName.count; index++)
        {
            //行号
            NSInteger row = index/4; //行号为框框的序号对列数取商
            //列号
            NSInteger col = index%4; //列号为框框的序号对列数取余
            
            CGFloat appX = 15.f + col * (width + 15.f); // 每个框框靠左边的宽度为 (平均间隔＋框框自己的宽度）
            CGFloat appY = CGRectGetMaxY(lineTwoView.frame) + (IS_IPHONE6P ? 15 : 10) + row * (30.f + 10.f); // 每个框框靠上面的高度为 平均间隔＋框框自己的高度
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setFrame:CGRectMake(appX, appY, width, 30.f)];
            [btn setBackgroundColor:colorWithHexString(@"eff3f6")];
            [btn setTitle:orderTypeName[index] forState:UIControlStateNormal];
            [btn setTitleColor:colorWithHexString(@"929697") forState:UIControlStateNormal];
            btn.tag = index;
            btn.layer.cornerRadius = 4.f;
            [btn addTarget:self action:@selector(orderTypeClick:) forControlEvents:UIControlEventTouchUpInside];
            [orderTypeBtns addObject:btn];
            [orderTypeBack addSubview:btn];
        }
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [doneBtn setFrame:CGRectMake(0, alertHeight - doneBtnheight, SCREEN_WIDTH, doneBtnheight)];
        [doneBtn setBackgroundColor:colorWithHexString(@"ffffff")];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [alertBackView addSubview:doneBtn];
    }
    [self.view bringSubviewToFront:alertBackView];
    [UIView animateWithDuration:0.3f animations:^{
        [alertBackView setFrame:CGRectMake(0, SCREEN_HEIGHT - alertHeight, SCREEN_WIDTH, alertHeight)];
    }];
}

- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag)
    {
        isStart = YES;
        datePicker.maximumDate = datePicker.date;
        datePicker.minimumDate = nil;
    }
    else
    {
        isStart = NO;
        datePicker.maximumDate = nil;
        datePicker.minimumDate = datePicker.date;
    }
}

- (void)dateChange:(UIDatePicker *)picker
{
    NSString *dateStr = [BXTGlobal transTimeWithDate:picker.date withType:@"yyyy/MM/dd"];
    if (isStart)
    {
        [startTime setTitle:[NSString stringWithFormat:@"%@ -",dateStr] forState:UIControlStateNormal];
        startStr = [NSString stringWithFormat:@"%.0f",picker.date.timeIntervalSince1970];
    }
    else
    {
        [endTime setTitle:dateStr forState:UIControlStateNormal];
        endStr = [NSString stringWithFormat:@"%.0f",picker.date.timeIntervalSince1970 + 86399];
    }
}

- (void)groupClick:(UIButton *)button
{
    BXTGroupInfo *groupInfo = groupArray[button.tag];
    if ([selectGroups containsObject:groupInfo])
    {
        [selectGroups removeObject:groupInfo];
        [button setBackgroundColor:colorWithHexString(@"eff3f6")];
        [button setTitleColor:colorWithHexString(@"929697") forState:UIControlStateNormal];
    }
    else
    {
        [selectGroups addObject:groupInfo];
        [button setBackgroundColor:colorWithHexString(@"3cafff")];
        [button setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    }
    NSString *selectedGroups = @"";
    for (NSInteger i = 0; i < selectGroups.count; i++)
    {
        BXTGroupingInfo *groupInfo = selectGroups[i];
        if (i == 0)
        {
            selectedGroups = groupInfo.subgroup;
        }
        else
        {
            selectedGroups = [NSString stringWithFormat:@"%@,%@",selectedGroups,groupInfo.subgroup];
        }
    }
    groupsLabel.text = selectedGroups;
}

- (void)orderTypeClick:(UIButton *)button
{
    if (selectOrderIndex == button.tag)
    {
        selectOrderIndex = 1000;
        orderTypeLabel.text = @"";
        selectOT = @"";
        for (UIButton *btn in orderTypeBtns)
        {
            [btn setBackgroundColor:colorWithHexString(@"eff3f6")];
            [btn setTitleColor:colorWithHexString(@"929697") forState:UIControlStateNormal];
        }
    }
    else
    {
        selectOrderIndex = button.tag;
        orderTypeLabel.text = orderTypeName[button.tag];
        selectOT = [NSString stringWithFormat:@"%ld",(long)selectOrderIndex + 1];
        for (UIButton *btn in orderTypeBtns)
        {
            [btn setBackgroundColor:colorWithHexString(@"eff3f6")];
            [btn setTitleColor:colorWithHexString(@"929697") forState:UIControlStateNormal];
        }
        [button setBackgroundColor:colorWithHexString(@"3cafff")];
        [button setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    }
}

- (void)doneClick
{
    NSMutableArray *groupsArray = [NSMutableArray array];
    for (BXTGroupingInfo *groupInfo in selectGroups)
    {
        [groupsArray addObject:groupInfo.group_id];
    }
    [omView reloadAllType:startStr
               andEndTime:endStr
                andGourps:groupsArray
              andSelectOT:selectOT];
    
    UIView *view = [self.view viewWithTag:101];
    if (view)
    {
        [view removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            [alertBackView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, alertHeight)];
        } completion:nil];
    }
}

#pragma mark -
#pragma mark 代理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        [view removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            [alertBackView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, alertHeight)];
        } completion:nil];
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    LogRed(@"%@",dic);
    NSArray *data = [dic objectForKey:@"data"];
    if (type == PropertyGrouping)
    {
        [groupArray removeAllObjects];
        if (data.count)
        {
            for (NSDictionary *dictionary in data)
            {
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"group_id" onClass:[BXTGroupingInfo class]];
                [config addObjectMapping:text];
                
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTGroupingInfo class] andConfiguration:config];
                BXTGroupingInfo *groupInfo = [parser parseDictionary:dictionary];
                
                [groupArray addObject:groupInfo];
            }
            
            NSInteger row = floor(groupArray.count/4.f);
            alertHeight = alertHeight + row * 40;
        }
    }
}

- (void)requestError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
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
