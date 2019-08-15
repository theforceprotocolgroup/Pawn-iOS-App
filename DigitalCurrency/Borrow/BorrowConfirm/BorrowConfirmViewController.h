//
//  BorrowConfirmViewController.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/21.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorrowHomeViewModel.h"
#import "BorrowInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BorrowConfirmViewController : UIViewController <KKRouterDataDelegate>
//
@property (nonatomic, strong) BorrowHomeViewModel * homeModel;
//
@property (nonatomic, strong) BorrowInfoModel * infoModel;
@end

NS_ASSUME_NONNULL_END
