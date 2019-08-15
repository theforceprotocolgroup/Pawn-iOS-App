//
//  KKAlertView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "KKAlertView.h"

@interface KKAlertView ()

@end

@implementation KKAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel sureButton:(NSString *)sure {
    
    if (cancel == nil || cancel.length == 0) {
        
        self = [[KKAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:sure, nil];
        
    }else {
        
        self = [[KKAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:cancel, sure, nil];
        
    }
    self.delegate = self;
    return self;
}


- (void)backToKKBlock:(KKAlertBlock)alertBlock {
    
    self.alertBlock = alertBlock;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.alertBlock) {
        self.alertBlock(alertView, buttonIndex);
    }
    
}

@end
