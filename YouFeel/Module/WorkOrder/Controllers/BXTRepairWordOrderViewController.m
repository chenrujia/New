//
//  BXTWorkOderViewController.m
//  BXT
//
//  Created by Jason on 15/8/31.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTRepairWordOrderViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTSettingTableViewCell.h"
#import "BXTRemarksTableViewCell.h"
#import "LocalPhotoViewController.h"
#import "UIImage+SubImage.h"
#import "BXTSelectBoxView.h"
#import "BXTFaultInfo.h"
#import "BXTFaultTypeInfo.h"
#import "BXTShopLocationViewController.h"
#import "HySideScrollingImagePicker.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "BXTAddOtherManViewController.h"
#import "BXTAddOtherManInfo.h"

#define MOBILE 11
#define CAUSE 12

@interface BXTRepairWordOrderViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectPhotoDelegate,BXTDataResponseDelegate,BXTBoxSelectedTitleDelegate,UITextFieldDelegate,MWPhotoBrowserDelegate,UIActionSheetDelegate>
{
    UITableView *currentTableView;
    NSString *repairState;
    NSMutableArray *selectPhotos;
    NSMutableArray *photosArray;
    BXTSelectBoxView *boxView;
    NSMutableArray *dep_dataSource;
    NSMutableArray *fau_dataSource;
    BXTFaultTypeInfo *fault_type_info;
    NSString *cause;
    NSString *notes;
    BXTFaultInfo *selectFaultInfo;
    BXTFaultTypeInfo *selectFaultTypeInfo;
    UIPickerView *pickView;
    BXTFloorInfo *defaultFloor;
    BXTFloorInfo *defaultArea;
    BXTShopInfo *defaultShop;
    NSInteger indexSection;
    NSMutableArray *manIDs;
}

@property (nonatomic ,strong) BXTFloorInfo *publicFloor;
@property (nonatomic ,strong) BXTAreaInfo *publicArea;
@property (nonatomic ,strong) NSMutableArray *mwPhotosArray;
@property (nonatomic ,strong) NSMutableArray *mans;

@end

@implementation BXTRepairWordOrderViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    manIDs = [NSMutableArray array];
    self.mans = [NSMutableArray array];
    [BXTGlobal shareGlobal].maxPics = 3;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"ChangeShopLocation" object:nil];
    
    repairState = @"1";
    photosArray = [[NSMutableArray alloc] init];
    selectPhotos = [[NSMutableArray alloc] init];
    dep_dataSource = [[NSMutableArray alloc] init];
    fau_dataSource = [[NSMutableArray alloc] init];
    
    /**请求故障类型列表**/
    BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
    [fau_request faultTypeList];
    
    [self navigationSetting:@"新建工单" andRightTitle:nil andRightImage:nil];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -
#pragma mark 初始化视图
- (void)createTableView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT)];
    currentTableView = [[UITableView alloc] initWithFrame:backView.bounds style:UITableViewStyleGrouped];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    [backView addSubview:currentTableView];
    [self.view addSubview:backView];
}

#pragma mark -
#pragma mark 事件处理
- (void)reloadTable
{
    [currentTableView reloadData];
}

- (void)selectFloorInfo:(BXTFloorInfo *)floor areaInfo:(BXTAreaInfo *)area
{
    _publicFloor = floor;
    _publicArea = area;
    [currentTableView reloadData];
}

