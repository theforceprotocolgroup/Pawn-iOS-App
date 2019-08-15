//
//  SetPasswordViewController.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/15.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//设置密码或重置密码-设置密码
@interface SetPasswordViewController : UIViewController <KKRouterDataDelegate>
//
@property (nonatomic, assign) BOOL isReset;
//
@property (nonatomic, strong) NSString * phone;
@end

NS_ASSUME_NONNULL_END
