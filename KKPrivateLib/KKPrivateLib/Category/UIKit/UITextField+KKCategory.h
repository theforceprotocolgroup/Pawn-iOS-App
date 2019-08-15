//
//  UITextField+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (KKCategory)
/*! */
@property (nonatomic, strong) UIFont *kkHolderFont;
/*! */
@property (nonatomic, strong) UIColor *kkHolderTextColor;

/*! */
@property (nonatomic, strong) NSString *kkRegex;
/*! */
@property (nonatomic, assign) NSInteger kkLength;

@end

NS_ASSUME_NONNULL_END
