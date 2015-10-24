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
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "BXTEvaluationViewController.h"

#define ImageWidth 73.3f
#define ImageHeight 73.3f

@interface BXTRepairDetailViewController ()<BXTDataResponseDelegate,MWPhotoBrowserDelegate>
{
    UILabel *repairID;
    UILabel *time;
    UILabel *place;
    UILabel *name;
    UILabel *faultType;
    UILabel *cause;
    UILabel *level;
    UILabel *notes;
    UIButton *cancelRepair;
    BXTRepairDetailInfo *repairDetail;
    UIScrollView *scrollView;
    UILabel *arrangeTime;
    UIView *lineView;
    UILabel *maintenanceMan;
}

@property (nonatomic ,strong) BXTRepairInfo *repairInfo;
@property (nonatomic ,strong) NSMutableArray *mwPhotosArray;

@end

@implementation BXTRepairDetailViewController

- (instancetype)initWithRepair:(BXTRepairInfo *)repair
{
    self = [super init];
    if (self)
    {
        self.repairInfo = repair;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"工单详情" andRightTitle:nil andRightImage:nil];
    [self createSubViews];
    
    /**获取报修列表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request repairDetail:[NSString stringWithFormat:@"%ld",(long)_repairInfo.repairID]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark 初始化视图
- (void)createSubViews
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 900.f);
    scrollView.backgroundColor = colorWithHexString(@"ffffff");
    [self.view addSubview:scrollView];
    
    repairID = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, SCREEN_WIDTH - 30.f, 20)];
    repairID.textColor = colorWithHexString(@"000000");
    repairID.font = [UIFont boldSystemFontOfSize:17.f];
    repairID.text = [NSString stringWithFormat:@"工单号:%@",_repairInfo.orderid];
    [scrollView addSubview:repairID];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(repairID.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    time.textColor = colorWithHexString(@"000000");
    time.font = [UIFont boldSystemFontOfSize:17.f];
    time.text = [NSString stringWithFormat:@"报修时间:%@",_repairInfo.repair_time];
    [scrollView addSubview:time];
    
    place = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(time.frame) + 10.f, SCREEN_WIDTH - 30.f, 20)];
    place.textColor = colorWithHexString(@"000000");
    place.font = [UIFont boldSystemFontOfSize:17.f];
    place.text = [NSString stringWithFormat:@"位置:%@",_repairInfo.area];
    [scrollView addSubview:place];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(place.frame) + 10.f, CGRectGetWidth(place.frame), 20)];
    name.textColor = colorWithHexString(@"000000");
    name.font = [UIFont boldSystemFontOfSize:17.f];
    name.text = [NSString stringWithFormat:@"报修人:%@",_repairInfo.fault];
    [scrollView addSubview:name];
    
    faultType = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(name.frame) + 10.f, CGRectGetWidth(place.frame), 20)];
    faultType.textColor = colorWithHexString(@"000000");
    faultType.font = [UIFont boldSystemFontOfSize:17.f];
    faultType.text = [NSString stringWithFormat:@"故障类型:%ld",(long)_repairInfo.faulttype];
    [scrollView addSubview:faultType];
    
    cause = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(faultType.frame) + 10.f, CGRectGetWidth(name.frame), 20)];
    cause.textColor = colorWithHexString(@"000000");
    cause.font = [UIFont boldSystemFontOfSize:17.f];
    cause.text = [NSString stringWithFormat:@"故障描述:%@",_repairInfo.faulttype_name];
    [scrollView addSubview:cause];
    
    level = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(cause.frame) + 10.f, CGRectGetWidth(cause.frame), 20)];
    level.textColor = colorWithHexString(@"000000");
    level.font = [UIFont boldSystemFontOfSize:17.f];
    NSString *str;
    NSRange range;
    if (_repairInfo.urgent == 1)
    {
        str = @"等级:一般";
        range = [str rangeOfString:@"一般"];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
        level.attributedText = attributeStr;
    }
    else if (_repairInfo.urgent == 2)
    {
        str = @"等级:紧急";
        range = [str rangeOfString:@"紧急"];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
        level.attributedText = attributeStr;
    }
    
    [scrollView addSubview:level];
    
    notes = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(level.frame) + 8.f, CGRectGetWidth(level.frame), 20)];
    notes.textColor = colorWithHexString(@"000000");
    notes.numberOfLines = 0;
    notes.lineBreakMode = NSLineBreakByWordWrapping;
    notes.font = [UIFont boldSystemFontOfSize:17.f];
    [scrollView addSubview:notes];
    
    arrangeTime = [[UILabel alloc] init];
    arrangeTime.textColor = colorWithHexString(@"000000");
    arrangeTime.font = [UIFont boldSystemFontOfSize:17.f];
    [scrollView addSubview:arrangeTime];
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorWithHexString(@"e2e6e8");
    [scrollView addSubview:lineView];
    
    maintenanceMan = [[UILabel alloc] init];
    maintenanceMan.textColor = colorWithHexString(@"000000");
    maintenanceMan.font = [UIFont boldSystemFontOfSize:17.f];
    maintenanceMan.text = @"维修员:";
    [scrollView addSubview:maintenanceMan];
    
    cancelRepair = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
    [cancelRepair setTitle:@"取消报修" forState:UIControlStateNormal];
    [cancelRepair setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [cancelRepair setBackgroundColor:colorWithHexString(@"aac3e1")];
    cancelRepair.layer.masksToBounds = YES;
    cancelRepair.layer.cornerRadius = 6.f;
    [cancelRepair addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cancelRepair];
}

#pragma mark -
#pragma mark 事件处理
- (void)evaluate
{
    BXTEvaluationViewController *evaluationVC = [[BXTEvaluationViewController alloc] initWithRepairID:[NSString stringWithFormat:@"%ld",(long)repairDetail.repairID]];
    [self.navigationController pushViewController:evaluationVC animated:YES];
}

- (void)cancelBtn
{
    /**删除工单**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request deleteRepair:[NSString stringWithFormat:@"%ld",(long)repairDetail.repairID]];
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGR
{
    UIView *tapView = [tapGR view];
    [self loadMWPhotoBrowser:tapView.tag];
}

- (void)loadMWPhotoBrowser:(NSInteger)index
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in repairDetail.fault_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    self.mwPhotosArray = photos;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    
    [self.navigationController pushViewController:browser animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -
#pragma mark 代理
/**
 *  BXTDataRequestDelegate
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
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
        repairDetail = [parser parseDictionary:dictionary];
        
        repairID.text = [NSString stringWithFormat:@"工单号:%@",repairDetail.orderid];
        
        NSTimeInterval timeInterval = [repairDetail.repair_time doubleValue];
        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        time.text = [NSString stringWithFormat:@"报修时间:%@",currentDateStr];
        place.text = [NSString stringWithFormat:@"位置:%@",repairDetail.place_name];
        name.text = [NSString stringWithFormat:@"报修人:%@",repairDetail.fault];
        faultType.text = [NSString stringWithFormat:@"故障类型:%@",repairDetail.faulttype_name];
        cause.text = [NSString stringWithFormat:@"故障描述:%@",repairDetail.cause];
        
        NSString *str;
        NSRange range;
        if (repairDetail.urgent == 1)
        {
            str = @"等级:紧急";
            range = [str rangeOfString:@"紧急"];
        }
        else if (repairDetail.urgent == 2)
        {
            str = @"等级:一般";
            range = [str rangeOfString:@"一般"];
        }
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"de1a1a") range:range];
        level.attributedText = attributeStr;

        NSString *contents = [NSString stringWithFormat:@"报修内容:%@",repairDetail.notes];
        UIFont *font = [UIFont boldSystemFontOfSize:17.f];
        CGSize size = MB_MULTILINE_TEXTSIZE(contents, font, CGSizeMake(SCREEN_WIDTH - 30.f, 1000.f), NSLineBreakByWordWrapping);
        CGRect rect = notes.frame;
        rect.size = size;
        notes.frame = rect;
        notes.text = contents;
        
        NSArray *imgArray = repairDetail.fault_pic;
        if (imgArray.count > 0)
        {
            NSInteger i = 0;
            for (NSDictionary *dictionary in imgArray)
            {
                if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
                {
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25.f * (i + 1) + ImageWidth * i, CGRectGetMaxY(notes.frame) + 20.f, ImageWidth, ImageHeight)];
                    imgView.userInteractionEnabled = YES;
                    imgView.layer.masksToBounds = YES;
                    imgView.contentMode = UIViewContentModeScaleAspectFill;
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
                    imgView.tag = i;
                    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
                    [imgView addGestureRecognizer:tapGR];
                    [scrollView addSubview:imgView];
                    i++;
                }
            }
            
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(notes.frame) + ImageHeight + 20.f + 20.f, SCREEN_WIDTH, 90.f) withRepairState:repairDetail.repairstate];
            [scrollView addSubview:drawView];
            arrangeTime.frame = CGRectMake(20.f, CGRectGetMaxY(drawView.frame) + 15.f, SCREEN_WIDTH - 40.f, 20.f);
            
            if (repairDetail.repair_user_arr.count > 0)
            {
                NSTimeInterval repairTime = [repairDetail.dispatching_time doubleValue];
                NSDate *repairDate = [NSDate dateWithTimeIntervalSince1970:repairTime];
                //实例化一个NSDateFormatter对象
                NSDateFormatter *repairDateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [repairDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *repairDateStr = [repairDateFormatter stringFromDate:repairDate];
                arrangeTime.text = [NSString stringWithFormat:@"派工时间:%@",repairDateStr];
                lineView.frame = CGRectMake(15.f, CGRectGetMaxY(arrangeTime.frame) + 15.f, SCREEN_WIDTH - 30.f, 1.f);
                maintenanceMan.frame = CGRectMake(20.f, CGRectGetMaxY(lineView.frame) + 10.f, SCREEN_WIDTH - 40.f, 40.f);
                
                for (NSInteger i = 0; i < repairDetail.repair_user_arr.count; i++)
                {
                    NSDictionary *userDic = repairDetail.repair_user_arr[i];
                    
                    UIView *userBack = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(maintenanceMan.frame) + i * 95.f, SCREEN_WIDTH, 95.f)];
                    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 73.3f, 73.3f)];
                    [userImgView sd_setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"head_pic"]] placeholderImage:[UIImage imageNamed:@"103.jpg"]];
                    [userBack addSubview:userImgView];
                    
                    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 30.f, CGRectGetWidth(level.frame), 20)];
                    userName.textColor = colorWithHexString(@"000000");
                    userName.numberOfLines = 0;
                    userName.lineBreakMode = NSLineBreakByWordWrapping;
                    userName.font = [UIFont boldSystemFontOfSize:17.f];
                    userName.text = [userDic objectForKey:@"name"];
                    [userBack addSubview:userName];
                    
                    UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
                    contact.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
                    contact.layer.borderWidth = 1.f;
                    contact.layer.cornerRadius = 6.f;
                    [contact setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 22.5f + 10.f, 83.f, 40.f)];
                    [contact setTitle:@"联系Ta" forState:UIControlStateNormal];
                    [contact setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
                    [userBack addSubview:contact];
                    
                    if (i != repairDetail.repair_user_arr.count -1)
                    {
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, userBack.bounds.size.height - 1.f, SCREEN_WIDTH - 30.f, 1.f)];
                        line.backgroundColor = colorWithHexString(@"e2e6e8");
                        [userBack addSubview:line];
                    }
                    
                    [scrollView addSubview:userBack];
                }
                
                cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(maintenanceMan.frame) + repairDetail.repair_user_arr.count * 95.f + 20.f, SCREEN_WIDTH - 40, 50.f);
            }
            else
            {
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 600.f);
                cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(drawView.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
            }
        }
        else
        {
            BXTDrawView *drawView = [[BXTDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(notes.frame) + 20.f, SCREEN_WIDTH, 90.f) withRepairState:repairDetail.repairstate];
            [scrollView addSubview:drawView];
            arrangeTime.frame = CGRectMake(20.f, CGRectGetMaxY(drawView.frame) + 15.f, SCREEN_WIDTH - 40.f, 20.f);
            
            if (repairDetail.repair_user_arr.count > 0)
            {
                NSTimeInterval repairTime = [repairDetail.dispatching_time doubleValue];
                NSDate *repairDate = [NSDate dateWithTimeIntervalSince1970:repairTime];
                //实例化一个NSDateFormatter对象
                NSDateFormatter *repairDateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [repairDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *repairDateStr = [repairDateFormatter stringFromDate:repairDate];
                arrangeTime.text = [NSString stringWithFormat:@"派工时间:%@",repairDateStr];
                lineView.frame = CGRectMake(15.f, CGRectGetMaxY(arrangeTime.frame) + 15.f, SCREEN_WIDTH - 30.f, 1.f);
                maintenanceMan.frame = CGRectMake(20.f, CGRectGetMaxY(lineView.frame) + 10.f, SCREEN_WIDTH - 40.f, 40.f);
                
                for (NSInteger i = 0; i < repairDetail.repair_user_arr.count; i++)
                {
                    NSDictionary *userDic = repairDetail.repair_user_arr[i];
                    
                    UIView *userBack = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(maintenanceMan.frame) + i * 95.f, SCREEN_WIDTH, 95.f)];
                    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 73.3f, 73.3f)];
                    [userImgView sd_setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"head_pic"]] placeholderImage:[UIImage imageNamed:@"103.jpg"]];
                    [userBack addSubview:userImgView];

                    
                    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 30.f, CGRectGetWidth(level.frame), 20)];
                    userName.textColor = colorWithHexString(@"000000");
                    userName.numberOfLines = 0;
                    userName.lineBreakMode = NSLineBreakByWordWrapping;
                    userName.font = [UIFont boldSystemFontOfSize:17.f];
                    userName.text = [userDic objectForKey:@"name"];
                    [userBack addSubview:userName];
                    
                    UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
                    contact.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
                    contact.layer.borderWidth = 1.f;
                    contact.layer.cornerRadius = 6.f;
                    [contact setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 22.5f + 10.f, 83.f, 40.f)];
                    [contact setTitle:@"联系Ta" forState:UIControlStateNormal];
                    [contact setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
                    [userBack addSubview:contact];
                    
                    if (i != repairDetail.repair_user_arr.count -1)
                    {
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, userBack.bounds.size.height - 1.f, SCREEN_WIDTH - 30.f, 1.f)];
                        line.backgroundColor = colorWithHexString(@"e2e6e8");
                        [userBack addSubview:line];
                    }
                    
                    [scrollView addSubview:userBack];
                }
                
                cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(maintenanceMan.frame) + repairDetail.repair_user_arr.count * 95.f + 20.f, SCREEN_WIDTH - 40, 50.f);
            }
            else
            {
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 600.f);
                cancelRepair.frame = CGRectMake(20, CGRectGetMaxY(drawView.frame) + 20.f, SCREEN_WIDTH - 40, 50.f);
            }
        }
        if (repairDetail.repairstate != 1)
        {
            cancelRepair.hidden = YES;
        }
        if (repairDetail.repairstate == 3)
        {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 200.f/3.f, SCREEN_WIDTH, 200.f/3.f)];
            backView.backgroundColor = [UIColor blackColor];
            backView.alpha = 0.6;
            [self.view addSubview:backView];
            
            UIButton *evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [evaluationBtn setFrame:CGRectMake(0, 0, 200.f, 40.f)];
            [evaluationBtn setCenter:CGPointMake(SCREEN_WIDTH/2.f,CGRectGetMinY(backView.frame) + backView.bounds.size.height/2.f)];
            [evaluationBtn setTitle:@"发表评价" forState:UIControlStateNormal];
            [evaluationBtn setTitleColor:colorWithHexString(@"3bb0ff") forState:UIControlStateNormal];
            [evaluationBtn setBackgroundColor:[UIColor whiteColor]];
            evaluationBtn.layer.cornerRadius = 4.f;
            evaluationBtn.layer.masksToBounds = YES;
            [evaluationBtn addTarget:self action:@selector(evaluate) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:evaluationBtn];
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
    
}

/**
 *  MWPhotoBrowserDelegate
 */
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.mwPhotosArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = self.mwPhotosArray[index];
    return photo;
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
