//
//  BXTEnergyClassificationViewController.m
//  YouFeel
//
//  Created by Jason on 16/7/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyClassificationViewController.h"
#import "BXTHeaderFile.h"
#import "BXTMenuItemButton.h"
#import "UIImage+SubImage.h"
#import "BXTCustomButton.h"
#import "BXTSelectItemView.h"
#import "ANKeyValueTable.h"

#define KBUTTONHEIGHT 46.f
#define METERTABLETAG 666
#define PRICETABLETAG 888

@interface BXTEnergyClassificationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BXTMenuItemButton *btnOne;
    BXTMenuItemButton *btnTwo;
    BXTMenuItemButton *btnThree;
    BXTMenuItemButton *btnFour;
    UIView *leftView;
    UIView *rightView;
}

@property (nonatomic, strong) NSArray *colorArray;
//抄表方式数据
@property (nonatomic, strong) NSMutableArray *meterArray;
//价格类型数据
@property (nonatomic, strong) NSMutableArray *priceArray;
@property (nonatomic, strong) BXTSelectItemView *chooseItemView;

@end

@implementation BXTEnergyClassificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"能源抄表" backColor:colorWithHexString(@"f45b5b") rightImage:[UIImage imageNamed:@"scan"]];
    [self initialEnergyClass];
    [self initialSearchBarAndFilter];
    [self requestDatasoure];
}

//电能、水、燃气、热能
- (void)initialEnergyClass
{
    self.colorArray = @[colorWithHexString(@"f45b5b"),colorWithHexString(@"1683e2"),colorWithHexString(@"ded100"),colorWithHexString(@"f1983e")];
    self.view.backgroundColor = self.colorArray[0];
    
    CGFloat width = (SCREEN_WIDTH - 20.f)/4.f;
    
    btnOne = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawMiddle backgroudColor:self.colorArray[0]];
    btnOne.tag = 0;
    [btnOne setTitle:@"电能" forState:UIControlStateNormal];
    [btnOne setTitleColor:self.colorArray[0] forState:UIControlStateNormal];
    [btnOne addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOne];
    
    btnTwo = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f + width, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawLeft backgroudColor:[UIColor whiteColor]];
    btnTwo.drawColor = self.colorArray[0];
    btnTwo.tag = 1;
    [btnTwo setTitle:@"水" forState:UIControlStateNormal];
    [btnTwo setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
    [btnTwo addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTwo];
    
    btnThree = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f + 2.f * width, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawNot backgroudColor:self.colorArray[0]];
    btnThree.tag = 2;
    [btnThree setTitle:@"燃气" forState:UIControlStateNormal];
    [btnThree setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
    [btnThree addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnThree];
    
    btnFour = [[BXTMenuItemButton alloc] initWithFrame:CGRectMake(10.f + 3.f * width, KNAVIVIEWHEIGHT, width, KBUTTONHEIGHT) drawType:DrawNot backgroudColor:self.colorArray[0]];
    btnFour.tag = 3;
    [btnFour setTitle:@"热能" forState:UIControlStateNormal];
    [btnFour setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
    [btnFour addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFour];
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(btnOne.frame), 10.f, 10.f)];
    leftView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftView];
}

//大白色背景、搜索框、筛选条件按钮
- (void)initialSearchBarAndFilter
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10.f, CGRectGetMaxY(btnOne.frame), SCREEN_WIDTH - 20.f, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - KBUTTONHEIGHT - 10.f)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 10.f;
    [self.view addSubview:backView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 6.f, CGRectGetWidth(backView.frame), 44.f)];
    searchBar.placeholder = @"搜索";
    searchBar.layer.masksToBounds = YES;
    searchBar.layer.cornerRadius = 27.f;
    UIImage *searchBarBg = [UIImage imageWithColor:[UIColor whiteColor] andHeight:46.0f];
    UIImage *fontBg = [UIImage imageWithColor:colorWithHexString(@"DCDCDC") andHeight:32.f];
    //设置背景图片
    [searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    //设置文本框背景
    [searchBar setSearchFieldBackgroundImage:fontBg forState:UIControlStateNormal];
    [backView addSubview:searchBar];
    
    NSArray *titles = @[@"抄表方式",@"价格类型",@"安装位置",@"筛选"];
    NSArray *images = @[@"select_triangle",@"select_triangle",@"select_triangle",@"filter"];
    for (NSInteger i = 0; i < 4; i++)
    {
        BXTCustomButton *meterTypeBtn = [[BXTCustomButton alloc] initWithType:EnergyBtnType];
        meterTypeBtn.tag = i;
        if (i == 3)
        {
            meterTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            meterTypeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        }
        meterTypeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [meterTypeBtn setFrame:CGRectMake(i * (CGRectGetWidth(backView.frame)/4.f), CGRectGetMaxY(searchBar.frame), CGRectGetWidth(backView.frame)/4.f, 44.f)];
        [meterTypeBtn setTitle:titles[i] forState:UIControlStateNormal];
        [meterTypeBtn setTitleColor:colorWithHexString(@"#6E6E6E") forState:UIControlStateNormal];
        [meterTypeBtn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [meterTypeBtn addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:meterTypeBtn];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame) + 44.f, CGRectGetWidth(backView.frame), 0.7f)];
    lineView.backgroundColor = colorWithHexString(@"e2e6e8");
    [backView addSubview:lineView];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20.f, CGRectGetMaxY(btnOne.frame), 10.f, 10.f)];
    rightView.backgroundColor = [UIColor whiteColor];
    rightView.hidden = YES;
    [self.view addSubview:rightView];
}

