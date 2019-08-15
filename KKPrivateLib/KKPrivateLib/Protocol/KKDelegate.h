//
//  KKDelegate.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/12.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKProtocolExtend.h"
#import "Bolts.h"

NS_ASSUME_NONNULL_BEGIN

/*! action */
typedef void(^KKActionHandle)(id _Nullable x);

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

@protocol KKViewDelegate <NSObject>
/*! 主要用于 View */
@optional
+ (nonnull id)viewWithModel:(nullable id)model action:(nullable KKActionHandle)action;
+ (nonnull id)viewWithFrame:(CGRect)frame model:(nullable id)model action:(nullable KKActionHandle)action;
/*! 用于 Cell 传递事件 更新*/
@optional
- (void)viewModel:(nullable id)model action:(nullable KKActionHandle)action;
/*! 用于 View 传递事件 更新*/
@optional
- (nullable KKActionHandle)viewAction;
/*! view 事件传递 */
- (void)viewAction:(id)x;
@end


#pragma mark - RouterDelegate
///=============================================================================
/// @name RouterDelegate
///=============================================================================
@protocol KKRouterDataDelegate <NSObject>
/*! 用于向 ViewController 传递事件 */
@optional
- (void)routerPassParamters:(nullable id)data;
/*!  */
- (nullable BFTask *)delegateTask;
@end

#pragma mark - TableDelegate
///=============================================================================
/// @name TableDelegate
///=============================================================================

@protocol TableDelegate <NSObject>
@optional
/*! table 数据 */
- (NSArray *)kkDataArray;
@end

NS_ASSUME_NONNULL_END
