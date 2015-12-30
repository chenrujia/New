//
//  BXTEquipmentPic.m
//
//  Created by 孝意 满 on 15/12/30
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BXTEquipmentPic.h"


NSString *const kBXTEquipmentPicId = @"id";
NSString *const kBXTEquipmentPicUploadTime = @"upload_time";
NSString *const kBXTEquipmentPicPhotoThumbFile = @"photo_thumb_file";
NSString *const kBXTEquipmentPicPhotoFile = @"photo_file";


@interface BXTEquipmentPic ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BXTEquipmentPic

@synthesize picIdentifier = _picIdentifier;
@synthesize uploadTime = _uploadTime;
@synthesize photoThumbFile = _photoThumbFile;
@synthesize photoFile = _photoFile;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.picIdentifier = [self objectOrNilForKey:kBXTEquipmentPicId fromDictionary:dict];
            self.uploadTime = [self objectOrNilForKey:kBXTEquipmentPicUploadTime fromDictionary:dict];
            self.photoThumbFile = [self objectOrNilForKey:kBXTEquipmentPicPhotoThumbFile fromDictionary:dict];
            self.photoFile = [self objectOrNilForKey:kBXTEquipmentPicPhotoFile fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.picIdentifier forKey:kBXTEquipmentPicId];
    [mutableDict setValue:self.uploadTime forKey:kBXTEquipmentPicUploadTime];
    [mutableDict setValue:self.photoThumbFile forKey:kBXTEquipmentPicPhotoThumbFile];
    [mutableDict setValue:self.photoFile forKey:kBXTEquipmentPicPhotoFile];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.picIdentifier = [aDecoder decodeObjectForKey:kBXTEquipmentPicId];
    self.uploadTime = [aDecoder decodeObjectForKey:kBXTEquipmentPicUploadTime];
    self.photoThumbFile = [aDecoder decodeObjectForKey:kBXTEquipmentPicPhotoThumbFile];
    self.photoFile = [aDecoder decodeObjectForKey:kBXTEquipmentPicPhotoFile];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_picIdentifier forKey:kBXTEquipmentPicId];
    [aCoder encodeObject:_uploadTime forKey:kBXTEquipmentPicUploadTime];
    [aCoder encodeObject:_photoThumbFile forKey:kBXTEquipmentPicPhotoThumbFile];
    [aCoder encodeObject:_photoFile forKey:kBXTEquipmentPicPhotoFile];
}

- (id)copyWithZone:(NSZone *)zone
{
    BXTEquipmentPic *copy = [[BXTEquipmentPic alloc] init];
    
    if (copy) {

        copy.picIdentifier = [self.picIdentifier copyWithZone:zone];
        copy.uploadTime = [self.uploadTime copyWithZone:zone];
        copy.photoThumbFile = [self.photoThumbFile copyWithZone:zone];
        copy.photoFile = [self.photoFile copyWithZone:zone];
    }
    
    return copy;
}


@end
