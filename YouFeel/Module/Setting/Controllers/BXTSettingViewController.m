//
//  BXTSettingViewController.m
//  BXT
//
//  Created by Jason on 15/8/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "BXTSettingViewController.h"
#import "BXTHeaderFile.h"
#import "BXTSettingTableViewCell.h"
#import "BXTAuditerTableViewCell.h"
#import "BXTLoginViewController.h"
#import "AppDelegate.h"
#import "BXTPostionInfo.h"
#import "HySideScrollingImagePicker.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "BXTDataRequest.h"
#import "UIImageView+WebCache.h"
#import "LocalPhotoViewController.h"
#import "UINavigationController+YRBackGesture.h"
#import "BXTHeadquartersInfo.h"
#import "ANKeyValueTable.h"

static NSString *settingCellIndentify = @"settingCellIndentify";

@interface BXTSettingViewController ()<UITableViewDataSource,UITableViewDelegate,BXTDataResponseDelegate,MWPhotoBrowserDelegate,SelectPhotoDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *currentTableView;
    NSMutableArray *selectPhotos;
    NSString *verify_state;
    NSString *checks_user;
    NSString *checks_user_department;
    BOOL isRepair;
    BOOL isHaveChecker;
    NSDictionary *checkUserDic;
}

@property (nonatomic ,strong) NSMutableArray *mwPhotosArray;

@end

@implementation BXTSettingViewController

- (instancetype)initWithIsRepair:(BOOL)repair
{
    self = [super init];
    if (self)
    {
        isRepair = repair;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [BXTGlobal shareGlobal].maxPics = 1;
    selectPhotos = [NSMutableArray array];
    [self navigationSetting:@"设置" andRightTitle:nil andRightImage:nil];
    [self initContentViews];
    //获取用户信息
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request userInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:YES];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -
#pragma mark 初始化视图
- (void)initContentViews
{
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT) style:UITableViewStyleGrouped];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    currentTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:currentTableView];
}

#pragma mark -
#pragma mark 事件处理
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
                    //取原图
                    [selectPhotos addObjectsFromArray:GetImages];
                    [self handleImage];
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
            }
                break;
            default:
                break;
        }
    };
    
    [self.view addSubview:hy];
}

- (void)handleImage
{
    id obj = [selectPhotos objectAtIndex:0];
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

    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request uploadHeaderImage:newImage];
}

