//
//  DES3Util.h
//  BaYingHe
//
//  Created by 司林满 on 14-1-15.
//  Copyright (c) 2014年 司林满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject
{
    
}
// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

@end