- (void)createBoxView:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    if (section == 2)
    {
        boxView = [[BXTSelectBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f) boxTitle:@"部门" boxSelectedViewType:DepartmentView listDataSource:dep_dataSource markID:nil actionDelegate:self];
        
        [self.view addSubview:boxView];
        [UIView animateWithDuration:0.3f animations:^{
            [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH, 180.f)];
        }];
    }
    else if (section == 4)
    {
        pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        pickView.tag = 1000;
        pickView.showsSelectionIndicator = YES;
        pickView.backgroundColor = colorWithHexString(@"cdced1");
        pickView.dataSource = self;
        pickView.delegate = self;
        [self.view addSubview:pickView];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGR
{
    UIView *tapView = [tapGR view];
    [self loadMWPhotoBrowser:tapView.tag];
}

- (void)loadMWPhotoBrowser:(NSInteger)index
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (UIImage *image in photosArray)
    {
        MWPhoto *photo = [MWPhoto photoWithImage:image];
        [photos addObject:photo];
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
}

- (void)doneClick
{
    [self createNewWorkOrder:manIDs];
}

- (void)repairClick
{
    if (IS_IOS_8)
    {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertCtr addAction:alertAction];
        __weak BXTRepairWordOrderViewController *weakSelf = self;
        UIAlertAction *needAction = [UIAlertAction actionWithTitle:@"需要增援" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            BXTAddOtherManViewController *addOtherManVC = [[BXTAddOtherManViewController alloc] initWithRepairID:0 andWithVCType:RepairType];
            [addOtherManVC didChoosedMans:^(NSMutableArray *mans) {
                [weakSelf handleMansArray:mans];
            }];
            [weakSelf.navigationController pushViewController:addOtherManVC animated:YES];
        }];
        [alertCtr addAction:needAction];
        UIAlertAction *notNeedAction = [UIAlertAction actionWithTitle:@"不需要增援" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf handleMansArray:[NSMutableArray array]];
        }];
        [alertCtr addAction:notNeedAction];
        [self presentViewController:alertCtr animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"需要增援",@"不需要增援", nil];
        [self.view addSubview:sheet];
    }
}

- (void)handleMansArray:(NSMutableArray *)array
{
    self.mans = array;
    indexSection = 1;
    [currentTableView reloadData];
}

- (void)createNewWorkOrder:(NSArray *)array
{
    /**请求新建工单**/
    BXTDataRequest *rep_request = [[BXTDataRequest alloc] initWithDelegate:self];
    BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
    
    [rep_request createRepair:[NSString stringWithFormat:@"%ld",(long)selectFaultTypeInfo.fau_id] faultCause:cause faultLevel:repairState depatmentID:departmentInfo.dep_id floorInfoID:_publicFloor.area_id areaInfoId:_publicArea.place_id shopInfoID:@"" equipment:@"0" faultNotes:notes imageArray:photosArray repairUserArray:array];
}

- (void)stateClick:(UIButton *)btn
{
    BXTSettingTableViewCell *cell = (BXTSettingTableViewCell *)btn.superview;
    if (btn.tag == 11)
    {
        repairState = @"1";
        cell.emergencyBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        cell.normelBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
    }
    else if (btn.tag == 12)
    {
        repairState = @"2";
        cell.emergencyBtn.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        cell.normelBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    }
}

/**
 *  选择相册图片
 */
- (void)addImages
{
    HySideScrollingImagePicker *hy = [[HySideScrollingImagePicker alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"拍摄",@"从相册选择"]];
    hy.isMultipleSelection = NO;
    
    hy.SeletedImages = ^(NSArray *GetImages, NSInteger Buttonindex){
        
        switch (Buttonindex) {
            case 1:
            {
                if (GetImages.count != 0)
                {
                    [selectPhotos removeAllObjects];
                    [photosArray removeAllObjects];
                    //取原图
                    [selectPhotos addObjectsFromArray:GetImages];
                    [self selectImages];
                }
                else
                {
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
                    {
                        if (IS_IOS_8)
                        {
                            UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请为报修通开放相机权限：手机设置->隐私->相机->报修通（打开）" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                            [alertCtr addAction:alertAction];
                            [self presentViewController:alertCtr animated:YES completion:nil];
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法启动相机"
                                                                            message:@"请为报修通开放相机权限：手机设置->隐私->相机->报修通（打开）"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                    else
                    {
                        [self selectCamenaType:UIImagePickerControllerSourceTypeCamera];
                    }
                }
            }
                break;
            case 2:
            {
                LocalPhotoViewController *pick=[[LocalPhotoViewController alloc] init];
                pick.selectPhotoDelegate = self;
                pick.selectPhotos = selectPhotos;
                [self.navigationController pushViewController:pick animated:YES];
                self.navigationController.navigationBar.hidden = NO;
            }
                break;
            default:
                break;
        }
    };
    
    [self.view addSubview:hy];
}

- (void)selectCamenaType:(NSInteger)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //设置相机支持的类型，拍照和录像
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)selectImages
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:7];
    BXTRemarksTableViewCell *cell = (BXTRemarksTableViewCell *)[currentTableView cellForRowAtIndexPath:indexPath];
    if (selectPhotos.count == 1)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            
        } completion:nil];
    }
    else if (selectPhotos.count == 2)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        [self resetDatasource:cell arrayWithIndex:1];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:cell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            
        } completion:nil];
    }
    else if (selectPhotos.count == 3)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        [self resetDatasource:cell arrayWithIndex:1];
        [self resetDatasource:cell arrayWithIndex:2];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:cell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            [self resetFrame:cell arrayWithIndex:2 withValue:(IMAGEWIDTH + 10.f) * 3];
            
        } completion:nil];
    }
}

