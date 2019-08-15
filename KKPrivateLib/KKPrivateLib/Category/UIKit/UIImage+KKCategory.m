//
//  UIImage+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UIImage+KKCategory.h"
#import <Accelerate/Accelerate.h>


static NSCache *imageCache;

/* Number of components for an opaque grey colorSpace = 3 */
#define SNumberOfComponentsPerGreyPixel 3
/* Number of components for an ARGB pixel (Alpha / Red / Green / Blue) = 4 */
#define SNumberOfComponentsPerARBGPixel 4
/* Minimun value for a pixel component */
#define SMinPixelComponentValue (UInt8)0
/* Maximum value for a pixel component */
#define sMaxPixelComponentValue (UInt8)255

#pragma mark -

static CGColorSpaceRef __rgbColorSpace = NULL;

/// Use the generic RGB color space
/// We avoid the NULL check because CGColorSpaceRelease() NULL check the value anyway, and worst case scenario = fail to create context
/// Create the bitmap context, we want pre-multiplied ARGB, 8-bits per component
CGContextRef KKCreateARGBBitmapContext(const size_t width, const size_t height, const size_t bytesPerRow, BOOL withAlpha) {
    CGImageAlphaInfo alphaInfo = (withAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | alphaInfo);
    CGColorSpaceRelease(colorSpace);
    return bmContext;
}

// The following function was taken from the increadibly awesome HockeyKit
// Created by Peter Steinberger on 10.01.11.
// Copyright 2012 Peter Steinberger. All rights reserved.
CGImageRef KKCreateGradientImage(const size_t pixelsWide, const size_t pixelsHigh, const CGFloat fromAlpha, const CGFloat toAlpha) {
    // gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // create the bitmap context
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    // define the start and end grayscale values (with the alpha, even though
    // our bitmap context doesn't support alpha the gradient requires it)
    CGFloat colors[] = {toAlpha, 1.0f, fromAlpha, 1.0f};
    
    // create the CGGradient and then release the gray color space
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    // create the start and end points for the gradient vector (straight down)
    CGPoint gradientEndPoint = CGPointZero;
    CGPoint gradientStartPoint = (CGPoint){.x = 0.0f, .y = pixelsHigh};
    
    // draw the gradient into the gray bitmap context
    CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(grayScaleGradient);
    
    // convert the context into a CGImageRef and release the context
    CGImageRef theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
    CGContextRelease(gradientBitmapContext);
    
    // return the imageref containing the gradient
    return theCGImage;
}

CGColorSpaceRef KKGetRGBColorSpace(void) {
    if (!__rgbColorSpace) __rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    return __rgbColorSpace;
}

BOOL KKImageHasAlpha(CGImageRef imageRef) {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
    return hasAlpha;
}

static int16_t __s_gaussianblur_kernel_5x5[25] = {
    1, 4, 6, 4, 1,
    4, 16, 24, 16, 4,
    6, 24, 36, 24, 6,
    4, 16, 24, 16, 4,
    1, 4, 6, 4, 1
};
@implementation UIImage (KKCategory)

#pragma mark - Function

///=============================================================================
/// @name Bluring
///=============================================================================

- (UIImage *)kkGaussianBlurWithBias:(NSInteger)bias {
    // TODO: is invalid
    
    /// Create an ARGB bitmap context
    const size_t width = (size_t)self.size.width;
    const size_t height = (size_t)self.size.height;
    const size_t bytesPerRow = width * SNumberOfComponentsPerARBGPixel;
    CGContextRef bmContext = KKCreateARGBBitmapContext(width, height, bytesPerRow, KKImageHasAlpha(self.CGImage));
    if (!bmContext) return nil;
    
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    
    /// Grab the image raw data
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data) {
        CGContextRelease(bmContext);
        return nil;
    }
    
    const size_t n = sizeof(UInt8) * width * height * 4;
    void* outt = malloc(n);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {outt, height, width, bytesPerRow};
    vImageConvolveWithBias_ARGB8888(&src, &dest, NULL, 0, 0, __s_gaussianblur_kernel_5x5, 5, 5, 256, (int32_t)bias, NULL, kvImageCopyInPlace);
    memcpy(data, outt, n);
    free(outt);
    
    CGImageRef blurredImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* blurred = [UIImage imageWithCGImage:blurredImageRef];
    
    CGImageRelease(blurredImageRef);
    CGContextRelease(bmContext);
    
    return blurred;
}

///=============================================================================
/// @name Enhancing
///=============================================================================

- (UIImage *)kkAautoEnhance {
    return [self kkEnhanceWithKey:kCIImageAutoAdjustEnhance];
}

- (UIImage *)kkRedEyeCorrection {
    return [self kkEnhanceWithKey:kCIImageAutoAdjustRedEye];
}

- (UIImage *)kkEnhanceWithKey:(NSString *)kCIImageAutoAdjustKey {
    if (![CIImage class]) return self;
    CIImage* ciImage = [[CIImage alloc] initWithCGImage:self.CGImage];
    NSArray* filters = [ciImage autoAdjustmentFiltersWithOptions:@{kCIImageAutoAdjustKey:@(NO)}];
    for (CIFilter* filter in filters) {
        [filter setValue:ciImage forKey:kCIInputImageKey];
        ciImage = filter.outputImage;
    }
    CIContext* ctx = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ctx createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage* final = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return final;
}

