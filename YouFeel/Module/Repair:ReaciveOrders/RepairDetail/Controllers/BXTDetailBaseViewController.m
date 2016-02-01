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

- (void)handleUserInfo:(NSDictionary *)dictionary
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [dictionary objectForKey:@"out_userid"];
    
    NSString *my_userID = [BXTGlobal getUserProperty:U_USERID];
    if ([userInfo.userId isEqualToString:my_userID]) return;
    
    userInfo.name = [dictionary objectForKey:@"name"];
    userInfo.portraitUri = [dictionary objectForKey:@"head_pic"];
    
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
    for (NSDictionary *dictionary in _repairDetail.fault_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    for (NSDictionary *dictionary in _repairDetail.fixed_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    for (NSDictionary *dictionary in _repairDetail.evaluation_pic)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    return photos;
}

- (NSMutableArray *)containAllPhotos:(NSArray *)picArray
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in picArray)
    {
        if (![[dictionary objectForKey:@"photo_file"] isEqual:[NSNull null]])
        {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]]];
            [photos addObject:photo];
        }
    }
    return photos;
}

- (NSMutableArray *)containAllArray
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in _repairDetail.fault_pic)
    {
        [photos addObject:dictionary];
    }
    for (NSDictionary *dictionary in _repairDetail.fixed_pic)
    {
        [photos addObject:dictionary];
    }
    for (NSDictionary *dictionary in _repairDetail.evaluation_pic)
    {
        [photos addObject:dictionary];
    }
    return photos;
}

- (UIImageView *)imageViewWith:(NSInteger)i andDictionary:(NSDictionary *)dictionary
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25.f * (i + 1) + ImageWidth * i, 0, ImageWidth, ImageHeight)];
    imgView.userInteractionEnabled = YES;
    imgView.layer.masksToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"photo_file"]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
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

- (UIView *)viewForUser:(NSInteger)i andMaintenanceMaxY:(CGFloat)mainMaxY andLevelWidth:(CGFloat)levelWidth
{
    NSInteger count = self.repairDetail.repair_user_arr.count;
    NSDictionary *userDic = self.repairDetail.repair_user_arr[i];
    NSString *content = [userDic objectForKey:@"log_content"];
    CGFloat height = RepairHeight;
    CGSize size = CGSizeZero;
    if (content.length > 0)
    {
        NSString *log = [NSString stringWithFormat:@"维修日志：%@",content];
        size = MB_MULTILINE_TEXTSIZE(log, [UIFont systemFontOfSize:16.f], CGSizeMake(SCREEN_WIDTH - 30, 1000.f), NSLineBreakByWordWrapping);
        height = RepairHeight + size.height + 20.f;
    }
    
    UIView *userBack = [[UIView alloc] initWithFrame:CGRectMake(0.f, mainMaxY + i * RepairHeight + log_height, SCREEN_WIDTH, height)];
    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 73.3f, 73.3f)];
    [userImgView sd_setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"head_pic"]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    userImgView.userInteractionEnabled = YES;
    [userBack addSubview:userImgView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [[tapGR rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        BXTPersonInfromViewController *piVC = [[BXTPersonInfromViewController alloc] init];
        piVC.userID = [userDic objectForKey:@"id"];
        NSArray *shopArray = [BXTGlobal getUserProperty:U_SHOPIDS];
        piVC.shopID = shopArray[0];
        [self.navigationController pushViewController:piVC animated:YES];
    }];
    [userImgView addGestureRecognizer:tapGR];
    
    
    //log_height：维修日志的高度
    if (size.height > 0)
    {
        log_height = size.height + 20.f;
    }
    else
    {
        log_height = 0.f;
    }
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 8.f, levelWidth, 20)];
    userName.textColor = colorWithHexString(@"000000");
    userName.numberOfLines = 0;
    userName.lineBreakMode = NSLineBreakByWordWrapping;
    userName.font = [UIFont systemFontOfSize:16.f];
    userName.text = [userDic objectForKey:@"name"];
    [userBack addSubview:userName];
    
    UILabel *role = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 28.f, levelWidth, 20)];
    role.textColor = colorWithHexString(@"909497");
    role.numberOfLines = 0;
    role.lineBreakMode = NSLineBreakByWordWrapping;
    role.font = [UIFont systemFontOfSize:14.f];
    role.text = [NSString stringWithFormat:@"%@-%@",[userDic objectForKey:@"department"],[userDic objectForKey:@"role"]];
    [userBack addSubview:role];
    
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 50.f, levelWidth, 20)];
    phone.textColor = colorWithHexString(@"909497");
    phone.numberOfLines = 0;
    phone.lineBreakMode = NSLineBreakByWordWrapping;
    phone.userInteractionEnabled = YES;
    phone.font = [UIFont systemFontOfSize:14.f];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[userDic objectForKey:@"mobile"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:NSMakeRange(0, 11)];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 11)];
    phone.attributedText = attributedString;
    UITapGestureRecognizer *moblieTap = [[UITapGestureRecognizer alloc] init];
    [phone addGestureRecognizer:moblieTap];
    [[moblieTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *userDic = self.repairDetail.repair_user_arr[i];
        NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", [userDic objectForKey:@"mobile"]];
        UIWebView *callWeb = [[UIWebView alloc] init];
        [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
        [self.view addSubview:callWeb];
    }];
    [userBack addSubview:phone];
    //维修日志
    if (height > RepairHeight)
    {
        UILabel *log = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(userImgView.frame), CGRectGetMaxY(userImgView.frame) + 12.f, SCREEN_WIDTH - 30.f, size.height)];
        log.textColor = colorWithHexString(@"000000");
        log.numberOfLines = 0;
        log.lineBreakMode = NSLineBreakByWordWrapping;
        log.font = [UIFont systemFontOfSize:16.f];
        log.text = content;
        [userBack addSubview:log];
    }
    
    if ([[userDic objectForKey:@"id"] isEqualToString:[BXTGlobal getUserProperty:U_BRANCHUSERID]] &&
        _repairDetail.repairstate == 2 &&
        _repairDetail.isRepairing == 1)
    {
        UIButton *repairNow = [UIButton buttonWithType:UIButtonTypeCustom];
        repairNow.layer.cornerRadius = 4.f;
        repairNow.backgroundColor = colorWithHexString(@"3cafff");
        [repairNow setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 22.5f + 10.f, 83.f, 40.f)];
        [repairNow setTitle:@"开始维修" forState:UIControlStateNormal];
        [repairNow setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
        repairNow.titleLabel.font = [UIFont systemFontOfSize:15];
        [[repairNow rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self showLoadingMBP:@"请稍候..."];
            BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
            [request startRepair:[NSString stringWithFormat:@"%ld",(long)self.repairDetail.repairID]];
        }];
        [userBack addSubview:repairNow];
    }
    else
    {
        UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
        contact.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        contact.layer.borderWidth = 1.f;
        contact.layer.cornerRadius = 4.f;
        [contact setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 22.5f + 10.f, 83.f, 40.f)];
        [contact setTitle:@"联系Ta" forState:UIControlStateNormal];
        contact.titleLabel.font = [UIFont systemFontOfSize:16];
        [contact setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        @weakify(self);
        [[contact rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSDictionary *userDic = self.repairDetail.repair_user_arr[i];
            [self handleUserInfo:userDic];
        }];
        [userBack addSubview:contact];
    }
    
    if (i != count - 1)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, userBack.bounds.size.height - 1.f, SCREEN_WIDTH - 30.f, 1.f)];
        line.backgroundColor = colorWithHexString(@"e2e6e8");
        [userBack addSubview:line];
    }
    
    return userBack;
}

