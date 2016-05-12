//
//  BXTDetailBaseViewController.m
//  YouFeel
//
//  Created by Jason on 16/1/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTDetailBaseViewController.h"
#import "UIImageView+WebCache.h"
#import "BXTHeaderForVC.h"
#import "BXTEquipmentViewController.h"
#import "BXTPersonInfromViewController.h"

@interface BXTDetailBaseViewController ()<BXTDataResponseDelegate>

@end

@implementation BXTDetailBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)handleUserInfoWithUser:(BXTControlUserInfo *)user
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = user.userID;
    NSString *my_userID = [BXTGlobal getUserProperty:U_BRANCHUSERID];
    if ([userInfo.userId isEqualToString:my_userID]) return;
    userInfo.name = user.name;
    userInfo.portraitUri = user.head_pic;
    
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
    conversationVC.title = userInfo.name;
    [self.navigationController pushViewController:conversationVC animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)handleUserInfo:(NSDictionary *)dic
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [dic objectForKey:@"UserID"];
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID]) return;
    
    userInfo.name = [dic objectForKey:@"UserName"];
    userInfo.portraitUri = [dic objectForKey:@"HeadPic"];
    
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
    conversationVC.title = userInfo.name;
    [self.navigationController pushViewController:conversationVC animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (NSMutableArray *)containAllPhotosForMWPhotoBrowser
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (BXTFaultPicInfo *picInfo in self.repairDetail.fault_pic)
    {
        if (picInfo.photo_file)
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:picInfo.photo_file]];
            [photos addObject:photo];
        }
    }
    for (BXTFaultPicInfo *picInfo in self.repairDetail.fixed_pic)
    {
        if (picInfo.photo_file)
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:picInfo.photo_file]];
            [photos addObject:photo];
        }
    }
    for (BXTFaultPicInfo *picInfo in self.repairDetail.evaluation_pic)
    {
        if (picInfo.photo_file)
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:picInfo.photo_file]];
            [photos addObject:photo];
        }
    }
    return photos;
}

- (NSMutableArray *)containAllPhotos:(NSArray *)picArray
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (BXTFaultPicInfo *picInfo in picArray)
    {
        if (picInfo.photo_file)
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:picInfo.photo_file]];
            [photos addObject:photo];
        }
    }
    return photos;
}

- (NSMutableArray *)containAllArray
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (BXTFaultPicInfo *picInfo in _repairDetail.fault_pic)
    {
        [photos addObject:picInfo];
    }
    for (BXTFaultPicInfo *picInfo in _repairDetail.fixed_pic)
    {
        [photos addObject:picInfo];
    }
    for (BXTFaultPicInfo *picInfo in _repairDetail.evaluation_pic)
    {
        [photos addObject:picInfo];
    }
    return photos;
}

- (UIImageView *)imageViewWith:(NSInteger)i andDictionary:(BXTFaultPicInfo *)picInfo
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25.f * (i + 1) + ImageWidth * i, 0, ImageWidth, ImageHeight)];
    imgView.userInteractionEnabled = YES;
    imgView.layer.masksToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [imgView sd_setImageWithURL:[NSURL URLWithString:picInfo.photo_file] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    [imgView addGestureRecognizer:tapGR];
    @weakify(self);
    [[tapGR rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        self.mwPhotosArray = [self containAllPhotosForMWPhotoBrowser];
        [self loadMWPhotoBrowserForDetail:i withFaultPicCount:self.repairDetail.fault_pic.count withFixedPicCount:self.repairDetail.fixed_pic.count withEvaluationPicCount:self.repairDetail.evaluation_pic.count];
    }];
    
    return imgView;
}

- (UIView *)viewForUser:(NSInteger)i andMaintenance:(BXTMaintenanceManInfo *)userInfo
{
    CGFloat mmBackWidth = 113.f;
    CGFloat mmBackHeight = 128.f;
    UIView *userBack = [[UIView alloc] initWithFrame:CGRectMake(i * mmBackWidth , 0, SCREEN_WIDTH, mmBackHeight)];
    
    //头像
    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    userImgView.center = CGPointMake(mmBackWidth/2.f, 32.f);
    userImgView.tag = i;
    [userImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.head_pic] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    userImgView.userInteractionEnabled = YES;
    [userBack addSubview:userImgView];
    //点击头像
    @weakify(self);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        BXTMaintenanceManInfo *repairPerson = self.repairDetail.repair_user_arr[userImgView.tag];
        BXTPersonInfromViewController *personVC = [[BXTPersonInfromViewController alloc] init];
        personVC.userID = repairPerson.mmID;
        NSArray *shopArray = [BXTGlobal getUserProperty:U_SHOPIDS];
        personVC.shopID = shopArray[0];
        [self.navigationController pushViewController:personVC animated:YES];
    }];
    [userImgView addGestureRecognizer:tapGesture];
    
    //姓名
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userImgView.frame) + 8.f, mmBackWidth, 20)];
    userName.textColor = colorWithHexString(@"000000");
    userName.textAlignment = NSTextAlignmentCenter;
    userName.font = [UIFont systemFontOfSize:16.f];
    userName.text = userInfo.name;
    [userBack addSubview:userName];
    
    //联系Ta
    UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
    contact.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
    contact.layer.borderWidth = 1.f;
    contact.layer.cornerRadius = 4.f;
    [contact setFrame:CGRectMake(0, CGRectGetMaxY(userName.frame) + 8, 76.f, 30.f)];
    [contact setCenter:CGPointMake(mmBackWidth/2.f, contact.center.y)];
    [contact setTitle:@"联系Ta" forState:UIControlStateNormal];
    contact.titleLabel.font = [UIFont systemFontOfSize:16];
    [contact setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
    [[contact rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        BXTMaintenanceManInfo *mainManInfo = self.repairDetail.repair_user_arr[i];
        [self handleUserInfo:@{@"UserID":mainManInfo.out_userid,
                               @"UserName":mainManInfo.name,
                               @"HeadPic":mainManInfo.head_pic}];
    }];
    [userBack addSubview:contact];
    
    return userBack;
}

