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

@interface BXTMeterReadingViewController () <UITableViewDelegate, UITableViewDataSource, BXTDataResponseDelegate>

@property (nonatomic, strong) UITableView *tableView;
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

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) BXTMeterReadingInfo *meterReadingInfo;

/** ---- 示数-标题 ---- */
@property (nonatomic, strong) NSArray *cellTitleArray;
/** ---- 上期值 ---- */
@property (nonatomic, strong) NSMutableArray *lastValueArray;
/** ---- 上期用量 ---- */
@property (nonatomic, strong) NSMutableArray *lastNumArray;

/** ---- 隐藏尖峰值 ---- */
@property (nonatomic, assign) BOOL hidePeakValue;

@end

@implementation BXTMeterReadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationOwnSetting:@"新建抄表" andRightTitle:@"扫描解锁" andRightImage:nil];
    self.view.backgroundColor = colorWithHexString(ValueFUD(EnergyReadingColorStr));
    
    
    self.thisValueArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @"", @" ", nil];
    self.thisNumArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @"", @"", nil];
    UIImage *saveImage = [UIImage imageNamed:@"Add_button"];
    self.allImageArray = [[NSMutableArray alloc] initWithObjects:saveImage, saveImage, saveImage, saveImage,  saveImage, saveImage, nil];
    self.allPhotoArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @"", @" ", nil];
    self.cellTitleArray = @[@"", @"峰段示数：", @"平段示数：", @"谷段示数：", @"尖峰示数：", @"总示数："];
    // BXTPhotoBaseViewController 包括下面3条
    [BXTGlobal shareGlobal].maxPics = 1;
    self.isSettingVC = YES;
    self.selectPhotos = [NSMutableArray array];
    
    
    [BXTGlobal showLoadingMBP:@"数据加载中..."];
    /**新建抄表**/
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request energyMeterDetailWithID:self.transID];
    
    
    [self createUI];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector :@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notify
{
    // 总示数计算
    if (![self.thisValueArray containsObject:@""] && self.thisValueArray.count == 6 - self.hidePeakValue) {
        
        NSInteger thisValue = 0;
        for (int i=0; i<self.thisValueArray.count-1; i++) {
            thisValue += [self.thisValueArray[i] integerValue];
        }
        
        NSInteger thisNum = [self.thisValueArray[5 - self.hidePeakValue] integerValue] * [self.meterReadingInfo.rate integerValue] - [self.lastValueArray[5 - self.hidePeakValue] integerValue];
        [self.thisValueArray replaceObjectAtIndex:5 - self.hidePeakValue withObject:[NSString stringWithFormat:@"%ld", thisValue]];
        [self.thisNumArray replaceObjectAtIndex:5 - self.hidePeakValue withObject:[NSString stringWithFormat:@"%ld", thisNum]];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:5 - self.hidePeakValue] withRowAnimation:UITableViewRowAnimationFade];
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
    navView.backgroundColor = [UIColor clearColor];
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
    
    
    if (!(image1 || right_title1)) {
        return;
    }
    // rightButton1
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setFrame:CGRectMake(SCREEN_WIDTH - 64.f - 5.f, 20, 64.f, 44.f)];
    if (image1) {
        rightButton1.frame = CGRectMake(SCREEN_WIDTH - 44.f - 5.f, 20, 44.f, 44.f);
        [rightButton1 setImage:image1 forState:UIControlStateNormal];
    } else {
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
    
    
    // TODO: -----------------  调试  -----------------
    UIButton *commitBtn = [self createButtonWithTitle:@"提交" btnX:SCREEN_WIDTH / 2 + 5  tilteColor:@"#5DAFF9"];
    [[commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        if ([self.thisValueArray containsObject:@""]) {
            [MYAlertAction showAlertWithTitle:@"请将示数填写完整" msg:nil chooseBlock:^(NSInteger buttonIdx) {
            } buttonsStatement:@"确定", nil];
            return ;
        }
        if ([self.meterReadingInfo.meter_condition containsString:@"3"] && [self.allPhotoArray containsObject:@""]) {
            [MYAlertAction showAlertWithTitle:@"请将图片添加完整" msg:nil chooseBlock:^(NSInteger buttonIdx) {
            } buttonsStatement:@"确定", nil];
            return ;
        }
        for (NSString *num in self.thisNumArray) {
            if ([num integerValue] < 0) {
                [MYAlertAction showAlertWithTitle:@"本次用量不能为负数，请检查" msg:nil chooseBlock:^(NSInteger buttonIdx) {
                } buttonsStatement:@"确定", nil];
                return ;
            }
        }
        
        
        [BXTGlobal showLoadingMBP:@"数据加载中..."];
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        if (self.thisValueArray.count == 6) {
            [request energyMeterRecordAddWithAboutID:self.transID
                                            totalNum:self.thisValueArray[5]
                                       peakPeriodNum:self.thisValueArray[1]
                                      flatSectionNum:self.thisValueArray[2]
                                    valleySectionNum:self.thisValueArray[3]
                                      peakSegmentNum:self.thisValueArray[4]
                                            totalPic:@""
                                       peakPeriodPic:self.allPhotoArray[1]
                                      flatSectionPic:self.allPhotoArray[2]
                                    valleySectionPic:self.allPhotoArray[3]
                                      peakSegmentPic:self.allPhotoArray[4]];
        }
        else if (self.thisValueArray.count == 5) {
            NSInteger peakValue = self.meterReadingInfo.last.peak_segment_num * [self.meterReadingInfo.rate integerValue];
            [request energyMeterRecordAddWithAboutID:self.transID
                                            totalNum:self.thisValueArray[4]
                                       peakPeriodNum:self.thisValueArray[1]
                                      flatSectionNum:self.thisValueArray[2]
                                    valleySectionNum:self.thisValueArray[3]
                                      peakSegmentNum:[NSString stringWithFormat:@"%ld", peakValue]
                                            totalPic:@""
                                       peakPeriodPic:self.allPhotoArray[1]
                                      flatSectionPic:self.allPhotoArray[2]
                                    valleySectionPic:self.allPhotoArray[3]
                                      peakSegmentPic:@""];
        }
        else {
            [request energyMeterRecordAddWithAboutID:self.transID
                                            totalNum:self.thisValueArray[1]
                                       peakPeriodNum:@""
                                      flatSectionNum:@""
                                    valleySectionNum:@""
                                      peakSegmentNum:@""
                                            totalPic:self.allPhotoArray[1]
                                       peakPeriodPic:@""
                                      flatSectionPic:@""
                                    valleySectionPic:@""
                                      peakSegmentPic:@""];
        }
    }];
    [self.footerView addSubview:commitBtn];
}

