//
//  MyBorrowListViewController.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BorrowType) {
    BorrowTypeRepaying = 2,     // 还款中
    BorrowTypeWaiting = 1,     // 募集中
    BorrowTypeAll = 3// 所有
};
NS_ASSUME_NONNULL_BEGIN

@interface MyBorrowListViewController : UIViewController <KKRouterDataDelegate>
@property (nonatomic, assign) BorrowType type;

@end

NS_ASSUME_NONNULL_END