#pragma mark -
#pragma mark 代理
/**
 *  UITableViewDelegate & UITableViewDatasource
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 7 + indexSection)
    {
        return 80.f;
    }
    
    return 5.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 7 + indexSection)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.f)];
        view.backgroundColor = [UIColor clearColor];
        
        CGFloat width = (SCREEN_WIDTH - 60.f)/2.f;
        CGFloat x = 40.f + width;
        
        UIButton *repairBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        repairBtn.frame = CGRectMake(20, 20, width, 50.f);
        [repairBtn setTitle:@"我来修" forState:UIControlStateNormal];
        [repairBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [repairBtn setBackgroundColor:colorWithHexString(@"aac3e1")];
        repairBtn.layer.masksToBounds = YES;
        repairBtn.layer.cornerRadius = 4.f;
        [repairBtn addTarget:self action:@selector(repairClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:repairBtn];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(x, 20, width, 50.f);
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [doneBtn setBackgroundColor:colorWithHexString(@"aac3e1")];
        doneBtn.layer.masksToBounds = YES;
        doneBtn.layer.cornerRadius = 4.f;
        [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:doneBtn];
        
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.f)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 7)
    {
        return 170;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8 + indexSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 7)
    {
        BXTRemarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkCell"];
        if (!cell)
        {
            cell = [[BXTRemarksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RemarkCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.remarkTV.delegate = self;
        cell.titleLabel.text = @"备   注";
        
        UITapGestureRecognizer *tapGROne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [cell.imgViewOne addGestureRecognizer:tapGROne];
        UITapGestureRecognizer *tapGRTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [cell.imgViewTwo addGestureRecognizer:tapGRTwo];
        UITapGestureRecognizer *tapGRThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [cell.imgViewThree addGestureRecognizer:tapGRThree];
        [cell.addBtn addTarget:self action:@selector(addImages) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepairCell"];
        if (!cell)
        {
            cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepairCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.detailLable.hidden = NO;
        cell.detailTF.hidden = YES;
        if (indexPath.section == 0)
        {
            cell.titleLabel.text = @"姓   名";
            cell.detailLable.text = [BXTGlobal getUserProperty:U_NAME];
            cell.checkImgView.hidden = NO;
        }
        else if (indexPath.section == 1)
        {
            cell.titleLabel.text = @"手机号";
            cell.detailLable.hidden = YES;
            cell.detailTF.hidden = NO;
            cell.detailTF.keyboardType = UIKeyboardTypeNumberPad;
            if ([BXTGlobal getUserProperty:U_MOBILE])
            {
                cell.detailTF.text = [BXTGlobal getUserProperty:U_MOBILE];
            }
            else
            {
                cell.detailTF.tag = MOBILE;
                cell.detailTF.delegate = self;
                cell.detailTF.placeholder = @"请输入您的回访号";
                [cell.detailTF setValue:colorWithHexString(@"909497") forKeyPath:@"_placeholderLabel.textColor"];
                [cell.detailTF setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
            }
        }
        else if (indexPath.section == 2)
        {
            BXTDepartmentInfo *departmentInfo = [BXTGlobal getUserProperty:U_DEPARTMENT];
            cell.titleLabel.text = @"部   门";
            if (departmentInfo)
            {
                cell.detailLable.text = departmentInfo.department;
            }
            else
            {
                cell.detailLable.text = @"请选择您所在部门";
            }
            cell.checkImgView.hidden = NO;
            cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
            cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
        }
        if (indexPath.section == 3)
        {
            cell.titleLabel.text = @"位   置";
            if (_publicFloor && _publicArea)
            {
                cell.detailLable.text = [NSString stringWithFormat:@"%@ %@",_publicFloor.area_name,_publicArea.place_name];
            }
            else
            {
                cell.detailLable.text = @"请选择您要报修的具体位置";
            }
            
            cell.checkImgView.hidden = NO;
            cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
            cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
        }
        else if (indexPath.section == 4)
        {
            cell.titleLabel.text = @"故   障";
            if (!selectFaultInfo)
            {
                cell.detailLable.text = @"请选择故障类型";
            }
            else
            {
                cell.detailLable.frame = CGRectMake(CGRectGetMaxX(cell.titleLabel.frame) + 20.f, 10., 80.f, 30);
                cell.detailLable.text = [NSString stringWithFormat:@"%@-%@",selectFaultInfo.faulttype_type,selectFaultTypeInfo.faulttype];
            }
            cell.checkImgView.hidden = NO;
            cell.checkImgView.frame = CGRectMake(SCREEN_WIDTH - 13.f - 15.f, 17.75f, 8.5f, 14.5f);
            cell.checkImgView.image = [UIImage imageNamed:@"Arrow-right"];
        }
        else if (indexPath.section == 5)
        {
            cell.titleLabel.text = @"描   述";
            cell.detailLable.hidden = YES;
            cell.detailTF.hidden = NO;
            cell.detailTF.keyboardType = UIKeyboardTypeDefault;
            if (cause)
            {
                cell.detailTF.text = cause;
            }
            else
            {
                cell.detailTF.tag = CAUSE;
                cell.detailTF.delegate = self;
                cell.detailTF.placeholder = @"请输入故障原因";
                [cell.detailTF setValue:colorWithHexString(@"909497") forKeyPath:@"_placeholderLabel.textColor"];
                [cell.detailTF setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
            }
        }
        else if (indexPath.section == 6)
        {
            cell.titleLabel.text = @"等   级";
            cell.emergencyBtn.hidden = NO;
            cell.normelBtn.hidden = NO;
            [cell.emergencyBtn addTarget:self action:@selector(stateClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.normelBtn addTarget:self action:@selector(stateClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (indexPath.section == 8)
        {
            cell.titleLabel.text = @"维修员";
            [manIDs removeAllObjects];
            [manIDs addObject:[BXTGlobal getUserProperty:U_BRANCHUSERID]];
            NSMutableArray *manNames = [NSMutableArray arrayWithObjects:[BXTGlobal getUserProperty:U_NAME], nil];
            for (BXTAddOtherManInfo *otherMan in _mans)
            {
                [manNames addObject:otherMan.name];
                [manIDs addObject:[NSString stringWithFormat:@"%ld",(long)otherMan.manID]];
            }
            NSString *strName = [manNames componentsJoinedByString:@"、"];
            cell.detailLable.text = strName;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        __weak BXTRepairWordOrderViewController *weakSelf = self;
        BXTShopLocationViewController *shopLocationVC = [[BXTShopLocationViewController alloc] initWithPublic:YES changeArea:^(BXTFloorInfo *floorInfo, BXTAreaInfo *areaInfo) {
            [weakSelf selectFloorInfo:floorInfo areaInfo:areaInfo];
        }];
        [self.navigationController pushViewController:shopLocationVC animated:YES];
    }
    if (indexPath.section == 4)
    {
        [self createBoxView:4];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        if (pickView)
        {
            [pickView removeFromSuperview];
            pickView = nil;
            [currentTableView reloadData];
        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
            } completion:^(BOOL finished) {
                [boxView removeFromSuperview];
                boxView = nil;
            }];
        }
        [view removeFromSuperview];
    }
}

/**
 *  UITextViewDelegate
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == MOBILE)
    {
        [BXTGlobal setUserProperty:textField.text withKey:U_MOBILE];
    }
    else if (textField.tag == CAUSE)
    {
        cause = textField.text;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入报修内容"])
    {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    notes = textView.text;
    if (textView.text.length < 1)
    {
        textView.text = @"请输入报修内容";
    }
}

/**
 *  SelectPhotoDelegate
 */
