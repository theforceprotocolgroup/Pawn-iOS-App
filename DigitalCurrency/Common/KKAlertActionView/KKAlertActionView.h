//
//  KKAlertActionView.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/17.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class KKAlertAction;

@interface KKAlertActionView : NSObject
/*! UIAlertController */
- (KKAlertActionView *(^)(id title))title;
- (KKAlertActionView *(^)(id message))message;
- (KKAlertActionView *(^)(UIAlertControllerStyle style))style;
- (KKAlertActionView *(^)(KKAlertAction *action))addAction;
/*! 参数可以是数组, 可以是单个action */
- (KKAlertActionView *(^)(id action))addActions;

- (void(^)(UIViewController *vc))show;

+ (instancetype)alert;

/*! 支持 NSString or NSAttributeString */
@property (nonatomic, strong) id kkTitle;
/*! 支持 NSString or NSAttributeString */
@property (nonatomic, strong) id kkMessage;
/*! */
@property (nonatomic, assign) UIAlertControllerStyle kkStyle;
/*! 添加手势 */
- (void)kkAddAction:(KKAlertAction *)action;
- (void)kkAddActions:(NSArray<KKAlertAction *> *)actions;

@end

@interface KKAlertAction : NSObject

+ (instancetype)action;

/*! UIAlertAction */
- (KKAlertAction *(^)(id title))title;
- (KKAlertAction *(^)(UIAlertActionStyle style))style;
- (KKAlertAction *(^)(UIColor *textColor))textColor;
- (KKAlertAction *(^)(BOOL noAlert))noAlert;

/*! 返回一个 UIAlertAction
 */
- (KKAlertAction *(^)(void (^)(UIAlertAction *action)))handler;
/*! 返回一个跳转uriAlertAction
 */
- (KKAlertAction *(^)(NSString *uri))pushHandler;
/*! 返回不跳转 */
- (KKAlertAction *(^)(NSString *uri))pushNoAlertHandler;


/*! 支持 NSString or NSAttributeString */
@property (nonatomic, strong) id kkTitle;
/*! */
@property (nonatomic, assign) UIAlertActionStyle kkStyle;
/*! 只有在 title 为 NSString 类型时才生效 */
@property (nonatomic, strong) UIColor * kkTextColor;
/*! */
@property (nonatomic, copy) void (^block)(UIAlertAction *action);
/*! 是否不弹框直接处理 block */
@property (nonatomic, assign) BOOL kkNoAlert;

#pragma mark - 常用 Action
///=============================================================================
/// @name 常用 Action
///=============================================================================
/*! 标题 */
+ (KKAlertAction *(^)(NSString *title))titleAction;
/*! 取消 */
+ (KKAlertAction *)cancelAction;
/*! 联系客服 */
+ (KKAlertAction *)contactAction;

@end
NS_ASSUME_NONNULL_END
