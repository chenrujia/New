//
//  BXTAchievementsViewController.m
//  YouFeel
//
//  Created by Jason on 15/10/14.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTAchievementsViewController.h"
#import "BXTHeaderForVC.h"
#import "BXTDataRequest.h"
#import "BXTAchievementsInfo.h"

@interface BXTAchievementsViewController ()<BXTDataResponseDelegate>
{
    NSMutableArray *datasource;
}
@end

@implementation BXTAchievementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationSetting:@"绩效" andRightTitle:nil andRightImage:nil];
    
    datasource = [[NSMutableArray alloc] init];
    BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
    [request achievementsList:6];
}

#pragma mark -
#pragma mark 代理
- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dictionary = response;
    LogRed(@"dictionary :%@",dictionary);
    NSArray *array = [dictionary objectForKey:@"data"];
    for (NSDictionary *dictionary in array)
    {
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[BXTAchievementsInfo class] andConfiguration:config];
        BXTAchievementsInfo *achievementsInfo = [parser parseDictionary:dictionary];
        
        [datasource addObject:achievementsInfo];
    }
}

- (void)requestError:(NSError *)error
{
    
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
