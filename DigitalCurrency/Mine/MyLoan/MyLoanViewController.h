//
//  MyLoanViewController.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLoanListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLoanViewController : UIViewController <KKRouterDataDelegate>

@property (nonatomic, assign) LoanType currenttype;

@end

NS_ASSUME_NONNULL_END
