//
//  BXTEnergyReadingFilterInfo.m
//  YouFeel
//
//  Created by 满孝意 on 16/7/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "BXTEnergyReadingFilterInfo.h"

@implementation BXTEnergyReadingFilterInfo

+ (NSDictionary *)objectClassInArray
{
    return @{@"lists" : [BXTEnergyReadingFilterInfo class]};
}

- (void)setFilterID:(NSString *)filterID
{
    _filterID = filterID;
    
    self.itemID = filterID;
}

@end
