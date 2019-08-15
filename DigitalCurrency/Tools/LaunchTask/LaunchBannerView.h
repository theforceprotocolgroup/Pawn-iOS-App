//
//  LaunchBannerView.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LaunchBannerView : UIView <KKViewDelegate>

/*! 任务管理器 */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;

/*! 添加开屏图(图为启动图) */
+ (instancetype)show;

/*! 消失(图为启动图) */
- (void)dismiss;

- (void)showOpenScreen:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