- (UIView *)deviceLists:(NSInteger)i comingFromDeviceInfo:(BOOL)isComing
{
    NSDictionary *deviceDic = _repairDetail.device_list[i];
    CGFloat height = 63.f;
    //以设备列表下面那条线为基准
    CGFloat y = 46.f;
    UIView *deviceBackView = [[UIView alloc] initWithFrame:CGRectMake(0, y + i * height, SCREEN_WIDTH, height)];
    
    UILabel *deviceName = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 8.f, SCREEN_WIDTH - 108.f, 20)];
    deviceName.textColor = colorWithHexString(@"000000");
    deviceName.numberOfLines = 0;
    deviceName.lineBreakMode = NSLineBreakByWordWrapping;
    deviceName.font = [UIFont systemFontOfSize:16.f];
    deviceName.text = [NSString stringWithFormat:@"设备名称:%@",[deviceDic objectForKey:@"name"]];
    [deviceBackView addSubview:deviceName];
    
    UILabel *deviceNumber = [[UILabel alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(deviceName.frame) + 8.f, SCREEN_WIDTH - 108.f, 20)];
    deviceNumber.textColor = colorWithHexString(@"000000");
    deviceNumber.numberOfLines = 0;
    deviceNumber.lineBreakMode = NSLineBreakByWordWrapping;
    deviceNumber.font = [UIFont systemFontOfSize:16.f];
    deviceNumber.text = [NSString stringWithFormat:@"设备编号:%@",[deviceDic objectForKey:@"code_number"]];
    [deviceBackView addSubview:deviceNumber];
    
    if (!isComing)
    {
        UIButton *maintenaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        maintenaceBtn.layer.borderColor = colorWithHexString(@"3cafff").CGColor;
        maintenaceBtn.layer.borderWidth = 1.f;
        maintenaceBtn.layer.cornerRadius = 4.f;
        [maintenaceBtn setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 11.f, 83.f, 40.f)];
        //如果是报修者身份，或者是维修员还没有到达现场（点击开始维修），则只提供查看权限
        if (((self.repairDetail.repairstate == 1 || self.repairDetail.repairstate == 2) && self.repairDetail.isRepairing == 1) || ![BXTGlobal shareGlobal].isRepair)
        {
            [maintenaceBtn setTitle:@"查看" forState:UIControlStateNormal];
        }
        else if ([[deviceDic objectForKey:@"inspection_state"] integerValue] == 0)
        {
            [maintenaceBtn setTitle:@"开始保养" forState:UIControlStateNormal];
        }
        else if ([[deviceDic objectForKey:@"inspection_state"] integerValue] == 1)
        {
            [maintenaceBtn setTitle:@"维保中" forState:UIControlStateNormal];
        }
        else if ([[deviceDic objectForKey:@"inspection_state"] integerValue] == 2)
        {
            [maintenaceBtn setTitle:@"已完成" forState:UIControlStateNormal];
        }
        maintenaceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [maintenaceBtn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
        @weakify(self);
        [[maintenaceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSDictionary *deviceDic = self.repairDetail.device_list[i];
            BXTEquipmentViewController *epvc = [[BXTEquipmentViewController alloc] initWithDeviceID:[deviceDic objectForKey:@"id"]];
            epvc.pushType = PushType_StartMaintain;
            epvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:epvc animated:YES];
        }];
        [deviceBackView addSubview:maintenaceBtn];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.f, CGRectGetMaxY(deviceNumber.frame) + 10.f - 1, SCREEN_WIDTH - 30.f, 1.f)];
    line.backgroundColor = colorWithHexString(@"e2e6e8");
    [deviceBackView addSubview:line];
    
    return deviceBackView;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    
}

- (void)requestError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