///=============================================================================
/// @name Reflection
///=============================================================================

- (UIImage *)kkReflectWithHeight:(NSUInteger)height
                       fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha {
    if (!height) return nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){.width=self.size.width, .height=height}, NO, .0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef gradientMaskImage = KKCreateGradientImage(1, height, fromAlpha, toAlpha);
    
    // create an image by masking the bitmap of the mainView content with the gradient view
    // then release the  pre-masked content bitmap and the gradient bitmap
    CGContextClipToMask(context, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = self.size.width, .size.height = height}, gradientMaskImage);
    CGImageRelease(gradientMaskImage);
    
    // draw the image into the bitmap context
    CGContextDrawImage(context, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size = self.size}, self.CGImage);
    
    // convert the finished reflection image to a UIImage
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

///=============================================================================
/// @name Rotation
///=============================================================================

- (UIImage *)kkImageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize {
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    CGRect newRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height),
                                                fitSize ? CGAffineTransformMakeRotation(radians) : CGAffineTransformIdentity);
    
    CGColorSpaceRef colorSpace = KKGetRGBColorSpace();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 (size_t)newRect.size.width,
                                                 (size_t)newRect.size.height,
                                                 8,
                                                 (size_t)newRect.size.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, +(newRect.size.width * 0.5), +(newRect.size.height * 0.5));
    CGContextRotateCTM(context, radians);
    
    CGContextDrawImage(context, CGRectMake(-(width * 0.5), -(height * 0.5), width, height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CGContextRelease(context);
    return img;
}

- (UIImage *)kkImageByRotateLeft90 {
    return [self kkImageByRotate:KKDegreesToRadians(90) fitSize:YES];
}

- (UIImage *)kkImageByRotateRight90 {
    return [self kkImageByRotate:KKDegreesToRadians(-90) fitSize:YES];
}

- (UIImage *)kkImageByRotate180 {
    return [self _kkFlipHorizontal:YES vertical:YES];
}

- (UIImage *)kkImageByFlipVertical {
    return [self _kkFlipHorizontal:NO vertical:YES];
}

- (UIImage *)kkImageByFlipHorizontal {
    return [self _kkFlipHorizontal:YES vertical:NO];
}

- (UIImage *)_kkFlipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if (!self.CGImage) return nil;
    const size_t width  = (size_t)CGImageGetWidth(self.CGImage);
    const size_t height = (size_t)CGImageGetHeight(self.CGImage);
    const size_t bytesPerRow = width * SNumberOfComponentsPerARBGPixel;
    CGContextRef context = KKCreateARGBBitmapContext(width, height, bytesPerRow, KKImageHasAlpha(self.CGImage));
    if (!context) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(context);
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    vImage_Buffer src = { data, height, width, bytesPerRow };
    vImage_Buffer dest = { data, height, width, bytesPerRow };
    if (vertical) {
        vImageVerticalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    if (horizontal) {
        vImageHorizontalReflect_ARGB8888(&src, &dest, kvImageBackgroundColorFill);
    }
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    
    return img;
}

#pragma mark - Resizing
///=============================================================================
/// @name Resizing
///=============================================================================

- (UIImage *)kkImageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color {
    // TODO: Fix it
    CGSize size = self.size;
    size.width -= (insets.left + insets.right);
    size.height -= (insets.top + insets.bottom);
    if (size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(insets.left, insets.top, size.width-40, size.height-40);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (color) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, self.size.width, self.size.height));
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(context, path);
        CGContextEOFillPath(context);
        CGPathRelease(path);
    }
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - Image Effect
///=============================================================================
/// @name Image Effect
///=============================================================================

- (UIImage *)kkImageByTintColor:(UIColor *)color {
    // TODO: more blendMode info
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [color setFill];
    UIRectFill(rect);
    // GrayScale Info
    [self drawInRect:rect blendMode:kCGBlendModeOverlay alpha:1];
    // Transparency Info
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)kkRoundRectWithRadius:(CGFloat)r width:(CGFloat)w height:(CGFloat)h color:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, w, h);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 开始一个Image的上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 2.0);
    // 添加圆角r
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:r] addClip];
    // 绘制图片
    [image drawInRect:rect];
    // 接受绘制成功的图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)kkRoundWithRadius:(CGFloat)r width:(CGFloat)w height:(CGFloat)h color:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, w-4, h-4);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2.0);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:(h-4)/2.0];
    aPath.lineWidth = 1.0;
    [color set];
    [aPath stroke];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  实现原理:创建一个1x1的UIImage
 */
+ (UIImage *)kkImageFromColor:(UIColor *)color {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
    });
    
    UIImage *image = [imageCache objectForKey:color];
    if (image) {
        return image;
    }
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageCache setObject:image forKey:color];
    return image;
}

- (id)kkRoundedRectSize:(CGSize)size radius:(NSInteger)r {
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight) {
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

//- (UIImage *)kkImageByGrayscale {
//
//}

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

- (CGFloat)kkWidth {
    return self.size.width;
}

- (CGFloat)kkHeight {
    return self.size.height;
}

- (CGFloat)kkRatio {
    if (!self) return 0;
    return self.size.width/self.kkHeight;
}

@end
