//
//  GuidePage.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol GuidePageViewDelegate <NSObject>
@optional
- (void)closeCoverAndClickProduct:(BOOL)isTure;
@end

@interface GuidePage : UIView <KKViewDelegate>
+ (instancetype)initializeGuidePageView:(dispatch_block_t)handle;
+ (BOOL)isFirstLaunch;
+ (void)setLaunched;
@property (nonatomic, weak) id <GuidePageViewDelegate> delegate;
@property (nonatomic, assign) CGRect rect;
@end

NS_ASSUME_NONNULL_END