- (UIView *)deviceLists:(NSInteger)i comingFromDeviceInfo:(BOOL)isComing isLast:(BOOL)last
{
    BXTDeviceMMListInfo *deviceMMInfo = _repairDetail.device_lists[i];
    CGFloat height = 63.f;
    //以设备列表下面那条线为基准
    CGFloat y = 30.f;
    UIView *deviceBackView = [[UIView alloc] initWithFrame:CGRectMake(0, y + i * height, SCREEN_WIDTH, height)];
    
    UILabel *deviceName = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 8.f, SCREEN_WIDTH - 108.f, 20)];
    deviceName.textColor = colorWithHexString(@"000000");
    deviceName.numberOfLines = 0;
    deviceName.lineBreakMode = NSLineBreakByWordWrapping;
    deviceName.font = [UIFont systemFontOfSize:16.f];
    deviceName.text = deviceMMInfo.name;
    [deviceBackView addSubview:deviceName];
    
    UILabel *deviceNumber = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(deviceName.frame) + 8.f, SCREEN_WIDTH - 108.f, 20)];
    deviceNumber.textColor = colorWithHexString(@"000000");
    deviceNumber.numberOfLines = 0;
    deviceNumber.lineBreakMode = NSLineBreakByWordWrapping;
    deviceNumber.font = [UIFont systemFontOfSize:16.f];
    deviceNumber.text = deviceMMInfo.code_number;
    [deviceBackView addSubview:deviceNumber];
    
    if (!isComing)
    {
        UIButton *maintenaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        maintenaceBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        maintenaceBtn.layer.borderWidth = 1.f;
        maintenaceBtn.layer.cornerRadius = 4.f;
        [maintenaceBtn setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 11.f, 83.f, 40.f)];
        maintenaceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        if (!IS_IPHONE6)
        {
            [maintenaceBtn setFrame:CGRectMake(SCREEN_WIDTH - 70.f - 15.f, 11.f, 70.f, 35.f)];
            maintenaceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        }

        if ([self.repairDetail.task_type integerValue] == 2 && [self.repairDetail.repairstate integerValue] > 1 && [deviceMMInfo.inspection_state integerValue] == 0)
        {
            [maintenaceBtn setTitle:@"开始保养" forState:UIControlStateNormal];
        }
        else if ([self.repairDetail.task_type integerValue] == 2 && [self.repairDetail.repairstate integerValue] > 1 && [deviceMMInfo.inspection_state integerValue] == 1)
        {
            [maintenaceBtn setTitle:@"维保中" forState:UIControlStateNormal];
        }
        else if ([self.repairDetail.task_type integerValue] == 2 && [self.repairDetail.repairstate integerValue] > 1 && [deviceMMInfo.inspection_state integerValue] == 2)
        {
            [maintenaceBtn setTitle:@"已完成" forState:UIControlStateNormal];
        }
        //如果是报修者身份，或者是维修员还没有到达现场（点击开始维修），或者是正常工单，则只提供查看权限
        else
        {
            [maintenaceBtn setTitle:@"查看" forState:UIControlStateNormal];
        }
        
        [maintenaceBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        @weakify(self);
        [[maintenaceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            BXTDeviceMMListInfo *dmInfo = self.repairDetail.device_lists[i];
            BXTEquipmentViewController *epvc = [[BXTEquipmentViewController alloc] initWithDeviceID:dmInfo.deviceMMID];
            epvc.pushType = PushType_StartMaintain;
            epvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:epvc animated:YES];
        }];
        [deviceBackView addSubview:maintenaceBtn];
    }
    
    if (!last)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(deviceNumber.frame) + 10.f - 1, SCREEN_WIDTH - 30.f, 1.f)];
        line.backgroundColor = colorWithHexString(@"e2e6e8");
        [deviceBackView addSubview:line];
    }
    
    return deviceBackView;
}


- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
