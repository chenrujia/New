//
//  BXTMyIntegralData.h
//  YouFeel
//
//  Created by 满孝意 on 16/4/5.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ComplateData,PraiseData;
@interface BXTMyIntegralData : NSObject

@property (nonatomic, strong) NSArray<PraiseData *> *praise_data;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) NSArray<ComplateData *> *complate_data;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *returncode;

@property (nonatomic, copy) NSString *ranking;

@property (nonatomic, copy) NSString *total_score;

@end
@interface ComplateData : NSObject

@property (nonatomic, copy) NSString *total;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *percent;

@property (nonatomic, copy) NSString *over;

@end

@interface PraiseData : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *percent;

@property (nonatomic, copy) NSString *score;

@end

