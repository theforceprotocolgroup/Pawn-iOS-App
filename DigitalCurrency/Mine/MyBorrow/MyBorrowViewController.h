//
//  MyBorrowViewController.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBorrowListViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyBorrowViewController : UIViewController <KKRouterDataDelegate>

@property (nonatomic, assign) BorrowType currenttype;

@end

NS_ASSUME_NONNULL_END
