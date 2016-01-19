//
//  BXTMaintenanceDetailViewController.m
//  YouFeel
//
//  Created by Jason on 16/1/7.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMaintenanceDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "BXTHeaderForVC.h"
#import "BXTDrawView.h"

@interface BXTMaintenanceDetailViewController ()<BXTDataResponseDelegate>

@property (nonatomic ,strong) NSString            *repair_id;

@end

@implementation BXTMaintenanceDetailViewController

- (void)dataWithRepairID:(NSString *)repair_ID
{
    [BXTGlobal shareGlobal].maxPics = 3;
    self.repair_id = repair_ID;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"工单详情" andRightTitle:nil andRightImage:nil];
    _sco_content_width.constant = SCREEN_WIDTH;
    _connectTa.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
    _connectTa.layer.borderWidth = 1.f;
    _connectTa.layer.cornerRadius = 4.f;
    _maintenance.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    _maintenance.layer.borderWidth = 1.f;
    _maintenance.layer.cornerRadius = 4.f;
    _groupName.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    _groupName.layer.borderWidth = 1.f;
    _groupName.layer.cornerRadius = 4.f;
    
    [self requestDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
}

- (void)requestDetail
{
    /**获取详情**/
    [self showLoadingMBP:@"努力加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairDetail:[NSString stringWithFormat:@"%@",_repair_id]];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    LogRed(@"%@",dic);
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
        NSDictionary *repaier_fault_dic = self.repairDetail.repair_fault_arr[0];
        NSString *headURL = [repaier_fault_dic objectForKey:@"head_pic"];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        _repairerName.text = [repaier_fault_dic objectForKey:@"name"];
        _repairerDetail.text = [repaier_fault_dic objectForKey:@"role"];
        _repairID.text = [NSString stringWithFormat:@"工单号:%@",self.repairDetail.orderid];
        NSString *repairTimeStr = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.repair_time];
        _repairTime.text = [NSString stringWithFormat:@"报修时间:%@",repairTimeStr];
        NSString *endTimeStr = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.long_time];
        _endTime.text = [NSString stringWithFormat:@"截止时间:%@",endTimeStr];
        if (self.repairDetail.visitmobile.length == 0)
        {
            _mobile.text = @"暂无";
        }
        else
        {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.repairDetail.visitmobile];
            [attributedString addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:NSMakeRange(0, 11)];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 11)];
            _mobile.attributedText = attributedString;
        }
        
        //动态计算groupName宽度
        NSString *group_name = self.repairDetail.subgroup_name.length > 0 ? self.repairDetail.subgroup_name : @"其他";
        CGSize group_size = MB_MULTILINE_TEXTSIZE(group_name, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH, 40.f), NSLineBreakByWordWrapping);
        _group_name_width.constant = group_size.width + 10;
        _groupName.text = group_name;
        [_groupName layoutIfNeeded];
        if (self.repairDetail.stores_name.length)
        {
            _place.text = [NSString stringWithFormat:@"位置:%@-%@-%@",self.repairDetail.area_name,self.repairDetail.place_name,self.repairDetail.stores_name];
        }
        else
        {
            _place.text = [NSString stringWithFormat:@"位置:%@-%@",self.repairDetail.area_name,self.repairDetail.place_name];
        }
        _faultType.text = [NSString stringWithFormat:@"故障类型:%@",self.repairDetail.faulttype_name];
        _cause.text = [NSString stringWithFormat:@"故障描述:%@",self.repairDetail.cause];
        
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
        [_firstBV layoutIfNeeded];
        
        //有无故障图
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
            _first_bv_height.constant = CGRectGetMaxY(_images_scrollview.frame) + 20.f;
            [_firstBV layoutIfNeeded];
        }
        else
        {
            _first_bv_height.constant = CGRectGetMaxY(_notes.frame) + 20.f;
            [_firstBV layoutIfNeeded];
        }
        
        //设备列表相关
        NSInteger deviceCount = self.repairDetail.device_list.count;
        _second_bv_height.constant = 48.f + 63.f * deviceCount;
        [_secondBV layoutIfNeeded];
        for (NSInteger i = 0; i < deviceCount; i++)
        {
            UIView *deviceView = [self deviceLists:i];
            [_secondBV addSubview:deviceView];
        }
        
        //状态相关
        BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, StateViewHeight) withRepairState:self.repairDetail.repairstate withIsRespairing:self.repairDetail.isRepairing];
        [_thirdBV addSubview:drawView];
        NSString *repairDateStr = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.dispatching_time];
        _arrangeTime.text = [NSString stringWithFormat:@"派工时间:%@",repairDateStr];
        _mmProcess.text = [NSString stringWithFormat:@"维修备注:%@",self.repairDetail.workprocess];
        [_mmProcess layoutIfNeeded];
        _workTime.text = [NSString stringWithFormat:@"维修工时:%@小时",self.repairDetail.man_hours];
        NSString *time_str = [BXTGlobal transformationTime:@"yyyy-MM-dd HH:mm" withTime:self.repairDetail.end_time];
        _completeTime.text = [NSString stringWithFormat:@"完成时间:%@",time_str];
        _third_bv_height.constant = CGRectGetMaxY(_completeTime.frame) + 10.f;
        [_thirdBV layoutIfNeeded];

        //维修员相关
        NSInteger usersCount = self.repairDetail.repair_user_arr.count;
        _fouth_bv_height.constant = 52 + RepairHeight * usersCount;
        [_fouthBV layoutIfNeeded];
        _sco_content_height.constant = CGRectGetMaxY(_fouthBV.frame);
        [_contentView layoutIfNeeded];
        for (NSInteger i = 0; i < usersCount; i++)
        {
            UIView *userBack = [self viewForUser:i andMaintenanceMaxY:CGRectGetMaxY(_maintenanceMan.frame) + 20 andLevelWidth:CGRectGetWidth(_level.frame)];
            [_fouthBV addSubview:userBack];
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
