//
//  BXTGroupingInfo.h
//  BXT
//
//  Created by Jason on 15/9/19.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTManInfo;

@interface BXTGroupingInfo : NSObject

@property (nonatomic, copy  ) NSString   *del_state;
@property (nonatomic, copy  ) NSString   *group_id;
@property (nonatomic, strong) NSArray<BXTManInfo *> *user_lists;
@property (nonatomic, copy  ) NSString   *subgroup;

@end

@interface BXTManInfo : NSObject

@property (nonatomic, copy  ) NSString  *manID;
@property (nonatomic, assign) NSInteger work_number;
@property (nonatomic, copy  ) NSString  *name;
@property (nonatomic, copy  ) NSString  *on_duty;
@property (nonatomic, copy  ) NSString  *head_pic;

@end

