//
//  NSString+URL.h
//  WeiXinJingXuan
//
//  Created by tidoo on 15/1/21.
//  Copyright (c) 2015年 赵冬波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

- (NSString *)URLEncodedString;

-(id)JSONValue;

- (NSString *)addressEncryption;

@end
