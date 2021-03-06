//
//  UIImage+SubImage.m
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//

#import "UIImage+SubImage.h"

@implementation UIImage (SubImage)

#pragma mark 返回拉伸好的图片
+ (UIImage *)resizeImage:(NSString *)imgName
{
    return [[UIImage imageNamed:imgName] resizeImage];
}

- (UIImage *)resizeImage
{
    CGFloat leftCap = self.size.width * 0.5f;
    CGFloat topCap = self.size.height * 0.5f;
    return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)subImageWithRect:(CGRect)rect
{
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

#pragma mark 指定size，获取新的iamge对象
- (UIImage *)rescaleImageToSize:(CGSize)size
{
    CGRect rect = (CGRect){CGPointZero, size};
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect]; // scales image to rect
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

#pragma mark 指定大小生成一个平铺的图片
- (UIImage *)getTiledImageWithSize:(CGSize)size
{
    UIView *tempView = [[UIView alloc] init];
    tempView.bounds = (CGRect){CGPointZero, size};
    tempView.backgroundColor = [UIColor colorWithPatternImage:self];
    
    UIGraphicsBeginImageContext(size);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return bgImage;
}

+ (NSData *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);

    return thumbImageData;
}

#pragma mark - 压缩图片至指定像素
- (UIImage *)rescaleImageToPX:(CGFloat )toPX
{
    //等比缩放
    CGSize size = self.size;
    if(size.width < toPX && size.height < toPX)
        return self;
    
    CGFloat scale = size.width / size.height;
    if(size.width > size.height){
        size.width = toPX;
        size.height = size.width / scale;
    }else{
        size.height = toPX;
        size.width = size.height * scale;
    }
    
    UIImage *img = [self rescaleImageToSize:size];
    
    //图片质量
    return [UIImage imageWithData:UIImageJPEGRepresentation(img, 0.7)];
}

+ (UIImage *)zoomImage:(UIImage *)image toSize:(CGSize)size
{
    static UIImage *newImage;
    if (image.size.width > size.width || image.size.height > size.height)
    {
        if (image.size.width >=  image.size.height)
        {
            float scale = image.size.width/size.width;
            float height = image.size.height/scale;
            newImage = [image imageByScalingToSize:CGSizeMake(size.width, height)];
        }
        else
        {
            float scale = image.size.height/size.height;
            float width = image.size.width/scale;
            newImage = [image imageByScalingToSize:CGSizeMake(width, size.height)];
        }
    }
    else
    {
        if (image.size.width >=  image.size.height)
        {
            float scale = size.width/image.size.width;
            float height = image.size.height*scale;
            newImage = [image imageByScalingToSize:CGSizeMake(size.width, height)];
        }
        else
        {
            float scale = size.height/image.size.height;
            float width = image.size.width*scale;
            newImage = [image imageByScalingToSize:CGSizeMake(width, size.height)];
        }
    }
    
    return newImage;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

#pragma mark 获取在ScaleAspectFit模式下，image所处imageView的frame
- (CGRect)frameOnScaleAspectFitModeWithViewSize:(CGSize)viewS{
    
    CGSize imageS = self.size;
    
    if(!(imageS.width && imageS.height && viewS.width && viewS.height)){
        return CGRectZero;
    }
    
    //等比缩放，image最大尺寸 等于view的对应边框尺寸
    CGFloat scale = imageS.width / imageS.height;
    if(imageS.width > imageS.height){
        imageS.width = viewS.width;
        imageS.height = imageS.width / scale;
    }else{
        imageS.height = viewS.height;
        imageS.width = imageS.height * scale;
    }
    
    CGFloat x = (viewS.width - imageS.width) * 0.5;
    CGFloat y = (viewS.height - imageS.height) * 0.5;
    
    return (CGRect){(CGPoint){x, y}, imageS};
}

#pragma mark 获取在ScaleAspectFill模式下，image显示部分的frame
- (CGRect)frameOnScaleAspectFillMode{
    CGSize size = self.size;
    CGFloat WH = (size.width < size.height) ? size.width : size.height;
    CGFloat X = (WH == size.width) ? 0 : (size.width - WH) * 0.5;
    CGFloat Y = (WH == size.height) ? 0 : (size.height - WH) * 0.5;
    return CGRectMake(X, Y, WH, WH);
}

+ (UIImage *)imageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
