//
//  BXTNoneEVInfo.h
//  YouFeel
//
//  Created by Jason on 15/10/16.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXTNoneEVInfo : NSObject

@property (nonatomic ,strong) NSString  *area;
@property (nonatomic ,strong) NSString  *cause;
@property (nonatomic ,strong) NSString  *evaluation_notes;
@property (nonatomic ,strong) NSArray   *fixed_pic;
@property (nonatomic ,assign) NSInteger general_praise;
@property (nonatomic ,strong) NSString  *evaID;
@property (nonatomic ,assign) NSInteger man_hours;
@property (nonatomic ,strong) NSString  *orderid;
@property (nonatomic ,strong) NSString  *place;
@property (nonatomic ,assign) NSInteger state;
@property (nonatomic ,strong) NSString  *state_name;
@property (nonatomic ,assign) NSInteger workprocess;

@end
