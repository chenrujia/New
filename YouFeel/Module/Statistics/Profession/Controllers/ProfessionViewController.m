//
//  ProfessionViewController.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "ProfessionViewController.h"
#import "ProfessionHeader.h"
#import "ProfessionFooter.h"
#import "MYPieElement.h"

@interface ProfessionViewController ()

@property (nonatomic, strong) NSMutableArray *percentArrat;
@property (nonatomic, strong) MYPieView *pieView;

@end

@implementation ProfessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

#pragma mark -
#pragma mark - createUI
- (void)createUI {
    // ProfessionHeader
    ProfessionHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ProfessionHeader" owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 370);
    [self.rootScrollView addSubview:headerView];
    
    //  ---------- 饼状图 ----------
    // 1. create pieView
    CGFloat pieViewH = 230;
    self.pieView = [[MYPieView alloc] initWithFrame:CGRectMake(15, 90, SCREEN_WIDTH-30, pieViewH)];
    self.pieView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.pieView];
    
    self.percentArrat = [[NSMutableArray alloc] initWithObjects:@"25%", @"30%", @"45%", nil];
    NSArray *colorArray = [[NSArray alloc] initWithObjects:@"#0eccc0", @"#fbcf62", @"#ff6f6f", nil];
    // 2. fill data
    for(int i=0; i<self.percentArrat.count; i++){
        MYPieElement *elem = [MYPieElement pieElementWithValue:[self.percentArrat[i] floatValue] color:colorWithHexString(colorArray[i])];
        elem.title = [NSString stringWithFormat:@"%@", self.percentArrat[i]];
        [self.pieView.layer addValues:@[elem] animated:NO];
    }
    
    // 3. transform tilte
    self.pieView.layer.transformTitleBlock = ^(PieElement *elem, float percent){
        NSLog(@"percent -- %f", percent);
        return [(MYPieElement *)elem title];
    };
    self.pieView.layer.showTitles = ShowTitlesAlways;
    
    // 4. didClick
    self.pieView.transSelected = ^(NSInteger index) {
        NSLog(@"index -- %ld", index);
    };
    
    
    // ProfessionFooter
    ProfessionFooter *footerView = [[[NSBundle mainBundle] loadNibNamed:@"ProfessionFooter" owner:nil options:nil] lastObject];
    footerView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame)+10, SCREEN_WIDTH, 370);
    [self.rootScrollView addSubview:footerView];
    self.rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(footerView.frame));
    
    
    //  ---------- 柱状图 ----------
    BarTimeAxisView *barTAV = [[BarTimeAxisView alloc] initWithFrame:CGRectMake(-10, 70, SCREEN_WIDTH, 225)];
    barTAV.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [footerView addSubview:barTAV];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceReferenceDate:1];
    BarTimeAxisData *firstData = [BarTimeAxisData dataWithDate:nowDate andNumber:[NSNumber numberWithInt:3]];
    [dataArray addObject:firstData];
    
    for (int i=86400; i<864000; i+=86400) {
        int rand = 1+arc4random()%8;
        BarTimeAxisData *data = [BarTimeAxisData dataWithDate:[NSDate dateWithTimeInterval:i sinceDate:nowDate] andNumber:[NSNumber numberWithInt:rand+6]];
        [dataArray addObject:data];
    }
    
    barTAV.dataSource = dataArray;
    // barGraph.colorArray = @[@"#0dccc1", @"#fad063", @"#7c99db", @"fc7070"];
}

UIColor* colorWithHexString2(NSString *stringToConvert) {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.f];
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
