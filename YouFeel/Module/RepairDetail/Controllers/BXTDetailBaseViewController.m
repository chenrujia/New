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

@interface BXTDetailBaseViewController ()<BXTDataResponseDelegate>

@end

@implementation BXTDetailBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    // 删除位置功能
    //[conversationVC.pluginBoardView removeItemAtIndex:2];
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
    UIView *userBack = [[UIView alloc] initWithFrame:CGRectMake(0.f, mainMaxY + i * RepairHeight, SCREEN_WIDTH, RepairHeight)];
    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 10.f, 73.3f, 73.3f)];
    [userImgView sd_setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"head_pic"]] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    [userBack addSubview:userImgView];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 8.f, levelWidth, 20)];
    userName.textColor = colorWithHexString(@"000000");
    userName.numberOfLines = 0;
    userName.lineBreakMode = NSLineBreakByWordWrapping;
    userName.font = [UIFont boldSystemFontOfSize:16.f];
    userName.text = [userDic objectForKey:@"name"];
    [userBack addSubview:userName];
    
    UILabel *role = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 28.f, levelWidth, 20)];
    role.textColor = colorWithHexString(@"909497");
    role.numberOfLines = 0;
    role.lineBreakMode = NSLineBreakByWordWrapping;
    role.font = [UIFont boldSystemFontOfSize:14.f];
    role.text = [NSString stringWithFormat:@"%@-%@",[userDic objectForKey:@"department"],[userDic objectForKey:@"role"]];
    [userBack addSubview:role];
    
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgView.frame) + 15.f, CGRectGetMinY(userImgView.frame) + 50.f, levelWidth, 20)];
    phone.textColor = colorWithHexString(@"909497");
    phone.numberOfLines = 0;
    phone.lineBreakMode = NSLineBreakByWordWrapping;
    phone.userInteractionEnabled = YES;
    phone.font = [UIFont boldSystemFontOfSize:14.f];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[userDic objectForKey:@"mobile"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:NSMakeRange(0, 11)];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 11)];
    phone.attributedText = attributedString;
    UITapGestureRecognizer *moblieTap = [[UITapGestureRecognizer alloc] init];
    [phone addGestureRecognizer:moblieTap];
    @weakify(self);
    [[moblieTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *userDic = self.repairDetail.repair_user_arr[i];
        NSString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@", [userDic objectForKey:@"mobile"]];
        UIWebView *callWeb = [[UIWebView alloc] init];
        [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
        [self.view addSubview:callWeb];
    }];
    [userBack addSubview:phone];
    
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
        contact.layer.borderColor = colorWithHexString(@"e2e6e8").CGColor;
        contact.layer.borderWidth = 1.f;
        contact.layer.cornerRadius = 6.f;
        [contact setFrame:CGRectMake(SCREEN_WIDTH - 83.f - 15.f, 22.5f + 10.f, 83.f, 40.f)];
        [contact setTitle:@"联系Ta" forState:UIControlStateNormal];
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

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = (NSDictionary *)response;
    if ([[dic objectForKey:@"returncode"] integerValue] == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
        __weak typeof(self) weakSelf = self;
        [self showMBP:@"已经开始！" withBlock:^(BOOL hidden) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        [self hideMBP];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
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