- (void)initialTableView:(NSInteger)tag
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    UITableView *currentTable = [[UITableView alloc] initWithFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT + KBUTTONHEIGHT + 93.f, SCREEN_WIDTH - 20.f, 0.f) style:UITableViewStylePlain];
    [currentTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EnergyCell"];
    currentTable.tag = tag;
    currentTable.delegate = self;
    currentTable.dataSource = self;
    [backView addSubview:currentTable];
    
    [UIView animateWithDuration:0.3f animations:^{
        [currentTable setFrame:CGRectMake(10.f, KNAVIVIEWHEIGHT + KBUTTONHEIGHT + 90.f, SCREEN_WIDTH - 20.f, SCREEN_HEIGHT - KNAVIVIEWHEIGHT - KBUTTONHEIGHT - 100.f)];
    }];
}

- (void)initialPlaceOrFilter:(NSArray *)datasource
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6f;
    backView.tag = 101;
    [self.view addSubview:backView];
    
    CGRect viewRect = CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT);
    CGRect tableRect =  CGRectMake(0, 20, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT - 20.f - 64.f);
    
    __weak __typeof(self) weakSelf = self;
    self.chooseItemView = [[BXTSelectItemView alloc] initWithFrame:viewRect tableViewFrame:tableRect datasource:datasource isProgress:NO type:PlaceSearchType block:^(BXTBaseClassifyInfo *classifyInfo, NSString *name) {
        UIView *view = [weakSelf.view viewWithTag:101];
        [view removeFromSuperview];
        [UIView animateWithDuration:0.3f animations:^{
            [weakSelf.chooseItemView setFrame:CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            [weakSelf.chooseItemView removeFromSuperview];
            weakSelf.chooseItemView = nil;
        }];
    }];
    self.chooseItemView.backgroundColor = colorWithHexString(@"eff3f6");
    [self.view addSubview:self.chooseItemView];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.chooseItemView setFrame:CGRectMake(SCREEN_WIDTH/4.f, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
    }];
}

- (void)requestDatasoure
{
    self.meterArray = [[NSMutableArray alloc] initWithObjects:@"抄表方式1",@"抄表方式2",@"抄表方式3",@"抄表方式4",@"抄表方式5",@"抄表方式6", nil];
    self.priceArray = [[NSMutableArray alloc] initWithObjects:@"100",@"200",@"500",@"1000",@"2000",@"5000", nil];
}

- (void)menuButtonClick:(UIButton *)btn
{
    self.view.backgroundColor = self.colorArray[btn.tag];
    [self navigationSetting:nil backColor:self.colorArray[btn.tag] rightImage:nil];
    [btn setTitleColor:self.colorArray[btn.tag] forState:UIControlStateNormal];
    
    if (btn == btnOne)
    {
        leftView.hidden = NO;
        rightView.hidden = YES;
        
        [btnTwo setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        [btnThree setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        [btnFour setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        
        [btnOne changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
        [btnTwo changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawLeft];
        [btnThree changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [btnFour changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
    }
    else if (btn == btnTwo)
    {
        leftView.hidden = YES;
        rightView.hidden = YES;
        
        [btnOne setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        [btnThree setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        [btnFour setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        
        [btnOne changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawRight];
        [btnTwo changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
        [btnThree changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawLeft];
        [btnFour changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
    }
    else if (btn == btnThree)
    {
        leftView.hidden = YES;
        rightView.hidden = YES;
        
        [btnOne setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        [btnTwo setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        [btnFour setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        
        [btnOne changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [btnTwo changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawRight];
        [btnThree changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
        [btnFour changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawLeft];
    }
    else if (btn == btnFour)
    {
        leftView.hidden = YES;
        rightView.hidden = NO;
        
        [btnOne setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        [btnTwo setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        [btnThree setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateNormal];
        
        [btnOne changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [btnTwo changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawNot];
        [btnThree changeDrawColor:self.colorArray[btn.tag] backgroudColor:[UIColor whiteColor] drawType:DrawRight];
        [btnFour changeDrawColor:[UIColor whiteColor] backgroudColor:self.colorArray[btn.tag] drawType:DrawMiddle];
    }
}

- (void)filterButtonClick:(UIButton *)btn
{
    if (btn.tag == 0)
    {
        [self initialTableView:METERTABLETAG];
    }
    else if (btn.tag == 1)
    {
        [self initialTableView:PRICETABLETAG];
    }
    else if (btn.tag == 2)
    {
        NSArray *datasource = [[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE];
        [self initialPlaceOrFilter:datasource];
    }
    else if (btn.tag == 3)
    {
        //TODO: 这里的数据是假的，是接口返回的筛选条件
        NSArray *datasource = [[ANKeyValueTable userDefaultTable] valueWithKey:YPLACESAVE];
        [self initialPlaceOrFilter:datasource];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if (view.tag == 101)
    {
        [view removeFromSuperview];
        if (self.chooseItemView)
        {
            [UIView animateWithDuration:0.3f animations:^{
                [self.chooseItemView setFrame:CGRectMake(SCREEN_WIDTH, 0.f, SCREEN_WIDTH/4.f * 3.f, SCREEN_HEIGHT)];
            } completion:^(BOOL finished) {
                [self.chooseItemView removeFromSuperview];
                self.chooseItemView = nil;
            }];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == METERTABLETAG)
    {
        return self.meterArray.count;
    }
    else if (tableView.tag == PRICETABLETAG)
    {
        return self.priceArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnergyCell" forIndexPath:indexPath];
    
    if (tableView.tag == METERTABLETAG)
    {
        cell.textLabel.text = self.meterArray[indexPath.row];
    }
    else if (tableView.tag == PRICETABLETAG)
    {
        cell.textLabel.text = self.priceArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIView *view = [self.view viewWithTag:101];
    if (view)
    {
       [view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
