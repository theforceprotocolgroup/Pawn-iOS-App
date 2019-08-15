//
//  PopTokenListView.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetHomeTokenModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PopTokenListView : UIView <KKViewDelegate>
+ (instancetype)showWithDefaultIndex:(NSInteger)index Content:(NSArray <AssetHomeTokenModel *>*)dataArr superView:(UIView * _Nullable )superView action:(KKActionHandle)handle;
- (void)selectedIndex:(NSInteger)index;
- (void)show;
- (void)dismiss;

@end
NS_ASSUME_NONNULL_END
