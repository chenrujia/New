//
//  BXTNewWorkOrderViewController.m
//  YouFeel
//
//  Created by Jason on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTNewWorkOrderViewController.h"
#import "BXTAttributeView.h"
#import "UIView+Extnesion.h"
#import "BXTOrderTypeInfo.h"
#import "BXTSearchPlaceViewController.h"

@interface BXTNewWorkOrderViewController ()<AttributeViewDelegate,BXTDataResponseDelegate,UITextFieldDelegate>

@end

@implementation BXTNewWorkOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetting:@"我要报修" andRightTitle:nil andRightImage:nil];
    _commitBtn.layer.cornerRadius = 4.f;
    [_placeTF setValue:colorWithHexString(@"#3cafff") forKeyPath:@"_placeholderLabel.textColor"];
    [_placeTF setValue:[UIFont systemFontOfSize:20.f] forKeyPath:@"_placeholderLabel.font"];
    _placeTF.delegate = self;
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        /** 工单类型 **/
        BXTDataRequest *request = [[BXTDataRequest alloc] initWithDelegate:self];
        [request orderTypeList];
    });
}

- (IBAction)commitOrder:(id)sender
{
    
}

#pragma mark -
#pragma mark AttributeViewDelegate
- (void)attributeViewSelectType:(BXTOrderTypeInfo *)selectType
{
    NSLog(@"title:.....%@",selectType.faulttype);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BXTSearchPlaceViewController *searchVC = [[BXTSearchPlaceViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

- (void)requestResponseData:(id)response requeseType:(RequestType)type
{
    NSDictionary *dic = response;
    LogRed(@"dic......%@",dic);
    if (type == OrderFaultType)
    {
        NSArray *data = [dic objectForKey:@"data"];
        [BXTOrderTypeInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"orderTypeID":@"id"};
        }];
        NSMutableArray *orderListArray = [NSMutableArray array];
        [orderListArray addObjectsFromArray:[[[BXTOrderTypeInfo mj_objectArrayWithKeyValuesArray:data] reverseObjectEnumerator] allObjects]];
        
        BXTAttributeView *attView = [BXTAttributeView attributeViewWithTitleFont:[UIFont boldSystemFontOfSize:17] attributeTexts:orderListArray viewWidth:SCREEN_WIDTH];
        attView.y = 0;
        _order_type_height.constant = attView.height;
        [_orderTypeBV layoutIfNeeded];
        attView.attribute_delegate = self;
        [self.orderTypeBV addSubview:attView];
    }
}

- (void)requestError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
