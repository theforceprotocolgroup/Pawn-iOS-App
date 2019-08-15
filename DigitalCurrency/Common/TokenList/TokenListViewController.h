//
//  TokenListViewController.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/18.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TokenListType){
    TokenListTypeBorrow = 0,
    TokenListTypeLoan,
    TokenListTypeWallet,
} ;

@interface TokenListViewController : UIViewController <KKRouterDataDelegate>
//
@property (nonatomic, assign) TokenListType type;
//
@property (nonatomic, strong) NSString * tokenType;

@end

NS_ASSUME_NONNULL_END
