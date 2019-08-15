//
//  UIColor+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/12.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UIColor+KKCategory.h"
#import "NSString+KKCategory.h"

@implementation UIColor (KKCategory)

static BOOL KKHexStrToRGBA(NSString *str,
                           CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [[str kkStringByTrim] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = KKHexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = KKHexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = KKHexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = KKHexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = KKHexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = KKHexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = KKHexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = KKHexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

static inline NSUInteger KKHexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

#pragma mark - Create a UIColor Object
///=============================================================================
/// @name Creating a UIColor Object
///=============================================================================

+ (instancetype)kkColorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (KKHexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

#pragma mark - Function
///=============================================================================
/// @name Function
///=============================================================================

+ (UIColor *)kkAverageColorFromImage:(UIImage *)image {
    return [UIColor kkAverageColorFromImage:image alpha:1.0];
}

+ (UIColor *)kkAverageColorFromImage:(UIImage *)image alpha:(CGFloat)alpha {
    //Work within the RGB colorspoace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //Draw our image down to 1x1 pixels
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    CGFloat multiplier = (1.0/255.0);
    if (rgba[3] == 0) {
        // TO FIX: ??
        alpha = ((CGFloat)rgba[3])/255.0;
        multiplier *= alpha;
    }
    UIColor *averageColor = [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                                            green:((CGFloat)rgba[1])*multiplier
                                             blue:((CGFloat)rgba[2])*multiplier
                                            alpha:alpha];
    averageColor = [averageColor kkColorWithMinSaturation:0.15];
    return averageColor;
}

+ (UIColor *)kkColorFromImage:(UIImage *)image atPoint:(CGPoint)point {
    //Encapsulate our image
    CGImageRef imageRef = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    //Specify the colorspace we're in
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //Extract the data we need
    unsigned char *rawData = calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow,
                                                 colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    //Release colorspace
    CGColorSpaceRelease(colorSpace);
    
    //Draw and release image
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    //rawData now contains the image data in RGBA8888
    NSInteger byteIndex = (bytesPerRow * point.y) + (point.x * bytesPerPixel);
    
    //Define our RGBA values
    CGFloat red = (rawData[byteIndex] * 1.f) / 255.f;
    CGFloat green = (rawData[byteIndex + 1] * 1.f) / 255.f;
    CGFloat blue = (rawData[byteIndex + 2] * 1.f) / 255.f;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.f;
    
    //Free our rawData
    free(rawData);
    
    //Return color
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/* 修正颜色 用最低饱和度 */
- (UIColor *)kkColorWithMinSaturation:(CGFloat)saturation {
    if (self) return nil;
    CGFloat h, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    if (s < saturation) {
        return [UIColor colorWithHue:h saturation:saturation brightness:b alpha:a];
    }
    return self;
}

#pragma mark - Get color's description
///=============================================================================
/// @name Get color's description
///=============================================================================

- (uint32_t)kkRgbValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)kkRgbaValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}

- (NSString *)kkHexString {
    return [self kkHexStringWithAlpha:NO];
}

- (NSString *)kkHexStringWithAlpha {
    return [self kkHexStringWithAlpha:YES];
}

- (NSString *)kkHexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02lx",
               (unsigned long)(self.kkAlpha * 255.0 + 0.5)];
    }
    return hex;
}

#pragma mark - Retrieving Color Information
///=============================================================================
/// @name Retrieving Color Information
///=============================================================================

- (CGFloat)kkRed {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)kkGreen {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)kkBlue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)kkAlpha {
    return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)kkHue {
    CGFloat h = 0, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return h;
}

- (CGFloat)kkSaturation {
    CGFloat h, s = 0, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return s;
}

- (CGFloat)kkBrightness {
    CGFloat h, s, b = 0, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return b;
}

- (CGColorSpaceModel)kkColorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)kkColorSpaceString {
    CGColorSpaceModel model =  CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    switch (model) {
        case kCGColorSpaceModelUnknown:    return @"kCGColorSpaceModelUnknown";
        case kCGColorSpaceModelMonochrome: return @"kCGColorSpaceModelMonochrome";
        case kCGColorSpaceModelRGB:        return @"kCGColorSpaceModelRGB";
        case kCGColorSpaceModelCMYK:       return @"kCGColorSpaceModelCMYK";
        case kCGColorSpaceModelLab:        return @"kCGColorSpaceModelLab";
        case kCGColorSpaceModelDeviceN:    return @"kCGColorSpaceModelDeviceN";
        case kCGColorSpaceModelIndexed:    return @"kCGColorSpaceModelIndexed";
        case kCGColorSpaceModelPattern:    return @"kCGColorSpaceModelPattern";
        default:                           return @"ColorSpaceInvalid";
    }
}

#pragma mark - Color Evalutation
///=============================================================================
/// @name Color Evalutation
///=============================================================================

- (BOOL)kkIsDark {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    // 0.2126  0.7152  0.0722
    return (.299*r + .587*g + .114*b) < .5;
}

- (BOOL)kkIsGray {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    CGFloat u = -.147*r - 0.289*g + 0.436*b;
    CGFloat v = 0.615*r - 0.515*g - 0.100*b;
    return (fabs(u) <= 0.002 && fabs(v) <= 0.002);
}

- (BOOL)kkIsBackOrWhite {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return (r>.91 && g>.91 && b>.91) || (r<.09 && r<.09 && r<.09);
}

- (UIColor *)kkInverseColor {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1-r green:1-g blue:1-b alpha:a];
}

#pragma mark - Gradient Methods

///=============================================================================
/// @name Gradient Methods
///=============================================================================

+ (UIColor *)kkGradientColorStartPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint
                                 frame:(CGRect)frame
                                colors:(NSArray<UIColor *> *)colors {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    
    NSMutableArray *cgColor = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [cgColor addObject:(__bridge id)color.CGColor];
    }
    
    layer.colors = cgColor;
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, [UIScreen mainScreen].scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:gradientImage];
}

+ (UIColor *)kkRadialGradientColorFrame:(CGRect)frame colors:(NSArray<UIColor *> *)colors {
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    
    id arrColors[colors.count];
    for (UIColor *color in colors) {
        NSInteger index = [colors indexOfObject:color];
        arrColors[index] = (__bridge id)color.CGColor;
    }
    CFArrayRef arrRef = CFArrayCreate(kCFAllocatorDefault, (void *)arrColors, (CFIndex)colors.count, NULL);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, arrRef, nil);
    CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
    CGFloat radius = MAX(frame.size.width, frame.size.height)/2;
    
    CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    return [UIColor colorWithPatternImage:gradientImage];
}

@end
