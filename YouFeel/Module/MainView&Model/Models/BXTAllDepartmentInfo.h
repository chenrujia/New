//
//  BXTAllDepartmentInfo.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/8.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTAllDepartmentInfo : NSObject

@property (nonatomic, copy) NSString *del_state;
@property (nonatomic, copy) NSString *departmentID;
@property (nonatomic, copy) NSString *hq_id;
@property (nonatomic, strong) NSArray<BXTAllDepartmentInfo *> *lists;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *ppath;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *level;

@end

