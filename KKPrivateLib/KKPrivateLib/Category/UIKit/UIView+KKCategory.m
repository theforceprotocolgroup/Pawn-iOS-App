//
//  UIView+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/12.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UIView+KKCategory.h"
#import <objc/runtime.h>
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIView (KKCategory)

#pragma mark - Snapshot
///=============================================================================
/// @name Snapshot
///=============================================================================

- (UIImage *)kkSnapshotImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Tap Size
///=============================================================================
/// @name Tap Size
///=============================================================================

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";
static BOOL ARHasSwizzledSetFrame;

- (void)kkExtendHitTestSizeByWidth:(CGFloat)width
                            height:(CGFloat)height {
    // As they are stored as a UIEdgeInset and we're dealing with extending
    // we invert the height & width to make the API make sense
    
    UIEdgeInsets insets = UIEdgeInsetsMake(-height, -width, -height, -width);
    NSValue *value = [NSValue value:&insets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}


// Support showing what it would look like at runtime
// We need to ensure that setting the frame resizes correctly
// Thus swizzling only when at least one view uses the visually method
- (void)kkVisuallyExtendHitTestSizeByWidth:(CGFloat)width
                                    height:(CGFloat)height {
    UIEdgeInsets highlightInsets = UIEdgeInsetsMake(-height, -width, -height, -width);
    NSInteger highlightViewTag = 232323;
    
    UIView *highlightView = [self viewWithTag:highlightViewTag];
    if (!highlightView) {
        highlightView = [[UIView alloc] init];
        highlightView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        highlightView.tag = 232323;
        highlightView.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        [self addSubview:highlightView];
    }
    
    highlightView.frame = UIEdgeInsetsInsetRect(self.bounds, highlightInsets);
    
    [self kkExtendHitTestSizeByWidth:width height:height];
    
    if (!ARHasSwizzledSetFrame){
        ARHasSwizzledSetFrame = YES;
        
        SEL setFrame = @selector(layoutSubviews);
        SEL newSetFrame = @selector(kkwizzledLayoutSubviews);
        
        Method originalMethod = class_getInstanceMethod(self.class, setFrame);
        Method overrideMethod = class_getInstanceMethod(self.class, newSetFrame);
        if (class_addMethod(self.class, setFrame, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
            class_replaceMethod(self.class, newSetFrame, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, overrideMethod);
        }
    }
}

- (void)kkwizzledLayoutSubviews  {
    [self kkwizzledLayoutSubviews];
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if (value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets];
        [self kkVisuallyExtendHitTestSizeByWidth:-edgeInsets.left height:-edgeInsets.top];
    }
}

#pragma mark - Gesture
///=============================================================================
/// @name Gesture
///=============================================================================

/*! 添加Tap手势 */
- (void)kkAddTapAction:(KKActionHandle)block {
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if (block) block(RACTuplePack(self, x));
    }];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

/*! 添加Pan手势 */
- (void)kkAddPanAction:(KKActionHandle)block {
    UIPanGestureRecognizer *pan = [UIPanGestureRecognizer new];
    [pan.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if (block) block(RACTuplePack(self, x));
    }];
    [self addGestureRecognizer:pan];
    self.userInteractionEnabled = YES;
}

/*! 添加LongPress手势 */
- (void)kkAddLongPressAction:(KKActionHandle)block {
    UILongPressGestureRecognizer *press = [UILongPressGestureRecognizer new];
    [press.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if (block) block(RACTuplePack(self, x));
    }];
    [self addGestureRecognizer:press];
    self.userInteractionEnabled = YES;
}

#pragma mark - 实现直接获取控件frame的属性
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}


+ (float)getHeight:(float)defaultW defaultH:(float)defaultH
{
    float screenW = [[UIScreen mainScreen] bounds].size.width;
    
    float scale = screenW/defaultW;
    
    return defaultH*scale;
    
}


@end
