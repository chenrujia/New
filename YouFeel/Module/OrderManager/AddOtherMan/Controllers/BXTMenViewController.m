//
//  BXTMenViewController.m
//  YouFeel
//
//  Created by Jason on 16/4/14.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTMenViewController.h"
#import "BXTCustomButton.h"
#import "BXTGroupingInfo.h"
#import "BXTManTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BXTRepairDetailInfo.h"

static const CGFloat UserBackViewWidth = 86.f;
static const CGFloat UserBackViewHeight = 104.f;
static const CGFloat UserBackViewSpace = 20.f;

@interface BXTMenViewController ()
{
    NSInteger number;
    NSInteger peoplesCount;
}

@property (nonatomic, strong) NSString       *repairID;
@property (nonatomic, strong) NSArray        *repairUserArray;
@property (nonatomic, strong) NSMutableArray *dispatchUserArray;
@property (nonatomic, strong) NSMutableArray *peoplesArray;
@property (nonatomic, strong) NSMutableArray *groupsArray;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) NSMutableArray *checkArray;//0:未选、1:已选、2:不可操作的（指的是最上面的那些人）
@end

@implementation BXTMenViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil repairID:(NSString *)orderID repairUserList:(NSArray *)repairUserArray dispatchUserList:(NSArray *)dispatchUserArray
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        number = 0;
        self.repairID = orderID;
        self.repairUserArray = repairUserArray;
        self.dispatchUserArray = [NSMutableArray arrayWithArray:dispatchUserArray];
        self.manIDArray = [NSMutableArray array];
        self.groupsArray = [NSMutableArray array];
        self.markArray = [NSMutableArray array];
        self.checkArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"人员列表" andRightTitle:nil andRightImage:nil];
    self.view.backgroundColor = colorWithHexString(@"EFEFF4");
    self.commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.commitBtn.layer.cornerRadius = 4.f;
    [self.currentTableView registerNib:[UINib nibWithNibName:@"BXTManTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserCell"];
    [self.currentTableView setRowHeight:50.f];
    
    NSMutableArray *peopleArray = [NSMutableArray array];
    [peopleArray addObjectsFromArray:self.dispatchUserArray];
    [peopleArray addObjectsFromArray:self.repairUserArray];
    self.peoplesArray = peopleArray;
    peoplesCount = self.peoplesArray.count;
    
    if (peoplesCount == 0)
    {
        self.peopleList.hidden = YES;
        self.table_top.constant = KNAVIVIEWHEIGHT;
        [self.currentTableView layoutIfNeeded];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"已选中：%ld人",(long)peoplesCount];
        NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%ld人",(long)peoplesCount]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:range];
        self.choosedLabel.attributedText = attributeStr;
    }

    if (peoplesCount > 0)
    {
        CGFloat length = 10 + (UserBackViewWidth + UserBackViewSpace) * (peoplesCount - 1) + UserBackViewWidth + 10;
        if (length > SCREEN_WIDTH)
        {
            self.scrollerView.contentSize = CGSizeMake(length, 0);
        }
        else
        {
            self.scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        }
        
        for (NSInteger i = 0; i < peoplesCount; i++)
        {
            BXTMaintenanceManInfo *manInfo = self.peoplesArray[i];
            UIView *userView = [self initialManView:manInfo withIndex:i];
            [self.scrollerView addSubview:userView];
        }
    }
    
    [self showLoadingMBP:@"请稍候..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request maintenanceManList];
}

