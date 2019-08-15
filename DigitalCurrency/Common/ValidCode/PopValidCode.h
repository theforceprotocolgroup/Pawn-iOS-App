//
//  PopValidCode.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopValidCode : UIView <KKViewDelegate>
+ (instancetype)showWithTitle:(NSString *)title superView:(UIView * _Nullable )superView action:(KKActionHandle)handle;
- (void)show;
- (void)dismiss;
- (void)startTimer;
- (void)showErrorMessage:(NSString*)message;
@end

NS_ASSUME_NONNULL_END
