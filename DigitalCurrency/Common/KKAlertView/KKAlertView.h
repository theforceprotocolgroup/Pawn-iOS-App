//
//  KKAlertView.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KKAlertBlock)(UIAlertView *alertView, NSInteger buttonIndex) ;

@interface KKAlertView : UIAlertView

@property (nonatomic, copy)KKAlertBlock alertBlock;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel sureButton:(NSString *)sure;

- (void)backToKKBlock:(KKAlertBlock)alertBlock;

@end

NS_ASSUME_NONNULL_END