- (UIView *)initialManView:(BXTMaintenanceManInfo *)manInfo withIndex:(NSInteger)index
{
    CGFloat space = 10.f;//第一个距左的间距
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(space + (UserBackViewWidth + UserBackViewSpace) * index, 0, UserBackViewWidth, UserBackViewHeight)];
    backView.tag = index + 1;
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 64, 64)];
    [headImgView sd_setImageWithURL:[NSURL URLWithString:manInfo.head_pic] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    [backView addSubview:headImgView];
    
    if (![self.repairUserArray containsObject:manInfo])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectCenterAt(CGRectMake(0, 0, 40, 40), CGPointMake(CGRectGetMaxX(headImgView.frame), CGRectGetMinY(headImgView.frame)))];
        btn.tag = index + 1;
        [btn setImage:[UIImage imageNamed:@"man_delete"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"man_delete_selected"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(deleteMan:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImgView.frame) + 4.f, UserBackViewWidth, 20.f)];
    nameLabel.font = [UIFont systemFontOfSize:17.f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = manInfo.name;
    [backView addSubview:nameLabel];
    
    return backView;
}

- (IBAction)commitClick:(id)sender
{
    for (BXTMaintenanceManInfo *manInfo in self.dispatchUserArray)
    {
        [self.manIDArray addObject:manInfo.mmID];
    }
    NSString *data = [self.manIDArray componentsJoinedByString:@","];
    [self showLoadingMBP:@"请稍候..."];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request dispatchingMan:self.repairID andMans:data];
}

