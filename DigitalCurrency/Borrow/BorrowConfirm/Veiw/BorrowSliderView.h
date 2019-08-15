//
//  BorrowSliderView.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/22.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BorrowSliderView : UIView <KKViewDelegate>
-(void)valueChanged:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
