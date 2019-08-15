//
//  UINavigationBar+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/12.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (KKCategory)

/*! Bar background color */
@property (nonatomic, strong) UIColor *kkBarColor;
/*! Bar content alpha */
@property (nonatomic, assign) CGFloat kkAlpha;
/*! Bar translationY */
@property (nonatomic, assign) CGFloat kkTranslationY;
/*! Bar hairline */
@property (nonatomic, assign) BOOL kkHairlineHidden;
/*! Bar reset */
- (void)kkResetBar;

- (void)setOverlayerHidden:(BOOL)hidden;
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
