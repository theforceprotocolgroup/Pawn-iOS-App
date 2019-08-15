//
//  RechargePopView.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/13.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RechargePopView : UIView <KKViewDelegate>
//
@property (nonatomic, strong) NSString * title;
//
@property (nonatomic, strong) NSString * qdCode;
//第一个是tokentype 第二个是address
+ (instancetype)showWithSurperView:(UIView *)view withModel:(RACTuple *)model withAction:(KKActionHandle)handle;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