#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.thisValueArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BXTMeterReadingHeaderCell *cell = [BXTMeterReadingHeaderCell cellWithTableView:tableView];
        
        cell.meterReadingInfo = self.meterReadingInfo;
        
        return cell;
    }
    
    BXTMeterReadingListCell *cell = [BXTMeterReadingListCell cellWithTableView:tableView];
    
    // 初始化
    cell.titleView.text = self.cellTitleArray[indexPath.section];
    cell.NumTextField.text = self.thisValueArray[indexPath.section];
    cell.lastValueView.text = self.lastValueArray[indexPath.section];
    cell.lastNumView.text = self.lastNumArray[indexPath.section];
    cell.thisValueView.text = self.thisValueArray[indexPath.section];
    cell.thisNumView.text = self.thisNumArray[indexPath.section];
    [cell.addImageView setImage:self.allImageArray[indexPath.section] forState:UIControlStateNormal];
    if (indexPath.section == 5 - self.hidePeakValue) {
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
        if (![BXTGlobal isBlankString:text] && cell.NumTextField.tag == indexPath.section + 100) {
            NSInteger thisValue = [text integerValue] * [self.meterReadingInfo.rate integerValue];
            NSInteger thisNum = thisValue - [cell.lastValueView.text integerValue];
            cell.thisValueView.text = [NSString stringWithFormat:@"%ld", thisValue];
            cell.thisNumView.text = [NSString stringWithFormat:@"%ld", thisNum];
        }
        else { // 原因：总示数不变，其余textfield清除不会清空，
            if (indexPath.section != 5 - self.hidePeakValue) {
                cell.thisValueView.text = @"";
                cell.thisNumView.text = @"";
            }
        }
        [self.thisValueArray replaceObjectAtIndex:indexPath.section withObject:cell.thisValueView.text];
        [self.thisNumArray replaceObjectAtIndex:indexPath.section withObject:cell.thisNumView.text];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark MLImageCropDelegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    [self.allImageArray replaceObjectAtIndex:self.photoIndex withObject:cropImage];
    
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
        
        // price_type_id:   2-峰谷  OR   单一、阶梯
        if (![self.meterReadingInfo.price_type_id isEqualToString:@"2"]) {
            self.thisValueArray = [[NSMutableArray alloc] initWithObjects:@"0", @" ", nil];
            self.thisNumArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", nil];
            UIImage *saveImage = [UIImage imageNamed:@"Add_button"];
            self.allImageArray = [[NSMutableArray alloc] initWithObjects:saveImage, saveImage, nil];
            self.allPhotoArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", nil];
            self.cellTitleArray = @[@"", @"总示数："];
            self.lastValueArray = [[NSMutableArray alloc] initWithObjects:
                                   @"",
                                   [self transToString:lastList.total_num], nil];
            self.lastNumArray = [[NSMutableArray alloc] initWithObjects:
                                 @"",
                                 [self transToString:lastList.use_amount], nil];
        }
        else {  // 是否在尖峰期：0否 1是，只有当计价方式为峰谷的时候才需要该值
            if ([self.meterReadingInfo.is_peak_segment isEqualToString:@"1"]) {
                self.lastValueArray = [[NSMutableArray alloc] initWithObjects:
                                       @"",
                                       [self transToString:lastList.peak_period_num],
                                       [self transToString:lastList.flat_section_num],
                                       [self transToString:lastList.valley_section_num],
                                       [self transToString:lastList.peak_segment_num],
                                       [self transToString:lastList.total_num], nil];
                self.lastNumArray = [[NSMutableArray alloc] initWithObjects:
                                     @"",
                                     [self transToString:lastList.peak_period_amount],
                                     [self transToString:lastList.flat_section_amount],
                                     [self transToString:lastList.valley_section_amount],
                                     [self transToString:lastList.peak_segment_amount],
                                     [self transToString:lastList.use_amount], nil];
            }
            else {
                self.hidePeakValue = YES;
                self.thisValueArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @" ", nil];
                self.thisNumArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @"", nil];
                UIImage *saveImage = [UIImage imageNamed:@"Add_button"];
                self.allImageArray = [[NSMutableArray alloc] initWithObjects:saveImage, saveImage, saveImage,  saveImage, saveImage, nil];
                self.allPhotoArray = [[NSMutableArray alloc] initWithObjects:@"0", @"", @"", @"", @" ", nil];
                self.cellTitleArray = @[@"", @"峰段示数：", @"平段示数：", @"谷段示数：", @"总示数："];
                self.lastValueArray = [[NSMutableArray alloc] initWithObjects:
                                       @"",
                                       [self transToString:lastList.peak_period_num],
                                       [self transToString:lastList.flat_section_num],
                                       [self transToString:lastList.valley_section_num],
                                       [self transToString:lastList.total_num], nil];
                self.lastNumArray = [[NSMutableArray alloc] initWithObjects:
                                     @"",
                                     [self transToString:lastList.peak_period_amount],
                                     [self transToString:lastList.flat_section_amount],
                                     [self transToString:lastList.valley_section_amount],
                                     [self transToString:lastList.use_amount], nil];
            }
            
        }
        
        // check_type: 1-手动   2-自动(隐藏提交按钮)
        if ([self.meterReadingInfo.check_type isEqualToString:@"2"]) {
            [self.footerView removeFromSuperview];
            self.tableView.frame = CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT);
        }
    }
    else if (type == EnergyMeterRecordFile && [dic[@"returncode"] intValue] == 0)
    {
        for (NSDictionary *dataDict in data) {
            [self.allPhotoArray replaceObjectAtIndex:self.photoIndex withObject:dataDict[@"id"]];
        }
    }
    else if (type == EnergyMeterRecordAdd && [dic[@"returncode"] intValue] == 0)
    {
        [BXTGlobal showText:@"新建抄表成功" view:self.view completionBlock:^{
            if (self.delegateSignal) {
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

- (NSString *)transToString:(NSInteger)sender
{
    return [NSString stringWithFormat:@"%ld %@", sender, self.meterReadingInfo.unit];
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
