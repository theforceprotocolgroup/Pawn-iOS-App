//
//  UserManager.m
//  DigitalCurrency
//
//  Created by 张可 on 2018/12/15.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "UserManager.h"
#import "NSDictionary+KKCategory.h"
#import "NSData+KKCategory.h"
@interface UserManager()
/*! 用户名(手机号) */
@property (nonatomic, strong) NSString *username;
/*! 用户token */
@property (nonatomic, strong) NSString *token;
/*! 用户id */
@property (nonatomic, strong) NSString *userid;
/*! */
@property (nonatomic, strong) RACSignal *loginSig;
/*! */
@property (nonatomic, assign) BOOL isLogin;
@end

@implementation UserManager

#pragma mark - UserInfo
///=============================================================================
/// @name UserInfo
///=============================================================================

+ (instancetype)manager {
    static UserManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [UserManager new];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.username =  [[NSUserDefaults standardUserDefaults] valueForKey:@"user_username"] ?: @"";
        self.userid =  [[NSUserDefaults standardUserDefaults] valueForKey:@"user_userid"]?:@"";
        self.token = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_token"]?:@"";
        self.isLogin = self.token.length;
        self.loginSig = RACObserve(self, isLogin);
    }
    return self;
}

+ (RACSignal *)loginSignal {
    return [UserManager manager].loginSig;
}

#pragma mark - 登录、退出登录数据处理
///=============================================================================
/// @name
///=============================================================================
+ (void)clearLoginInfo {
    UserManager *manager = [UserManager manager];
    manager.userid = nil;
    manager.token = nil;
    manager.username = nil;
    manager.isLogin = NO;
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"user_username"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"user_token"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"user_userid"];
    [UserManager manager].isLogin = NO;
}

+ (void)saveUserInfo:(NSDictionary *)data {
    UserManager *manager = [UserManager manager];
    manager.userid = data.kkString(@"userId");
    manager.token = data[@"md_access_token"];
    manager.username = data[@"mobile"];
    manager.isLogin = YES;
    [self updateLoginInfo:data];
}

+ (void)updateLoginInfo:(id)info {
    [[NSUserDefaults standardUserDefaults] setValue:info[@"mobile"]?:@"" forKey:@"user_username"];
    [[NSUserDefaults standardUserDefaults] setValue:info[@"md_access_token"]?:@"" forKey:@"user_token"];
    [[NSUserDefaults standardUserDefaults] setValue:info[@"userId"]?:@"" forKey:@"user_userid"];
    [UserManager manager].isLogin = YES;
}

#pragma mark - 密码加密
///=============================================================================
/// @name 密码加密
///=============================================================================

/*! 加密密码
 *  加密规则 = RSAALG(phone + '\001' + pw + '\001' + timestamp, RSAKey)
 */
+ (NSString *)encryptPhone:(NSString *)phone password:(NSString *)pw {
    if (!phone || !pw) return nil;
//    NSString *enc = Format(@"%@%@%@%@%@", phone, @"\001", pw, @"\001", [NSString szTimestamp]);
    return @"";
}

+ (NSString *)encryptMd5Phone:(NSString *)phone password:(NSString *)pw {
    if (!phone || !pw) return nil;
    NSString *md5 = [pw dataUsingEncoding:NSUTF8StringEncoding].kkMD5;
    return [self encryptPhone:phone password:md5];
}
#pragma mark - 自定义处理弹登录页逻辑
///=============================================================================
/// @name netcode
///=============================================================================

+ (void)handleCustomLogoutWithCode:(NSInteger)code;{
    NSString *title;
    NSString *message;
    switch (code) {
        case 1001: {
            title = @"温馨提示";
            message = @"系统异常\n请您重新登录";
        }
            break;
        case 1002: {
            title = @"安全提示";
            message = @"您的账号长时间未操作\n请重新登录";
        }
            break;
        case 1030: {
            title = @"异常登录";
            message = @"您的账号已在其他地方登录\n请注意账号安全";
        }
            break;
        default:
            break;
    }
//    id action = [SZAlertAction action].title(@"我知道了")
//    .handler(^(id x){
//        [UFQUserManager clearLoginInfo];
//        [[SZRouter pushUri:UFQLoginVCString] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kEventEmitterToHomeEvent object:nil];
//            [SZRouter pushUri:UFQHomeVCString];
//            return nil;
//        }];
//    });
//    [SZAlertView alert].title(title).message(message)
//    .addActions(action).show([UIApplication sharedApplication].keyWindow.rootViewController);
    
}
@end
