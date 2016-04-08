//
//  BXTPlaceInfo.m
//  YouFeel
//
//  Created by 满孝意 on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTPlaceInfo.h"

@implementation BXTPlaceInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"lists" : [BXTPlaceInfo class]};
}

- (void)setPlace:(NSString *)place
{
    _place = [place copy];
    self.name = place;
}

@end

