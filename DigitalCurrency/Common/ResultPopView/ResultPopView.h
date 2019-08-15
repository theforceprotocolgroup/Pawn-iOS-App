//
//  ResultPopView.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ResultType) {
    ResultTypeNoEnough = 0,     //余额不足
    ResultTypeFailed = 1,     // 失败
    ResultTypeWithDraw = 2// 提现
};

@interface ResultPopView : UIView <KKViewDelegate>
//
@property (nonatomic, assign) ResultType type;
//
@property (nonatomic, strong) NSArray * btnArr;
//
@property (nonatomic, strong) NSString * status;
//
@property (nonatomic, strong) NSString * content;

+ (instancetype)showWithSurperView:(UIView *)view withAction:(KKActionHandle)handle;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
