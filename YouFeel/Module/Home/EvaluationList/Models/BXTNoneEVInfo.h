//
//  BXTNoneEVInfo.h
//  YouFeel
//
//  Created by Jason on 15/10/16.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTNoneEVInfo : NSObject

@property (nonatomic ,copy  ) NSString  *area;
@property (nonatomic ,copy  ) NSString  *cause;
@property (nonatomic ,copy  ) NSString  *evaluation_notes;
@property (nonatomic ,strong) NSArray   *fixed_pic;
@property (nonatomic ,assign) NSInteger general_praise;
@property (nonatomic ,copy  ) NSString  *evaID;
@property (nonatomic ,assign) NSInteger man_hours;
@property (nonatomic ,copy  ) NSString  *orderid;
@property (nonatomic ,copy  ) NSString  *place;
@property (nonatomic ,assign) NSInteger state;
@property (nonatomic ,copy  ) NSString  *state_name;
@property (nonatomic ,assign) NSInteger workprocess;

@end
