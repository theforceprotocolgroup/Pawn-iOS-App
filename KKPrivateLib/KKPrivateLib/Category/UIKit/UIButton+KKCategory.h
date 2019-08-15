//
//  UIButton+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KKButtonType) {
    KKButtonTypePriHollow,    ///< 主色调 空心
    KKButtonTypePriSolid,     ///< 主色调 实心
    KKButtonTypeCustom
};

@interface UIButton (KKCategory)

@property (nonatomic, assign, readwrite) KKButtonType kkButtonType;

@property (nonatomic, strong) NSString *kkTitle;

- (void)kkConfigHollowUI:(UIColor *)norColor;

@end

NS_ASSUME_NONNULL_END
