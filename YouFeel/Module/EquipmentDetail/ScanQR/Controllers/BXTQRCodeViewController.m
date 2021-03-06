//
//  QRCodeViewController.m
//  MyFramework
//
//  Created by 满孝意 on 15/12/22.
//  Copyright © 2015年 满孝意. All rights reserved.
//

#import "BXTQRCodeViewController.h"
#import "MYAlertAction.h"
#import "BXTDataRequest.h"
#import "BXTEquipmentViewController.h"
#import "BXTNewWorkOrderViewController.h"
#import "BXTMeterReadingRecordViewController.h"
#import "BXTGlobal.h"

@interface BXTQRBaseViewController () <BXTDataResponseDelegate>

@end

@implementation BXTQRCodeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"扫一扫" andRightTitle:nil andRightImage:nil];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isQQSimulator)
    {
        [self drawTitle];
        [self drawBottomItems];
        [self.view bringSubviewToFront:_topTitle];
    }
    else
    {
        _topTitle.hidden = YES;
    }
}

#pragma mark -
#pragma mark -  提示文字
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 120);
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}

#pragma mark -
#pragma mark - 底部功能项
- (void)drawBottomItems
{
    if (_bottomItemsView)
    {
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-100, CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    @weakify(self);
    [[_btnFlash rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //开关闪光灯
        [super openOrCloseFlash];
        if (self.isOpenFlash)
        {
            [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
        }
    }];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [[_btnPhoto rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //打开相册
        if ([LBXScanWrapper isGetPhotoPermission])
        {
            [self openLocalPhoto];
        }
        else
        {
            [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
        }
    }];
    
    [_bottomItemsView addSubview:_btnFlash];
}

#pragma mark -
#pragma mark - 扫描结果
- (void)showError:(NSString*)str
{
    [MYAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    LBXScanResult *scanResult = array[0];
    NSString*strResult = scanResult.strScanned;
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult)
    {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult)
    {
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [MYAlertAction showAlertWithTitle:@"扫码内容" msg:strResult chooseBlock:^(NSInteger buttonIdx) {
        //点击完，继续扫码
        [weakSelf reStartDevice];
    } buttonsStatement:@"知道了",nil];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    [BXTGlobal showLoadingMBP:@"加载中..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request scanResultWithContent:strResult.strScanned];
}

#pragma mark -
#pragma mark - getDataResource
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
    NSDictionary *dic = (NSDictionary *)response;
    NSLog(@"扫描结果：%@",dic);
    NSArray *data = [dic objectForKey:@"data"];
    if ([dic[@"returncode"] integerValue] == 0)
    {
        if (data.count > 0)
        {
            NSDictionary *dict = data[0];
            /** ---- meter_id为空 - 请扫描正确的计量表 ---- */
            if (self.pushType == ReturnVCTypeOFMeterReadingCreate)
            {
                if ([BXTGlobal isBlankString:dic[@"meter_id"]] || [dic[@"meter_lock"] integerValue] == 0)
                {
                    [MYAlertAction showAlertWithTitle:@"请扫描正确的计量表" msg:nil chooseBlock:^(NSInteger buttonIdx) {
                        if (buttonIdx == 0)
                        {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            [self reStartDevice];
                        }
                    } buttonsStatement:@"返回", @"重试", nil];
                }
                else if (self.delegateSignal)
                {
                    [self.delegateSignal sendNext:dic[@"meter_id"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                return;
            }
            else if (self.pushType == ReturnVCTypeOFMeterReading)
            {
                if ([BXTGlobal isBlankString:dic[@"meter_id"]] || [dic[@"meter_lock"] integerValue] == 0)
                {
                    [MYAlertAction showAlertWithTitle:@"请扫描正确的计量表" msg:nil chooseBlock:^(NSInteger buttonIdx) {
                        if (buttonIdx == 0)
                        {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            [self reStartDevice];
                        }
                    } buttonsStatement:@"返回", @"重试", nil];
                    return;
                }
                BXTMeterReadingRecordViewController *mrrvc = [[BXTMeterReadingRecordViewController alloc] init];
                mrrvc.transID = dic[@"meter_id"];
                [BXTGlobal shareGlobal].energyType = [dic[@"meter_type"] integerValue];
                mrrvc.unlocked = YES;
                mrrvc.delegateSignal = [RACSubject subject];
                [self.navigationController pushViewController:mrrvc animated:YES];
                return;
            }
            else
            {
                [MYAlertAction showActionSheetWithTitle:nil message:nil chooseBlock:^(NSInteger buttonIdx) {
                    if (buttonIdx == 1)
                    {
                        BXTEquipmentViewController *epvc = [[BXTEquipmentViewController alloc] initWithDeviceID:dict[@"qr_content"] orderID:nil];
                        epvc.pushType = PushType_Scan;
                        [self.navigationController pushViewController:epvc animated:YES];
                    }
                    else if (buttonIdx == 2)
                    {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutOrder" bundle:nil];
                        BXTNewWorkOrderViewController *newVC = (BXTNewWorkOrderViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BXTNewWorkOrderViewController"];
                        newVC.isNewWorkOrder = YES;
                        NSArray *qr_moreArray = dict[@"qr_more"];
                        NSDictionary *transDict = qr_moreArray[0];
                        NSDictionary *finalDict = @{@"deviceName":  [NSString stringWithFormat:@"%@\r%@", transDict[@"name"], transDict[@"code_number"]],
                                                    @"deviceID": [NSString stringWithFormat:@"%@", transDict[@"id"]],
                                                    @"placeName": [NSString stringWithFormat:@"%@", transDict[@"place_name"]],
                                                    @"placeID": [NSString stringWithFormat:@"%@", transDict[@"place_id"]]};
                        [newVC deviceInfoWithDictionary:finalDict];
                        [self.navigationController pushViewController:newVC animated:YES];
                    }
                    else
                    {
                        [self reStartDevice];
                    }
                } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@"查看设备详情", @"设备报修", nil];
            }
        }
    }
    else
    {
        /** ----  默认ReturnVCTypeOFOther
         002 - 请扫描正确的设备  ---- */
        NSString *titleStr = @"扫描结果无效，请重试";
        if (self.pushType == ReturnVCTypeOFMeterReadingCreate || self.pushType == ReturnVCTypeOFMeterReading)
        {
            titleStr = @"请扫描正确的设备";
        }
        
        [MYAlertAction showAlertWithTitle:titleStr msg:nil chooseBlock:^(NSInteger buttonIdx) {
            if (buttonIdx == 0)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self reStartDevice];
            }
        } buttonsStatement:@"返回", @"重试", nil];
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [BXTGlobal hideMBP];
}

@end
