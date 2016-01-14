//
//  BXTCheckProjectInfo.h
//  YouFeel
//
//  Created by Jason on 16/1/8.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTCheckProjectInfo : NSObject

@property (nonatomic, strong) NSString *check_con;
@property (nonatomic, strong) NSString *check_key;
@property (nonatomic, strong) NSString *default_description;
//额外添加(服务器并没有返回)
@property (nonatomic, strong) NSString *project_name;

@end
