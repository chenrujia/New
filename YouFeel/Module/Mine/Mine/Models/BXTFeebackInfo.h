//
//  BXTFeebackInfo.h
//  YouFeel
//
//  Created by Jason on 16/3/9.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXTCommentInfo;

@interface BXTFeebackInfo : NSObject

@property (nonatomic, copy) NSString *feebackID;
@property (nonatomic, copy) NSString *send_pic;
@property (nonatomic, copy) NSString *upload_data;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *send_user;
@property (nonatomic, strong) NSArray<BXTCommentInfo *> *sub_comment_list;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *about_id;
@property (nonatomic, copy) NSString *send_username;
@property (nonatomic, copy) NSString *content;

@end

@interface BXTCommentInfo : NSObject

@property (nonatomic, copy) NSString *commentID;
@property (nonatomic, copy) NSString *send_pic;
@property (nonatomic, copy) NSString *upload_data;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *send_user;
@property (nonatomic, strong) NSArray *sub_comment_list;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *about_id;
@property (nonatomic, copy) NSString *send_username;
@property (nonatomic, copy) NSString *content;

@end

