//
//  RegistViewController.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/15.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//注册或重置验证码-验证账号
@interface RegistViewController : UIViewController <KKRouterDataDelegate>
//
@property (nonatomic, assign) BOOL isReset;
@end

NS_ASSUME_NONNULL_END
