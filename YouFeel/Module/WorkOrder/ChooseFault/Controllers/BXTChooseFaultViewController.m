//
//  BXTChooseFaultViewController.m
//  YouFeel
//
//  Created by 满孝意 on 16/1/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTChooseFaultViewController.h"
#import "BXTHeaderForVC.h"
#import "PinYinForObjc.h"
#import "BXTFaultType.h"
#import "BXTFaultTypeGroup.h"
#import "BXTFaultTypeView.h"
#import "BXTFaultTypeList.h"

typedef NS_ENUM(NSInteger, SelectedType) {
    SelectedType_First = 1,
    SelectedType_Second
};

@interface BXTChooseFaultViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, BXTDataResponseDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) BXTFaultTypeView *groupView;
@property (nonatomic, strong) BXTFaultTypeView *typeView;
/** ---- 选择的按钮 ---- */
@property (nonatomic, assign) NSInteger typeOfRow;
/** ---- 类型选择的row ---- */
@property (nonatomic, assign) NSInteger indexOfRow;
/** ---- 传递参数的数组 ---- */
@property (nonatomic, copy) NSString *transFaulttypeID;

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, assign) BOOL isBgBtnExist;
@property (nonatomic, strong) UITableView *tableView_fault;
/** ---- 显示数组 ---- */
@property (nonatomic, strong) NSMutableArray *faultArray;
/** ---- 故障类型 ---- */
@property (nonatomic, strong) NSMutableArray *faultGroup;
/** ---- 故障类别 ---- */
@property (nonatomic, strong) NSMutableArray *faultType;
@property (nonatomic, assign) CGSize cellSize;


@property(nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView_Search;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, copy) NSString *searchStr;


@end

@implementation BXTChooseFaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationSetting:@"选择故障" andRightTitle:nil andRightImage:nil];
    
    self.faultArray = [[NSMutableArray alloc] init];
    self.faultGroup = [[NSMutableArray alloc] init];
    self.faultType = [[NSMutableArray alloc] init];
    self.searchArray = [[NSMutableArray alloc] init];
    
    [self showLoadingMBP:@"数据加载中..."];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /**请求故障类型列表**/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request faultTypeList];
    });
    dispatch_async(concurrentQueue, ^{
        /** 获取全部故障类型 **/
        BXTDataRequest *fau_request = [[BXTDataRequest alloc] initWithDelegate:self];
        [fau_request allFaultTypeListWith:@"1"];
    });
    
    [self createUI];
}

#pragma mark -
#pragma mark - 初始化视图
- (void)createUI
{
    // UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, KNAVIVIEWHEIGHT, SCREEN_WIDTH, 55)];
    self.searchBar.delegate = self;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"快速搜索故障类型";
    [self.view addSubview:self.searchBar];
    
    
    // self.bgView
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55)];
    [self.view addSubview:self.bgView];
    
    // 故障类型
    self.groupView = [[[NSBundle mainBundle] loadNibNamed:@"BXTFaultTypeView" owner:nil options:nil] lastObject];
    self.groupView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.groupView.titleView.text = @"类型";
    self.groupView.faultTypeView.text = @"请选择故障类型";
    @weakify(self);
    [[self.groupView.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self createChooseFaultWithType:SelectedType_First];
    }];
    [self.bgView addSubview:self.groupView];
    
    //故障类别
    self.typeView = [[[NSBundle mainBundle] loadNibNamed:@"BXTFaultTypeView" owner:nil options:nil] lastObject];
    self.typeView.frame = CGRectMake(0, 60, SCREEN_WIDTH, 50);
    self.typeView.titleView.text = @"类别";
    self.typeView.faultTypeView.text = @"请选择故障类别";
    [[self.typeView.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self createChooseFaultWithType:SelectedType_Second];
    }];
    [self.bgView addSubview:self.typeView];
    
    // 确定
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(20, 140, SCREEN_WIDTH-40, 50);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = colorWithHexString(@"#36AFFD");
    sureBtn.layer.cornerRadius = 5;
    [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (![self.groupView.faultTypeView.text isEqualToString:@"请选择故障类型"] && ![self.typeView.faultTypeView.text isEqualToString:@"请选择故障类别"]) {
            [BXTGlobal showText:@"故障选择成功" view:self.view completionBlock:^{
                if (self.delegateSignal) {
                    NSString *str = [NSString stringWithFormat:@"%@-%@", self.groupView.faultTypeView.text, self.typeView.faultTypeView.text];
                    [self.delegateSignal sendNext:@[self.transFaulttypeID, str]];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else {
            [BXTGlobal showText:@"请选择故障类型和类别" view:self.view completionBlock:nil];
        }
    }];
    [self.bgView addSubview:sureBtn];
    
    
    // UITableView - tableView_Search
    self.tableView_Search = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - 55) style:UITableViewStyleGrouped];
    self.tableView_Search.dataSource = self;
    self.tableView_Search.delegate = self;
    [self.view addSubview:self.tableView_Search];
    
    // UITableView - tableView_Search - tableHeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableView_Search.tableHeaderView = headerView;
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 30)];
    alertLabel.text = @"搜索结果：";
    alertLabel.textColor = colorWithHexString(@"#666666");
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:alertLabel];
    
    self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH-40, 40)];
    self.remindLabel.text = @"抱歉，没有找到相关项目";
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.remindLabel];
    self.remindLabel.hidden = YES;
    
    [self showHomeViewAndHideSearchTableView:YES];
}

