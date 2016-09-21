//
//  BXTMeterReadingViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/6/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMeterReadingViewController.h"
#import "BXTMeterReadingHeaderCell.h"
#import "BXTMeterReadingListCell.h"
#import "BXTQRCodeViewController.h"
#import "BXTMeterReadingInfo.h"
#import "MYAlertAction.h"
#import "BXTMeterPrepaymentCell.h"

#define SaveImage [UIImage imageNamed:@"Add_button"]

// meter_condition ----  1 二维码扫描   2 NFC扫描   3 拍照
typedef NS_ENUM(NSInteger, ReadingType) {
    /** ---- 默认: 扫描 + 拍照 ---- */
    ReadingTypeOFDefault = 1,
    /** ---- 需扫描  ---- */
    ReadingTypeOFScan,
    /** ---- 需填图 ---- */
    ReadingTypeOFPicture
};

@interface BXTMeterReadingViewController () <UITableViewDelegate, UITableViewDataSource, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) BXTMeterReadingInfo *meterReadingInfo;

/** ---- 示数-标题 ---- */
@property (nonatomic, strong) NSArray *cellTitleArray;
/** ---- 输入值 ---- */
@property (nonatomic, strong) NSMutableArray *writeArray;
/** ---- 上期值 ---- */
@property (nonatomic, strong) NSMutableArray *lastValueArray;
/** ---- 上期用量 ---- */
@property (nonatomic, strong) NSMutableArray *lastNumArray;
/** ---- 本次值 ---- */
@property (nonatomic, strong) NSMutableArray *thisValueArray;
/** ---- 本次用量 ---- */
@property (nonatomic, strong) NSMutableArray *thisNumArray;

/** ---- 上传图片 ---- */
@property (nonatomic, strong) NSMutableArray *allImageArray;
/** ---- 上传图片ID ---- */
@property (nonatomic, strong) NSMutableArray *allPhotoArray;
/** ---- 上传图片index ---- */
@property (nonatomic, assign) NSInteger photoIndex;

/** ----  尖峰值不可操作 ---- */
@property (nonatomic, assign) BOOL unablePeakValue;

/** ---- 抄表类型 ---- */
@property (nonatomic, assign) ReadingType typeOFReading;

/** ---- 剩余总量 ---- */
@property (nonatomic, copy) NSString *surplusSum;
/** ---- 剩余金额 ---- */
@property (nonatomic, copy) NSString *surplusMoney;

@end

