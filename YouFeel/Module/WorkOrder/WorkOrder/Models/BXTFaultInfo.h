//
//  BXTFaultInfo.h
//  BXT
//
//  Created by Jason on 15/9/6.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTFaultInfo : NSObject

@property (nonatomic ,strong) NSString *fault_id;
@property (nonatomic ,strong) NSString *faulttype_type;
@property (nonatomic ,strong) NSArray  *sub_data;

@end