- (void)getSelectedPhoto:(NSMutableArray *)photos
{
    selectPhotos = photos;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:7];
    BXTRemarksTableViewCell *cell = (BXTRemarksTableViewCell *)[currentTableView cellForRowAtIndexPath:indexPath];
    if (photos.count == 1)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            
        } completion:nil];
    }
    else if (photos.count == 2)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        [self resetDatasource:cell arrayWithIndex:1];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:cell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            
        } completion:nil];
    }
    else if (photos.count == 3)
    {
        [self resetCell:cell];
        [self resetDatasource:cell arrayWithIndex:0];
        [self resetDatasource:cell arrayWithIndex:1];
        [self resetDatasource:cell arrayWithIndex:2];
        
        [UIView animateWithDuration:1.f animations:^{
            
            [self resetFrame:cell arrayWithIndex:0 withValue:IMAGEWIDTH + 10.f];
            [self resetFrame:cell arrayWithIndex:1 withValue:(IMAGEWIDTH + 10.f) * 2];
            [self resetFrame:cell arrayWithIndex:2 withValue:(IMAGEWIDTH + 10.f) * 3];
            
        } completion:nil];
    }
}

- (void)resetCell:(BXTRemarksTableViewCell *)cell
{
    [cell.imgViewOne setFrame:cell.addBtn.frame];
    [cell.imgViewTwo setFrame:cell.addBtn.frame];
    [cell.imgViewThree setFrame:cell.addBtn.frame];
    
    cell.imgViewOne.image = nil;
    cell.imgViewTwo.image = nil;
    cell.imgViewThree.image = nil;
}

