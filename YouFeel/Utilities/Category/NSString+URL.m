//
//  NSString+URL.m
//  WeiXinJingXuan
//
//  Created by tidoo on 15/1/21.
//  Copyright (c) 2015年 赵冬波. All rights reserved.
//

#import "NSString+URL.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (URL)

- (NSString *)URLEncodedString
{
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                  (CFStringRef)self,
                                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                  NULL,
                                                                                  kCFStringEncodingUTF8));
    return encodedString;
}

-(id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error != nil) return nil;
    return result;
}

- (NSString *)addressEncryption
{
    // see http://www.makebetterthings.com/iphone/how-to-get-md5-and-sha1-in-objective-c-ios-sdk/
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