// 点击
- (void)createChooseFaultWithType:(SelectedType)typeSelected
{
    if (typeSelected == SelectedType_First) {
        self.typeOfRow = SelectedType_First;
        self.faultArray = self.faultGroup;
    }
    else {
        if ([self.groupView.faultTypeView.text isEqualToString:@"请选择故障类型"]) {
            [BXTGlobal showText:@"请选择故障类型" view:self.view completionBlock:nil];
            return;
        }
        self.typeOfRow = SelectedType_Second;
        self.faultArray = self.faultType[self.indexOfRow];
    }
    
    self.isBgBtnExist = YES;
    self.bgBtn = [[UIButton alloc] initWithFrame:self.view.frame];
    self.bgBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.bgBtn.alpha = 0;
    @weakify(self);
    [[self.bgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.isBgBtnExist = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.bgBtn.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.bgBtn removeFromSuperview];
        }];
    }];
    [self.view addSubview:self.bgBtn];
    
    CGSize bgSize = self.view.frame.size;
    self.tableView_fault = [[UITableView alloc] initWithFrame:CGRectMake(20, 30, bgSize.width-40, bgSize.height-60) style:UITableViewStylePlain];
    self.tableView_fault.backgroundColor = colorWithHexString(@"eff3f6");
    self.tableView_fault.delegate = self;
    self.tableView_fault.dataSource = self;
    [self.bgBtn addSubview:self.tableView_fault];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.bgBtn.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"should begin");
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel  setTintColor:[UIColor whiteColor]];
        }
    }
    
    [self showHomeViewAndHideSearchTableView:NO];
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    self.remindLabel.hidden = YES;
    NSLog(@"did begin");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    NSLog(@"did end");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self showHomeViewAndHideSearchTableView:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchStr = searchText;
    
    
    NSArray *allPersonArray = [BXTGlobal readFileWithfileName:@"AllFaultTypeList"];
    
    NSMutableArray *searchResults = [[NSMutableArray alloc]init];
    if (self.searchBar.text.length>0 && ![ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<allPersonArray.count; i++) {
            BXTFaultTypeList *model = [BXTFaultTypeList modelWithDict:allPersonArray[i]];
            
            if ([ChineseInclude isIncludeChineseInString:model.faulttype]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.faulttype];
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length > 0) {
                    [searchResults addObject:allPersonArray[i]];
                } else {
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.faulttype]; NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length > 0) {
                        [searchResults addObject:allPersonArray[i]];
                    }
                }
            } else {
                NSRange titleResult=[model.faulttype rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:allPersonArray[i]];
                }
            }
        }
    } else if (self.searchBar.text.length > 0 && [ChineseInclude isIncludeChineseInString:self.searchBar.text]) {
        for (NSDictionary *dict in allPersonArray) {
            BXTHeadquartersInfo *model = [BXTHeadquartersInfo modelObjectWithDictionary:dict];
            NSRange titleResult=[model.name rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0) {
                [searchResults addObject:dict];
            }
        }
    }
    
    self.searchArray = searchResults;
    
    [self.tableView_Search reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView_fault) {
        return 0.1;
    }
    
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_Search) {
        return 50;
    }
    return self.cellSize.height + 29;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView_fault) {
        return 1;
    }
    
    if (tableView == self.tableView_Search) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.remindLabel.hidden = YES;
    
    if (tableView == self.tableView_fault) {
        if (self.typeOfRow == SelectedType_Second) {
            return self.faultArray.count + 1;
        }
        return self.faultArray.count;
    }
    
    if (tableView == self.tableView_Search) {
        if (self.searchArray.count == 0 && self.tableView_Search.hidden == NO) {
            self.remindLabel.hidden = NO;
        }
        return self.searchArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_Search) {
        static NSString *cellID = @"cellSearch";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        NSDictionary *dict = self.searchArray[indexPath.row];
        BXTFaultTypeList *infoModel = [BXTFaultTypeList modelWithDict:dict];
        cell.textLabel.text = infoModel.faulttype;
        
        return cell;
    }
    
    
    static NSString *cellID = @"cellFault";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    if (self.typeOfRow == SelectedType_First) {
        BXTFaultTypeGroup *model = self.faultArray[indexPath.row];
        cell.textLabel.text = model.faulttype_type;
    }
    else {
        if (indexPath.row <= self.faultArray.count - 1) {
            BXTFaultType *model = self.faultArray[indexPath.row];
            cell.textLabel.text = model.faulttype;
        }
        else {
            cell.textLabel.text = @"其他";
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.numberOfLines = 0;
    
    self.cellSize = MB_MULTILINE_TEXTSIZE(cell.textLabel.text, [UIFont systemFontOfSize:16], CGSizeMake(SCREEN_WIDTH-60, CGFLOAT_MAX), NSLineBreakByWordWrapping);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableView_Search) {
        [BXTGlobal showText:@"故障选择成功" view:self.view completionBlock:^{
            if (self.delegateSignal) {
                BXTFaultTypeList *listModel = [BXTFaultTypeList modelWithDict: self.searchArray[indexPath.row]];
                NSString *str = [NSString stringWithFormat:@"%@", listModel.faulttype];
                [self.delegateSignal sendNext:@[listModel.faultID, str]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    if (tableView == self.tableView_fault) {
        self.isBgBtnExist = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.bgBtn.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.bgBtn removeFromSuperview];
        }];
        
        if (self.typeOfRow == SelectedType_First) {
            BXTFaultTypeGroup *model = self.faultArray[indexPath.row];
            self.groupView.faultTypeView.text = model.faulttype_type;
            self.indexOfRow = indexPath.row;
            
            self.typeView.faultTypeView.text = @"请选择故障类别";
        }
        else {
            if (indexPath.row <= self.faultArray.count - 1) {
                BXTFaultType *model = self.faultArray[indexPath.row];
                self.typeView.faultTypeView.text = model.faulttype;
                self.transFaulttypeID = model.faultID;
            }
            else {
                self.typeView.faultTypeView.text = @"其他";
                self.transFaulttypeID = @"";
            }
        }
    }
}

#pragma mark -
#pragma mark BXTDataResponseDelegate
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    [self hideMBP];
    
    NSDictionary *dic = response;
    NSArray *data = [dic objectForKey:@"data"];
    if (type == FaultType && data.count > 0) {
        
        NSMutableArray *groupArray = [[NSMutableArray alloc] init];
        NSMutableArray *faultType = [[NSMutableArray alloc] init];
        for (NSDictionary *groupDict in data) {
            BXTFaultTypeGroup *group = [BXTFaultTypeGroup modelWithDict:groupDict];
            [groupArray addObject:group];
            
            
            NSArray *subData = groupDict[@"sub_data"];
            NSMutableArray *faultArray = [[NSMutableArray alloc] init];
            for (NSDictionary *faultDict in subData) {
                BXTFaultType *type = [BXTFaultType modelWithDict:faultDict];
                [faultArray addObject:type];
            }
            [faultType addObject:faultArray];
        }
        
        self.faultGroup = groupArray;
        self.faultType = faultType;
    }
    else if (type == AllFaultType) {
        [BXTGlobal writeFileWithfileName:@"AllFaultTypeList" Array:dic[@"data"]];
    }
}

- (void)requestError:(NSError *)error
{
    [self hideMBP];
}

#pragma mark -
#pragma mark - 方法
// 取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 列表和搜索列表显示类
- (void)showHomeViewAndHideSearchTableView:(BOOL)isRight
{
    if (isRight) {
        self.tableView_Search.hidden = YES;
        self.bgView.hidden = NO;
        self.remindLabel.hidden = YES;
    } else {
        self.tableView_Search.hidden = NO;
        self.bgView.hidden = YES;
    }
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