- (void)resetDatasource:(BXTRemarksTableViewCell *)cell arrayWithIndex:(NSInteger)index
{
    id obj = [selectPhotos objectAtIndex:index];
    UIImage *newImage = nil;
    if ([obj isKindOfClass:[UIImage class]])
    {
        UIImage *tempImg = (UIImage *)obj;
        newImage = tempImg;
    }
    else
    {
        ALAsset *asset = (ALAsset *)obj;
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef posterImageRef = [representation fullScreenImage];
        UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef scale:[representation scale] orientation:UIImageOrientationUp];
        newImage = posterImage;
    }
    [cell.photosArray addObject:newImage];
    [photosArray addObject:newImage];
    
    if (index == 0)
    {
        cell.imgViewOne.image = newImage;
    }
    else if (index == 1)
    {
        cell.imgViewTwo.image = newImage;
    }
    else if (index == 2)
    {
        cell.imgViewThree.image = newImage;
    }
}

- (void)resetFrame:(BXTRemarksTableViewCell *)cell arrayWithIndex:(NSInteger)index withValue:(CGFloat)space
{
    CGRect rect = cell.imgViewOne.frame;
    rect.origin.x = CGRectGetMinX(cell.addBtn.frame) + space;
    
    if (index == 0)
    {
        cell.imgViewOne.frame = rect;
    }
    else if (index == 1)
    {
        cell.imgViewTwo.frame = rect;
    }
    else if (index == 2)
    {
        cell.imgViewThree.frame = rect;
    }
}

