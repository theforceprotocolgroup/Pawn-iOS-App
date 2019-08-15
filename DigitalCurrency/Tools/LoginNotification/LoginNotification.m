//
//  LoginNotification.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/17.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoginNotification.h"

@implementation LoginNotification
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
    LoginNotification * manager = [LoginNotification shareManager];
}


+ (instancetype)shareManager {
    
    static LoginNotification *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _isShowLoginVc = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginVcShow:) name:@"Login" object:nil];
    }
    return self;
}

-(void)handleLoginVcShow:(NSNotification *)non
{
    NSNumber * code = [non object];
    if (self.isShowLoginVc) {
        return;
    }else
    {
        self.isShowLoginVc = YES;
    }
    NSString *title;
    NSString *message;
    switch (code.integerValue) {
        //无登录（不弹窗）
        case 2101: {
            title = @"温馨提示";
            message = @"请您登录";
        }break;
        //未登录
        case 2100: {
            title = @"安全提示";
            message = @"系统异常\n请您重新登录";//@"您的账号长时间未操作\n请重新登录";
        }break;
        case 2102: {
            title = @"温馨提示";
            message = @"您的账号已在其他地方登录\n请注意账号安全";
        }
            break;
        default:
            break;
    }
    id action = [KKAlertAction action].title(@"我知道了")
    .handler(^(id x){
        [UserManager clearLoginInfo];
        @weakify(self);
        [[KKRouter pushUri:LoginVCString] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
            @strongify(self);
            [KKRouter pushUri:BorrowVCString];
            self.isShowLoginVc = NO;
            return nil;
        }];
    });
    [KKAlertActionView alert].title(title).message(message)
    .addActions(action).show([UIApplication sharedApplication].keyWindow.rootViewController);
}
@end