- (void)quitOutClick
{
    [[RCIM sharedRCIM] disconnect];
//    ANKeyValueData *data = [[ANKeyValueTable userDefaultTable] keyValueData];
//    [data removeAllValues];
    [[ANKeyValueTable userDefaultTable] clear];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    BXTLoginViewController *loginVC = [[BXTLoginViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navigation.navigationBar.hidden = YES;
    navigation.enableBackGesture = YES;
    [AppDelegate appdelegete].window.rootViewController = navigation;
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

- (void)contactTa
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [checkUserDic objectForKey:@"checks_user_out_userid"];
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID]) return;
    
    userInfo.name = [checkUserDic objectForKey:@"checks_user"];
    userInfo.portraitUri = [checkUserDic objectForKey:@"checks_user_pic"];
    
    NSMutableArray *usersArray = [BXTGlobal getUserProperty:U_USERSARRAY];
    if (usersArray)
    {
        NSArray *arrResult = [usersArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.userId = %@",userInfo.userId]];
        if (arrResult.count)
        {
            RCUserInfo *temp_userInfo = arrResult[0];
            NSInteger index = [usersArray indexOfObject:temp_userInfo];
            [usersArray replaceObjectAtIndex:index withObject:temp_userInfo];
        }
        else
        {
            [usersArray addObject:userInfo];
        }
    }
    else
    {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:userInfo];
        [BXTGlobal setUserProperty:array withKey:U_USERSARRAY];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveConnact" object:nil];
    [[BXTGlobal shareGlobal] enableForIQKeyBoard:NO];
    
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = userInfo.userId;
    conversationVC.userName = userInfo.name;
    conversationVC.title = userInfo.name;
    [self.navigationController pushViewController:conversationVC animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -
#pragma mark 代理

/**
 *  UITableViewDelegate & UITableViewDatasource
 */
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 16.f;//section头部高度
    }
    return 10.f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16.f)];
    }
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        if (!isHaveChecker)
        {
           return 100.f;
        }
        return 40.f;
    }
    else if (section == 4 && isHaveChecker)
    {
        return 100.f;
    }
    return 5.f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        if (!isHaveChecker)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.f)];
            view.backgroundColor = [UIColor clearColor];
            
            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20.f)];
            titleLable.font = [UIFont systemFontOfSize:11.f];
            titleLable.textColor = colorWithHexString(@"909497");
            titleLable.textAlignment = NSTextAlignmentCenter;
            titleLable.text = @"注意：修改以上身份信息均需要再次提交审核，方可修改成功。";
            [view addSubview:titleLable];
            
            UIButton *quitOut = [UIButton buttonWithType:UIButtonTypeCustom];
            quitOut.frame = CGRectMake(20, 40, SCREEN_WIDTH - 40, 50.f);
            [quitOut setTitle:@"退出登录" forState:UIControlStateNormal];
            [quitOut setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
            [quitOut setBackgroundColor:colorWithHexString(@"aac3e1")];
            quitOut.layer.masksToBounds = YES;
            quitOut.layer.cornerRadius = 6.f;
            [quitOut addTarget:self action:@selector(quitOutClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:quitOut];
            
            return view;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.f)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20.f)];
        titleLable.font = [UIFont systemFontOfSize:11.f];
        titleLable.textColor = colorWithHexString(@"909497");
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = @"注意：修改以上身份信息均需要再次提交审核，方可修改成功。";
        [view addSubview:titleLable];
        
        return view;
    }
    else if (section == 4 && isHaveChecker)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.f)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *quitOut = [UIButton buttonWithType:UIButtonTypeCustom];
        quitOut.frame = CGRectMake(20, 25, SCREEN_WIDTH - 40, 50.f);
        [quitOut setTitle:@"退出登录" forState:UIControlStateNormal];
        [quitOut setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        [quitOut setBackgroundColor:colorWithHexString(@"aac3e1")];
        quitOut.layer.masksToBounds = YES;
        quitOut.layer.cornerRadius = 6.f;
        [quitOut addTarget:self action:@selector(quitOutClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:quitOut];
        
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
    if (indexPath.section == 0)
    {
        return 100.f;
    }
    else if (indexPath.section == 4 && isHaveChecker)
    {
        return 124.f;
    }
    return 50.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isHaveChecker)
    {
        return 5;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        if (isRepair)
        {
            return 2;
        }
        return 3;
    }
    else if (section == 3)
    {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 && isHaveChecker)
    {
        BXTAuditerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuditerCell"];
        if (!cell)
        {
            cell = [[BXTAuditerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AuditerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.auditNameLabel.text = checks_user;
            cell.positionLabel.text = checks_user_department;
            [cell.contactBtn addTarget:self action:@selector(contactTa) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    else
    {
        BXTSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        if (!cell)
        {
            cell = [[BXTSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailLable.textAlignment = NSTextAlignmentLeft;
        }
        
        if (indexPath.section == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailLable.hidden = YES;
            cell.checkImgView.hidden = YES;
            CGRect titleRect = cell.titleLabel.frame;
            titleRect.origin.y = 40.f;
            [cell.titleLabel setFrame:titleRect];
            cell.titleLabel.text = @"头像";
            cell.headImageView.hidden = NO;
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[BXTGlobal getUserProperty:U_HEADERIMAGE]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
        }
        else if (indexPath.section == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailLable.hidden = NO;
            cell.checkImgView.hidden = NO;
            cell.detailLable.frame = CGRectMake(100.f, 15.f, SCREEN_WIDTH - 100.f, 20);
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"手机号";
                cell.detailLable.text = [BXTGlobal getUserProperty:U_USERNAME];
            }
            else if (indexPath.row == 1)
            {
                cell.titleLabel.text = @"姓   名";
                cell.detailLable.text = [BXTGlobal getUserProperty:U_NAME];
            }
            else
            {
                cell.titleLabel.text = @"性   别";
                if ([[BXTGlobal getUserProperty:U_SEX] isEqualToString:@"1"])
                {
                    cell.detailLable.text = @"男";
                }
                else
                {
                    cell.detailLable.text = @"女";
                }
            }
        }
        else if (indexPath.section == 2)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailLable.hidden = NO;
            cell.titleLabel.frame = CGRectMake(15.f, 15.f, 60.f, 20);
            cell.detailLable.frame = CGRectMake(100.f, 15.f, SCREEN_WIDTH - 100.f - 100.f, 20);
            [cell.auditStatusLabel setFrame:CGRectMake(CGRectGetMaxX(cell.detailLable.frame) + 20.f, 15.f, 80.f, 20.f)];
            cell.auditStatusLabel.text = verify_state;
            if (isRepair)
            {
                if (indexPath.row == 0)
                {
                    cell.titleLabel.text = @"部   门";
                    BXTDepartmentInfo *department = [BXTGlobal getUserProperty:U_DEPARTMENT];
                    cell.detailLable.text = department.department;
                }
                else
                {
                    cell.titleLabel.text = @"分   组";
                    BXTGroupingInfo *group = [BXTGlobal getUserProperty:U_GROUPINGINFO];
                    cell.detailLable.text = group.subgroup;
                }
            }
            else
            {
                if (indexPath.row == 0)
                {
                    cell.titleLabel.text = @"位   置";
                    BXTHeadquartersInfo *company = [BXTGlobal getUserProperty:U_COMPANY];
                    cell.detailLable.text = company.name;
                }
                else if (indexPath.row == 1)
                {
                    cell.titleLabel.text = @"部   门";
                    BXTDepartmentInfo *department = [BXTGlobal getUserProperty:U_DEPARTMENT];
                    cell.detailLable.text = department.department;
                }
                else
                {
                    cell.titleLabel.text = @"商   店";
                    BXTShopInfo *shopInfo = [BXTGlobal getUserProperty:U_SHOP];
                    cell.detailLable.text = shopInfo.stores_name;
                }
            }
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailLable.hidden = NO;
            cell.titleLabel.frame = CGRectMake(15.f, 15.f, 60.f, 20);
            cell.detailLable.frame = CGRectMake(100.f, 15.f, SCREEN_WIDTH - 100.f - 100.f, 20);
            [cell.auditStatusLabel setFrame:CGRectMake(CGRectGetMaxX(cell.detailLable.frame) + 20.f, 15.f, 80.f, 20.f)];
            cell.auditStatusLabel.text = verify_state;
            BXTPostionInfo *positionInfo = [BXTGlobal getUserProperty:U_POSITION];
            cell.titleLabel.text = @"职   位";
            cell.detailLable.text = positionInfo.role;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self addImages];
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
        __weak BXTSettingViewController *weakSelf = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [selectPhotos addObject:headImage];
            [weakSelf handleImage];
        }];
    }
    else
    {
        NSURL *path = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        [self loadImageFromAssertByUrl:path completion:^(UIImage * img)
         {
             __weak BXTSettingViewController *weakSelf = self;
             [picker dismissViewControllerAnimated:YES completion:^{
                 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                 [selectPhotos addObject:img];
                 [weakSelf handleImage];
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

/**
 *  SelectPhotoDelegate
 */
- (void)getSelectedPhoto:(NSMutableArray *)photos
{
    selectPhotos = photos;
    [self handleImage];
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
 *  BXTDataResponseDelegate
 */
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    LogBlue(@"%@",dic);
    if (type == UploadHeadImage && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [BXTGlobal setUserProperty:[dic objectForKey:@"pic"] withKey:U_HEADERIMAGE];
    }
    else if (type == UserInfo && [[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        NSArray *array = [dic objectForKey:@"data"];
        if (array.count > 0)
        {
            NSDictionary *dictionay = array[0];
            verify_state = [dictionay objectForKey:@"verify_state"];
            checkUserDic = [dictionay objectForKey:@"stores_checks"];
            checks_user = [checkUserDic objectForKey:@"checks_user"];
            if (checks_user.length)
            {
                isHaveChecker = YES;
            }
            else
            {
                isHaveChecker = NO;
            }
            checks_user_department = [checkUserDic objectForKey:@"checks_user_department"];
        }
    }
    [currentTableView reloadData];
}

- (void)requestError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
