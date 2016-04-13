//
//  BXTManListViewController.m
//  YouFeel
//
//  Created by Jason on 16/4/13.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTManListViewController.h"
#import "BXTCustomButton.h"
#import "BXTGroupingInfo.h"
#import "BXTManTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BXTRepairDetailInfo.h"
#import "BXTCustomImageView.h"

static const CGFloat UserBackViewWidth = 86.f;
static const CGFloat UserBackViewHeight = 104.f;
static const CGFloat UserBackViewSpace = 20.f;

@interface BXTManListViewController ()
{
    NSInteger number;
}

@property (nonatomic, strong) NSArray *repairUserArray;
@property (nonatomic, strong) NSString *repairID;
@property (nonatomic, assign) ControllerType vcType;
@property (nonatomic, strong) NSMutableArray *groupsArray;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) NSMutableArray *checkArray;//0:未选、1:已选、2:不可操作的（指的是最上面的那些人）

@end

@implementation BXTManListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                       repairID:(NSString *)orderID
                        manList:(NSArray *)manArray
                 controllerType:(ControllerType)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        number = 0;
        self.repairID = orderID;
        self.vcType = type;
        self.repairUserArray = manArray;
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
    self.commitButton.layer.cornerRadius = 4.f;
    [self.currentTableView registerNib:[UINib nibWithNibName:@"BXTManTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserCell"];
    [self.currentTableView setRowHeight:50.f];
    
    NSInteger count = self.repairUserArray.count;
    if (count > 0)
    {
        CGFloat length = 10 + (UserBackViewWidth + UserBackViewSpace) * (count - 1);
        if (length > SCREEN_WIDTH)
        {
            self.content_width.constant = length;
        }
        else
        {
            self.content_width.constant = SCREEN_WIDTH;
        }
        [self.contentView layoutIfNeeded];

        for (NSInteger i = 0; i < self.repairUserArray.count; i++)
        {
            BXTMaintenanceManInfo *manInfo = self.repairUserArray[i];
            UIView *userView = [self initialManView:manInfo withIndex:i];
            [self.contentView addSubview:userView];
        }
    }
    
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request maintenanceManList];
}

- (UIView *)initialManView:(BXTMaintenanceManInfo *)manInfo withIndex:(NSInteger)index
{
    CGFloat space = 10.f;//第一个距左的间距
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(space + (UserBackViewWidth + UserBackViewSpace) * index, 0, UserBackViewWidth, UserBackViewHeight)];
    backView.backgroundColor = [UIColor orangeColor];
    
    BXTCustomImageView *headImgView = [[BXTCustomImageView alloc] initWithFrame:CGRectMake(10, 6, 64, 64)];
    [headImgView sd_setImageWithURL:[NSURL URLWithString:manInfo.head_pic] placeholderImage:[UIImage imageNamed:@"polaroid"]];
    [backView addSubview:headImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImgView.frame) + 4.f, UserBackViewWidth, 20.f)];
    nameLabel.font = [UIFont systemFontOfSize:17.f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = manInfo.name;
    [backView addSubview:nameLabel];
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.f)];
    backView.backgroundColor = [UIColor whiteColor];
    if (self.groupsArray.count > section)
    {
        BXTGroupingInfo *groupInfo = self.groupsArray[section];
        BXTCustomButton *btn = [[BXTCustomButton alloc] initWithType:GroupBtnType];
        [btn setFrame:CGRectMake(15.f, 0, SCREEN_WIDTH - 30.f, 40.f)];
        [btn setTitle:groupInfo.subgroup forState:UIControlStateNormal];
        NSString *markStr = self.markArray[section];
        if ([markStr integerValue])
        {
            [btn setTitleColor:colorWithHexString(@"3cafff") forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"wo_up_arrow"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:colorWithHexString(@"000000") forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"wo_down_arrow"] forState:UIControlStateNormal];
        }
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
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
        [backView addSubview:btn];
    }
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.f;
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
    BXTManTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    BXTGroupingInfo *groupInfo = self.groupsArray[indexPath.section];
    BXTManInfo *manInfo = groupInfo.user_lists[indexPath.row];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:manInfo.head_pic]];
    cell.nameLabel.text = manInfo.name;
    NSString *state = manInfo.is_work ? @"当班" : @"休息";
    UIColor *color = manInfo.is_work ? colorWithHexString(@"5F5F5F") : colorWithHexString(@"D71514");
    cell.stateLabel.text = state;
    cell.stateLabel.textColor = color;
    cell.numberLabel.text = [NSString stringWithFormat:@"当前有%ld单",(long)manInfo.work_number];
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
    NSMutableArray *tempCheckArray = self.checkArray[indexPath.section];
    NSString *checkStr = tempCheckArray[indexPath.row];
    if ([checkStr isEqualToString:@"0"])
    {
        [tempCheckArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    else if ([checkStr isEqualToString:@"1"])
    {
        [tempCheckArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    [tableView reloadData];
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
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
            for (BXTMaintenanceManInfo *mmInfo in self.repairUserArray)
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

- (void)requestError:(NSError *)error requeseType:(RequestType)type
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
