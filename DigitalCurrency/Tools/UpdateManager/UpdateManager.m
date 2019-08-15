//
//  UpdateManager.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "UpdateManager.h"
#import "ReachableCenter.h"
#import "UpdateModel.h"
@interface UpdateManager ()
@property(nonatomic,assign,readwrite)BOOL checkUpdateSuccess;
@end

@implementation UpdateManager
#pragma mark - logical
///=============================================================================
/// @name logical
///=============================================================================

+ (void)load {
    __block id observer =
    [[NSNotificationCenter defaultCenter]
     addObserverForName: UIApplicationDidFinishLaunchingNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [self setup];
         [[NSNotificationCenter defaultCenter] removeObserver:observer];
     }];
}

+ (void)setup {
    UpdateManager * manager = [UpdateManager shareManager];
    //    [manager checkAppVersion];
    [ReachableCenter addReachableObserver:manager selector:@selector(changeNetWork:)];
}


+ (instancetype)shareManager {
    
    static UpdateManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.checkUpdateSuccess = NO;
    });
    
    return manager;
    
}

-(void)changeNetWork:(NSNotification *)non
{
    NSNumber * num = [non object];
    if (num.integerValue == KKReachabilityStatusConnect) {
        if (!self.checkUpdateSuccess) {
            [self checkAppVersion];
        }
    }
}

-(void)checkAppVersion
{
    if (self.checkUpdateSuccess) {
        return;
    }
//
    NSDictionary * dic = @{
                           @"version" : [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]],
                           };
    @weakify(self);
    [[KKRequest jsonRequest].paramaters() {
        @strongify(self);
        if (t.result) {
            self.checkUpdateSuccess = YES;
            [ReachableCenter removeObserver:self];
            UpdateModel* model = [UpdateModel modelWithJSON:result.data];
            //测试
            switch (model.appUpdateLevel) {
                case 2:
                {
                    KKAlertView *alert = [[KKAlertView alloc] initWithTitle:@"更新提示" message:model.updateContent cancelButton:@"取消" sureButton:@"确定"];
                    [alert backToKKBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 0) {
                        }else {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.appURL]];
                        }
                        exit(0);
                    }];
                    [alert show];
                }   break;
                case 1:
                {
                    KKAlertView *alert = [[KKAlertView alloc] initWithTitle:@"更新提示" message:model.updateContent cancelButton:@"取消" sureButton:@"确定"];
                    [alert backToKKBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 0) {
                        }else {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.appURL]];
                        }
                    }];
                    [alert show];
                }   break;
                default:
                    break;
            }
           
        }else
        {
            self.checkUpdateSuccess = NO;
        }
        return nil;
    }];
}
@end