/**
 *  BXTDataResponseDelegate
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == DepartmentType)
    {
        if (data.count)
        {
            for (NSDictionary *dictionary in data)
            {
                DCParserConfiguration *config = [DCParserConfiguration configuration];
                DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"dep_id" onClass:[BXTDepartmentInfo class]];
                [config addObjectMapping:text];
                DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTDepartmentInfo class] andConfiguration:config];
                BXTDepartmentInfo *departmentInfo = [parser parseDictionary:dictionary];
                
                [dep_dataSource addObject:departmentInfo];
            }
        }
    }
    else if (type == FaultType)
    {
        for (NSDictionary *dictionary in data)
        {
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            DCObjectMapping *text = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"fault_id" onClass:[BXTFaultInfo class]];
            [config addObjectMapping:text];
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTFaultInfo class] andConfiguration:config];
            BXTFaultInfo *faultObj = [parser parseDictionary:dictionary];
            
            NSMutableArray *fault_subs = [NSMutableArray array];
            NSArray *places = [dictionary objectForKey:@"sub_data"];
            
            for (NSDictionary *placeDic in places)
            {
                DCParserConfiguration *fault_type_config = [DCParserConfiguration configuration];
                DCObjectMapping *fault_type_map = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"fau_id" onClass:[BXTFaultTypeInfo class]];
                [fault_type_config addObjectMapping:fault_type_map];
                DCKeyValueObjectMapping *fault_type_parser = [DCKeyValueObjectMapping mapperForClass:[BXTFaultTypeInfo class] andConfiguration:fault_type_config];
                BXTFaultTypeInfo *faultTypeObj = [fault_type_parser parseDictionary:placeDic];
                [fault_subs addObject:faultTypeObj];
            }
            
            faultObj.sub_data = fault_subs;
            [fau_dataSource addObject:faultObj];
        }
        
        if (fau_dataSource.count > 0)
        {
            selectFaultInfo = fau_dataSource[0];
            NSArray *faultTypesArray = selectFaultInfo.sub_data;
            selectFaultTypeInfo = faultTypesArray[0];
        }
    }
    if (type == CreateRepair)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestRepairList" object:nil];
            [self showMBP:@"新工单已创建！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (void)requestError:(NSError *)error
{
    
}

/**
 *  BXTBoxSelectedTitleDelegate
 */
- (void)boxSelectedObj:(id)obj selectedType:(BoxSelectedType)type
{
    if (type == FaultInfoView)
    {
        fault_type_info = obj;
    }
    [currentTableView reloadData];
    
    UIView *view = [self.view viewWithTag:101];
    [view removeFromSuperview];
    
    [UIView animateWithDuration:0.3f animations:^{
        [boxView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180.f)];
    } completion:^(BOOL finished) {
        [boxView removeFromSuperview];
        boxView = nil;
    }];
}

/**
 *  UIPickerViewDelegate
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return fau_dataSource.count;
    }
    return selectFaultInfo.sub_data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        BXTFaultInfo *faultInfo = fau_dataSource[row];
        return faultInfo.faulttype_type;
    }
    
    BXTFaultTypeInfo *faultTypeInfo = selectFaultInfo.sub_data[row];
    return faultTypeInfo.faulttype;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        selectFaultInfo = fau_dataSource[row];
        NSArray *faultTypesArray = selectFaultInfo.sub_data;
        selectFaultTypeInfo = faultTypesArray[0];
        [pickerView reloadComponent:1];
    }
    else
    {
        NSArray *faultTypesArray = selectFaultInfo.sub_data;
        selectFaultTypeInfo = faultTypesArray[row];
    }
}

/**
 *  UIImagePickerControllerDelegate
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (headImage != nil)
    {
        headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        __weak BXTRepairWordOrderViewController *weakSelf = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [selectPhotos addObject:headImage];
            [weakSelf selectImages];
        }];
    }
    else
    {
        NSURL *path = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        [self loadImageFromAssertByUrl:path completion:^(UIImage * img)
         {
             __weak BXTRepairWordOrderViewController *weakSelf = self;
             [picker dismissViewControllerAnimated:YES completion:^{
                 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                 [selectPhotos addObject:img];
                 [weakSelf selectImages];
             }];
         }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        picker.delegate = nil;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

//有的图片在Ipad的情况下
- (void)loadImageFromAssertByUrl:(NSURL *)url completion:(void (^)(UIImage *))completion{
    
    __block UIImage* img;
    
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)
     {
         ALAssetRepresentation *rep = [asset defaultRepresentation];
         Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
         NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned int)rep.size error:nil];
         NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
         img = [UIImage imageWithData:data];
         completion(img);
     } failureBlock:^(NSError *err) {
         NSLog(@"Error: %@",[err localizedDescription]);
     }];
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

/**
 *  UIActionSheetDelegate
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        __weak BXTRepairWordOrderViewController *weakSelf = self;
        BXTAddOtherManViewController *addOtherManVC = [[BXTAddOtherManViewController alloc] initWithRepairID:0 andWithVCType:RepairType];
        [addOtherManVC didChoosedMans:^(NSMutableArray *mans) {
            [weakSelf handleMansArray:mans];
        }];
        [self.navigationController pushViewController:addOtherManVC animated:YES];
    }
    else
    {
        [self handleMansArray:[NSMutableArray array]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