- (void)deleteMan:(UIButton *)btn
{
    NSMutableArray *filterArray = [NSMutableArray array];
    peoplesCount--;
    NSString *str = [NSString stringWithFormat:@"已选中：%ld人",(long)peoplesCount];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%ld人",(long)peoplesCount]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"3cafff") range:range];
    self.choosedLabel.attributedText = attributeStr;

    UIView *subView = [self.scrollerView viewWithTag:btn.tag];
    [subView removeFromSuperview];
    for (UIView *view in self.scrollerView.subviews)
    {
        if (view.tag > btn.tag)
        {
            [filterArray addObject:view];
        }
    }
    if (filterArray.count > 0)
    {
        [UIView animateWithDuration:1.0f animations:^{
            for (UIView *view in filterArray)
            {
                CGRect rect = view.frame;
                rect.origin.x -= (UserBackViewSpace + UserBackViewWidth);
                view.frame = rect;
            }
        }];
        
        CGFloat length = 10 + (UserBackViewWidth + UserBackViewSpace) * (peoplesCount - 1) + UserBackViewWidth + 10;
        if (length > SCREEN_WIDTH)
        {
            self.scrollerView.contentSize = CGSizeMake(length, 0);
        }
        else
        {
            self.scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        }
    }

    BXTMaintenanceManInfo *deleteManInfo = self.peoplesArray[btn.tag - 1];
    BOOL isFind = NO;
    NSInteger section = 0;
    NSInteger row = 0;
    for (NSInteger i = 0; i < self.groupsArray.count; i++)
    {
        BXTGroupingInfo *groupInfo = self.groupsArray[i];
        for (NSInteger j = 0; j < groupInfo.user_lists.count; j++)
        {
            BXTManInfo *manInfo = groupInfo.user_lists[j];
            if ([deleteManInfo.mmID isEqualToString:manInfo.manID])
            {
                isFind = YES;
                section = i;
                row = j;
                break;
            }
        }
    }
    [self.dispatchUserArray removeObject:deleteManInfo];

    if (isFind)
    {
        NSMutableArray *tempCheckArray = self.checkArray[section];
        [tempCheckArray replaceObjectAtIndex:row withObject:@"0"];
        [self.currentTableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.f)];
    backView.backgroundColor = [UIColor whiteColor];
    
    BXTGroupingInfo *groupInfo = self.groupsArray[section];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, SCREEN_WIDTH - 30.f, 40.f)];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.font = [UIFont systemFontOfSize:17.f];
    titleLabel.text = groupInfo.subgroup;
    [backView addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 18, 15, 9)];
    NSString *markStr = self.markArray[section];
    if ([markStr integerValue])
    {
        imageView.image = [UIImage imageNamed:@"wo_up_arrow"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"wo_down_arrow"];
    }
    [backView addSubview:imageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        if ([markStr integerValue])
        {
            [self.markArray replaceObjectAtIndex:section withObject:@"0"];
        }
        else
        {
            [self.markArray replaceObjectAtIndex:section withObject:@"1"];
        }
        [self.currentTableView reloadData];
    }];
    [titleLabel addGestureRecognizer:tapGesture];
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12.f)];
    backView.backgroundColor = colorWithHexString(@"EFEFF4");
    
    return backView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *markStr = self.markArray[section];
    if ([markStr integerValue])
    {
        BXTGroupingInfo *groupInfo = self.groupsArray[section];
        return groupInfo.user_lists.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTManTableViewCell *cell = (BXTManTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    BXTGroupingInfo *groupInfo = self.groupsArray[indexPath.section];
    BXTManInfo *manInfo = groupInfo.user_lists[indexPath.row];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:manInfo.head_pic]];
    cell.nameLabel.text = manInfo.name;
    cell.stateLabel.text = manInfo.on_duty;
    if (manInfo.work_number == 0)
    {
        cell.numberLabel.text = @"空闲";
    }
    else
    {
        cell.numberLabel.text = [NSString stringWithFormat:@"当前有%ld单",(long)manInfo.work_number];
    }
    NSMutableArray *tempCheckArray = self.checkArray[indexPath.section];
    NSString *checkStr = tempCheckArray[indexPath.row];
    if ([checkStr isEqualToString:@"0"])
    {
        cell.markImage.image = [UIImage imageNamed:@"man_square"];
    }
    else if ([checkStr isEqualToString:@"1"])
    {
        cell.markImage.image = [UIImage imageNamed:@"man_check_selected"];
    }
    else if ([checkStr isEqualToString:@"2"])
    {
        cell.markImage.image = [UIImage imageNamed:@"man_check"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BXTGroupingInfo *groupInfo = self.groupsArray[indexPath.section];
    BXTManInfo *manInfo = groupInfo.user_lists[indexPath.row];
    NSMutableArray *tempCheckArray = self.checkArray[indexPath.section];
    NSString *checkStr = tempCheckArray[indexPath.row];
    if ([checkStr isEqualToString:@"0"])
    {
        [tempCheckArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        [self.manIDArray addObject:manInfo.manID];
    }
    else if ([checkStr isEqualToString:@"1"])
    {
        [tempCheckArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
        [self.manIDArray removeObject:manInfo.manID];
    }
    [tableView reloadData];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == ManList)
    {
        [BXTGroupingInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"group_id":@"id"};
        }];
        [BXTManInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"manID":@"id"};
        }];
        [self.groupsArray addObjectsFromArray:[BXTGroupingInfo mj_objectArrayWithKeyValuesArray:data]];
        NSInteger i = 0;
        while (i < self.groupsArray.count)
        {
            [self.markArray addObject:@"0"];
            ++i;
        }
        for (BXTGroupingInfo *groupInfo in self.groupsArray)
        {
            NSMutableArray *tempCheckArray = [NSMutableArray array];
            for (BXTManInfo *manInfo in groupInfo.user_lists)
            {
                BOOL isFind = NO;
                for (BXTMaintenanceManInfo *mmInfo in self.peoplesArray)
                {
                    if ([mmInfo.mmID isEqualToString:manInfo.manID])
                    {
                        isFind = YES;
                        break;
                    }
                }
                if (isFind)
                {
                    [tempCheckArray addObject:@"2"];
                }
                else
                {
                    [tempCheckArray addObject:@"0"];
                }
            }
            [self.checkArray addObject:tempCheckArray];
        }
        [self.currentTableView reloadData];
    }
    else if (type == DispatchOrAdd)
    {
        if ([[dic objectForKey:@"returncode"] integerValue] == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestDetail" object:nil];
            [self showMBP:@"操作成功！" withBlock:^(BOOL hidden) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    [self hideMBP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
