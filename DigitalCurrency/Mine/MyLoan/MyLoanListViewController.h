//
//  MyLoanListViewController.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LoanType) {
    LoanTypeHoldIng = 1,     // 持有中
    LoanTypeFinished = 2,     // 已回款
    LoanTypeAll = 3// 所有
};

NS_ASSUME_NONNULL_BEGIN

@interface MyLoanListViewController : UIViewController <KKRouterDataDelegate>
@property (nonatomic, assign) LoanType type;
@end

NS_ASSUME_NONNULL_END