@implementation BXTMeterReadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationOwnSetting:@"新建抄表" andRightTitle:@"扫描解锁" andRightImage:nil];
    self.view.backgroundColor = colorWithHexString([BXTGlobal shareGlobal].energyColors[[BXTGlobal shareGlobal].energyType - 1]);
    self.photoVCType = MeterRecordType;
    
    self.writeArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @"", @" ", nil];
    self.thisValueArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @"", @" ", nil];
    self.thisNumArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @"", @" ", nil];
    self.allImageArray = [[NSMutableArray alloc] initWithObjects:SaveImage, SaveImage, SaveImage, SaveImage,  SaveImage, SaveImage, nil];
    self.allPhotoArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @"", @" ", nil];
    self.cellTitleArray = @[@"", @"峰段示数：", @"平段示数：", @"谷段示数：", @"尖峰示数：", @"总示数："];
    self.surplusSum = @"";
    self.surplusMoney = @"";
    
    //BXTPhotoBaseViewController 包括下面3条
    [BXTGlobal shareGlobal].maxPics = 1;
    self.selectPhotos = [NSMutableArray array];
    
    [BXTGlobal showLoadingMBP:@"加载中..."];
    /**新建抄表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterDetailWithID:self.transID];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector :@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notify
{
    // 总示数计算
    if (![self.thisValueArray containsObject:@""] && self.thisValueArray.count == 6) {
        
        double writeValue = 0;
        for (int i=0; i<self.writeArray.count-1; i++)
        {
            writeValue += [self removeOtherChar:self.writeArray[i]] * [self.meterReadingInfo.rate doubleValue];
        }
        
        double thisValue = [self removeOtherChar:self.writeArray[5]] * [self.meterReadingInfo.rate doubleValue];
        double thisNum = thisValue - [self removeOtherChar:self.lastValueArray[5]];
        [self.writeArray replaceObjectAtIndex:5 withObject:[BXTGlobal transNum:writeValue]];
        [self.thisValueArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%.2f", thisValue]];
        [self.thisNumArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%.2f", thisNum]];
        
        NSLog(@"%f, %f, %f", thisValue, thisNum, writeValue);
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)navigationOwnSetting:(NSString *)title
               andRightTitle:(NSString *)right_title1
               andRightImage:(UIImage *)image1
{
    // navView
    UIView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNAVIVIEWHEIGHT)];
    navView.backgroundColor = colorWithHexString([BXTGlobal shareGlobal].energyColors[[BXTGlobal shareGlobal].energyType - 1]);;
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [navView addSubview:titleLabel];
    
    // leftButton
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 20, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftButton];
    
    if (!(image1 || right_title1))
    {
        return;
    }
    // rightButton1
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setFrame:CGRectMake(SCREEN_WIDTH - 64.f - 5.f, 20, 64.f, 44.f)];
    if (image1)
    {
        rightButton1.frame = CGRectMake(SCREEN_WIDTH - 44.f - 5.f, 20, 44.f, 44.f);
        [rightButton1 setImage:image1 forState:UIControlStateNormal];
    }
    else
    {
        [rightButton1 setTitle:right_title1 forState:UIControlStateNormal];
    }
    rightButton1.titleLabel.font = [UIFont systemFontOfSize:15.f];
    @weakify(self);
    [[rightButton1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //创建参数对象
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
        style.photoframeLineW = 6;
        style.photoframeAngleW = 24;
        style.photoframeAngleH = 24;
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
        
        BXTQRCodeViewController *qrcVC = [[BXTQRCodeViewController alloc] init];
        qrcVC.style = style;
        qrcVC.isQQSimulator = YES;
        qrcVC.hidesBottomBarWhenPushed = YES;
        qrcVC.pushType = ReturnVCTypeOFMeterReadingCreate;
        qrcVC.delegateSignal = [RACSubject subject];
        @weakify(self);
        [qrcVC.delegateSignal subscribeNext:^(NSString *transID) {
            @strongify(self);
            if ([self.transID isEqualToString:transID])
            {
                @weakify(self);
                [BXTGlobal showText:@"设备解锁成功" completionBlock:^{
                    @strongify(self);
                    self.unlocked = YES;
                    [self.tableView reloadData];
                }];
            }
            else
            {
                [BXTGlobal showText:@"设备不正确，请重试" completionBlock:nil];
            }
        }];
        [self.navigationController pushViewController:qrcVC animated:YES];
    }];
    [navView addSubview:rightButton1];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 70)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // footerView
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerView];
    
    UIButton *cancelBtn = [self createButtonWithTitle:@"取消" btnX:10 tilteColor:@"#AEB4BB"];
    @weakify(self);
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.footerView addSubview:cancelBtn];
    
    UIButton *commitBtn = [self createButtonWithTitle:@"提交" btnX:SCREEN_WIDTH / 2 + 5  tilteColor:@"#5DAFF9"];
    
    [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.typeOFReading == ReadingTypeOFDefault || self.typeOFReading == ReadingTypeOFPicture) {
            if ([self.allPhotoArray containsObject:@""]) {
                [MYAlertAction showAlertWithTitle:@"请将图片添加完整" msg:nil chooseBlock:^(NSInteger buttonIdx){
                } buttonsStatement:@"确定", nil];
                return ;
            }
        }
        
        for (NSString *num in self.thisNumArray)
        {
            if ([num integerValue] < 0)
            {
                [MYAlertAction showAlertWithTitle:@"本次用量不能为负数，请检查" msg:nil chooseBlock:^(NSInteger buttonIdx) {
                } buttonsStatement:@"确定", nil];
                return ;
            }
        }
        
        [BXTGlobal showLoadingMBP:@"加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        if (self.thisValueArray.count == 6)
        {
            if (self.unablePeakValue)
            {
                [self.allPhotoArray replaceObjectAtIndex:4 withObject:@""];
            }
            
            [request energyMeterRecordAddWithAboutID:self.transID
                                            totalNum:[self returnOnlyNumber:self.thisValueArray[5]]
                                       peakPeriodNum:[self returnOnlyNumber:self.thisValueArray[1]]
                                      flatSectionNum:[self returnOnlyNumber:self.thisValueArray[2]]
                                    valleySectionNum:[self returnOnlyNumber:self.thisValueArray[3]]
                                      peakSegmentNum:[self returnOnlyNumber:self.thisValueArray[4]]
                                            totalPic:@""
                                       peakPeriodPic:self.allPhotoArray[1]
                                      flatSectionPic:self.allPhotoArray[2]
                                    valleySectionPic:self.allPhotoArray[3]
                                      peakSegmentPic:self.allPhotoArray[4]
                                     remainingEnergy:[self returnOnlyNumber:self.surplusSum]
                                      remainingMoney:[self returnOnlyNumber:self.surplusMoney]];
        }
        else
        {
            [request energyMeterRecordAddWithAboutID:self.transID
                                            totalNum:[self returnOnlyNumber:self.thisValueArray[1]]
                                       peakPeriodNum:@""
                                      flatSectionNum:@""
                                    valleySectionNum:@""
                                      peakSegmentNum:@""
                                            totalPic:self.allPhotoArray[1]
                                       peakPeriodPic:@""
                                      flatSectionPic:@""
                                    valleySectionPic:@""
                                      peakSegmentPic:@""
                                     remainingEnergy:[self returnOnlyNumber:self.surplusSum]
                                      remainingMoney:[self returnOnlyNumber:self.surplusMoney]];
        }
    }];
    
    [self.footerView addSubview:commitBtn];
    
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 预付费：0否 1是
    return self.thisValueArray.count + [self.meterReadingInfo.prepayment integerValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        BXTMeterReadingHeaderCell *cell = [BXTMeterReadingHeaderCell cellWithTableView:tableView];
        
        cell.meterReadingInfo = self.meterReadingInfo;
        
        return cell;
    }
    
    
    if (indexPath.section == self.thisValueArray.count)
    {
        BXTMeterPrepaymentCell *cell = [BXTMeterPrepaymentCell cellWithTableView:tableView];
        
        @weakify(self);
        [cell.numTextField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            double showNum = [x doubleValue] * [self.meterReadingInfo.rate integerValue];
            self.surplusSum = [BXTGlobal transNum:showNum];
            cell.sumLabel.text = [NSString stringWithFormat:@"%@ Kwh", self.surplusSum];
        }];
        [cell.moneyTextField.rac_textSignal subscribeNext:^(id x) {
            @strongify(self);
            self.surplusMoney = [BXTGlobal transNum:[x doubleValue]];
        }];
        
        return cell;
    }
    
    
    BXTMeterReadingListCell *cell = [BXTMeterReadingListCell cellWithTableView:tableView];
    
    // 锁定
    cell.NumTextField.userInteractionEnabled = self.unlocked;
    cell.addImageView.userInteractionEnabled = self.unlocked;
    
    // 初始化
    cell.titleView.text = self.cellTitleArray[indexPath.section];
    cell.NumTextField.text = self.writeArray[indexPath.section];
    cell.lastValueView.text = [self transUnitString:self.lastValueArray[indexPath.section]];
    cell.lastNumView.text = [self transUnitString:self.lastNumArray[indexPath.section]];
    cell.thisValueView.text = self.thisValueArray[indexPath.section];
    cell.thisNumView.text = self.thisNumArray[indexPath.section];
    [cell.addImageView setImage:self.allImageArray[indexPath.section] forState:UIControlStateNormal];
    // 按钮屏蔽
    if (indexPath.section == 5 || (indexPath.section == 4 && self.unablePeakValue))
    {
        cell.addImageView.hidden = YES;
        cell.NumTextField.userInteractionEnabled = NO;
    }
    
    @weakify(self);
    // 添加图片
    [[cell.addImageView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        self.photoIndex = indexPath.section;
        [self addImages];
    }];
    // 填表
    cell.NumTextField.tag = indexPath.section + 100;
    [cell.NumTextField.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        NSString *thisValueStr = @"";
        NSString *thisNumStr = @"";
        if (![BXTGlobal isBlankString:text] && cell.NumTextField.tag == indexPath.section + 100) {
            double thisValue = [self removeOtherChar:text] * [self.meterReadingInfo.rate integerValue];
            double thisNum = thisValue - [self removeOtherChar:cell.lastValueView.text];
            thisValueStr = [BXTGlobal transNum:thisValue];
            thisNumStr = [BXTGlobal transNum:thisNum];
            
            cell.thisValueView.text = [NSString stringWithFormat:@"%@ %@", thisValueStr, self.meterReadingInfo.unit];
            cell.thisNumView.text = [NSString stringWithFormat:@"%@ %@", thisNumStr, self.meterReadingInfo.unit];
        }
        else
        { // 原因：总示数不变，其余textfield清除不会清空，
            if (indexPath.section != 5)
            {
                cell.thisValueView.text = @"";
                cell.thisNumView.text = @"";
            }
        }
        [self.writeArray replaceObjectAtIndex:indexPath.section withObject:text];
        [self.thisValueArray replaceObjectAtIndex:indexPath.section withObject:thisValueStr];
        [self.thisNumArray replaceObjectAtIndex:indexPath.section withObject:thisNumStr];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 110;
    }
    if (indexPath.section == self.thisValueArray.count) {
        return 150;
    }
    return 175;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark -
#pragma mark MLImageCropDelegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    self.meterImage = cropImage;
    [BXTGlobal showLoadingMBP:@"正在上传..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterRecordFileWithImage:cropImage];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    
    NSDictionary *dic = (NSDictionary *)response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == EnergyMeterDetail && data.count > 0)
    {
        [BXTMeterReadingInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"meterReadingID":@"id"};
        }];
        self.meterReadingInfo = [BXTMeterReadingInfo mj_objectWithKeyValues:data[0]];
        
        BXTMeterReadingLastList *lastList = self.meterReadingInfo.last;
        
        NSInteger rate = [self.meterReadingInfo.rate integerValue];
        
        // price_type_id:   2-峰谷  OR   单一、阶梯
        if (![self.meterReadingInfo.price_type_id isEqualToString:@"2"])
        {
            self.writeArray = [[NSMutableArray alloc] initWithObjects:
                               @"0",
                               [self transToString:lastList.total_num / rate], nil];
            self.thisValueArray = [[NSMutableArray alloc] initWithObjects:@"0", [self transToString:lastList.total_num], nil];
            self.thisNumArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", nil];
            self.allImageArray = [[NSMutableArray alloc] initWithObjects:SaveImage, SaveImage, nil];
            self.allPhotoArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", nil];
            self.cellTitleArray = @[@"", @"总示数："];
            self.lastValueArray = [[NSMutableArray alloc] initWithObjects:
                                   @"0",
                                   [self transToString:lastList.total_num], nil];
            self.lastNumArray = [[NSMutableArray alloc] initWithObjects:
                                 @"0",
                                 [self transToString:lastList.use_amount], nil];
        }
        else
        {
            // 是否在尖峰期：0否 1是，只有当计价方式为峰谷的时候才需要该值
            self.writeArray = [[NSMutableArray alloc] initWithObjects:
                               @"0",
                               [self transToString:lastList.peak_period_num / rate],
                               [self transToString:lastList.flat_section_num / rate],
                               [self transToString:lastList.valley_section_num / rate],
                               [self transToString:lastList.peak_segment_num / rate],
                               [self transToString:lastList.total_num / rate], nil];
            self.lastValueArray = [[NSMutableArray alloc] initWithObjects:
                                   @"0",
                                   [self transToString:lastList.peak_period_num],
                                   [self transToString:lastList.flat_section_num],
                                   [self transToString:lastList.valley_section_num],
                                   [self transToString:lastList.peak_segment_num],
                                   [self transToString:lastList.total_num], nil];
            self.lastNumArray = [[NSMutableArray alloc] initWithObjects:
                                 @"0",
                                 [self transToString:lastList.peak_period_amount],
                                 [self transToString:lastList.flat_section_amount],
                                 [self transToString:lastList.valley_section_amount],
                                 [self transToString:lastList.peak_segment_amount],
                                 [self transToString:lastList.use_amount], nil];
            self.thisValueArray = [[NSMutableArray alloc] initWithObjects:
                                   @"0",
                                   [self transToString:lastList.peak_period_num],
                                   [self transToString:lastList.flat_section_num],
                                   [self transToString:lastList.valley_section_num],
                                   [self transToString:lastList.peak_segment_num],
                                   [self transToString:lastList.total_num], nil];
            self.thisNumArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", nil];
            
            if (![self.meterReadingInfo.is_peak_segment isEqualToString:@"1"])
            {
                self.unablePeakValue = YES;
                self.allPhotoArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @" ", @" ", nil];
            }
        }
        
        // check_type: 1-手动   2-自动(隐藏提交按钮)
        if ([self.meterReadingInfo.check_type isEqualToString:@"2"])
        {
            [self.footerView removeFromSuperview];
            self.tableView.frame = CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT);
        }
        
        // meter_condition ----  1 二维码扫描   2 NFC扫描   3 拍照
        // 1. meter_condition 默认: 扫描 + 拍照
        if ([self.meterReadingInfo.meter_condition rangeOfString:@"1"].location != NSNotFound && [self.meterReadingInfo.meter_condition rangeOfString:@"3"].location != NSNotFound)
        {
            self.typeOFReading = ReadingTypeOFDefault;
        }
        // 2. meter_condition 需扫描
        else if ([self.meterReadingInfo.meter_condition rangeOfString:@"1"].location != NSNotFound)
        {
            self.typeOFReading = ReadingTypeOFScan;
        }
        // 3. meter_condition 需填图
        else if ([self.meterReadingInfo.meter_condition rangeOfString:@"3"].location != NSNotFound)
        {
            self.typeOFReading = ReadingTypeOFPicture;
            self.unlocked = YES;
            [self navigationOwnSetting:@"新建抄表" andRightTitle:nil andRightImage:nil];
        }
        // 4. meter_condition 无需 扫描 + 拍照
        else
        {
            self.unlocked = YES;
            [self navigationOwnSetting:@"新建抄表" andRightTitle:nil andRightImage:nil];
        }
    }
    else if (type == EnergyMeterRecordFile && [dic[@"returncode"] intValue] == 0)
    {
        [BXTGlobal hideMBP];
        [self.allImageArray replaceObjectAtIndex:self.photoIndex withObject:self.meterImage];
        for (NSDictionary *dataDict in data)
        {
            [self.allPhotoArray replaceObjectAtIndex:self.photoIndex withObject:dataDict[@"id"]];
        }
    }
    else if (type == EnergyMeterRecordAdd && [dic[@"returncode"] intValue] == 0)
    {
        @weakify(self);
        [BXTGlobal showText:@"新建抄表成功" completionBlock:^{
            @strongify(self);
            if (self.delegateSignal)
            {
                [self.delegateSignal sendNext:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    [self.tableView reloadData];
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

#pragma mark -
#pragma mark - other
- (UIButton *)createButtonWithTitle:(NSString *)titleStr btnX:(CGFloat)btnX tilteColor:(NSString *)colorStr
{
    UIButton *newMeterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newMeterBtn.frame = CGRectMake(btnX, 10, (SCREEN_WIDTH - 30) / 2, 50);
    [newMeterBtn setBackgroundColor:colorWithHexString(colorStr)];
    [newMeterBtn setTitle:titleStr forState:UIControlStateNormal];
    newMeterBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    newMeterBtn.layer.cornerRadius = 5;
    
    return newMeterBtn;
}

- (NSString *)transToString:(double)sender
{
    return [NSString stringWithFormat:@"%@", [BXTGlobal transNum:sender]];
}

- (NSString *)transUnitString:(NSString *)sender
{
    return [NSString stringWithFormat:@"%@ %@", sender, self.meterReadingInfo.unit];
}

- (double)removeOtherChar:(NSString *)numStr
{
    return [[numStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
}

- (NSString *)returnOnlyNumber:(NSString *)numStr
{
    return [numStr stringByReplacingOccurrencesOfString:@"," withString:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
