//
//  PopListView.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/20.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PopListViewModel;

@interface PopListView : UIView <KKViewDelegate>

+ (instancetype)showWithTitle:(NSString *)title content:(NSArray <PopListViewModel *>*)dataArr superView:(UIView * _Nullable )superView action:(KKActionHandle)handle;
- (void)selectedIndex:(NSInteger)index;
- (void)show;
- (void)dismiss;

@end


@interface PopListViewModel : NSObject

//
@property (nonatomic, strong) NSString * title;
//
@property (nonatomic, strong) NSString * content;

@end
NS_ASSUME_NONNULL_END
