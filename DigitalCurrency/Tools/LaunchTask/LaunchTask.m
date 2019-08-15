//
//  LaunchTask.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "LaunchTask.h"
#import "LaunchBannerView.h"
#import "GuidePage.h"
////////////////////////////////////////////////////////////////////////////////
#pragma mark - PopBannerModel
////////////////////////////////////////////////////////////////////////////////

@interface PopBannerModel : NSObject
/*! */
@property (nonatomic, strong) NSString *bannerPic;
/*! */
@property (nonatomic, strong) NSString *bannerTitle;
/*! */
@property (nonatomic, strong) NSString *bannerUri;
/*! */
@property (nonatomic, strong) NSString *shareDescribe;
/*! */
@property (nonatomic, strong) NSString *sharePic;
/*! */
@property (nonatomic, strong) NSString *shareTitle;
/*! */
@property (nonatomic, assign) NSInteger shareType;
@end

@implementation PopBannerModel
@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - InitModel
////////////////////////////////////////////////////////////////////////////////

@interface InitModel : NSObject
//
@property (nonatomic, strong) NSString * imageTitle;
//
@property (nonatomic, strong) NSString * imageTips;
//
@property (nonatomic, strong) NSString * imageURI;
//
@property (nonatomic, strong) NSString * imageHref;
//
@property (nonatomic, assign) BOOL isLogin;
@end

@implementation InitModel
@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - OpenScreenTask
////////////////////////////////////////////////////////////////////////////////

@interface OpenScreenTask : NSObject
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;
/*! 有推送消息 */
@property (nonatomic, assign) BOOL hasUserInfo;
/*! */
@property (nonatomic, strong) InitModel *model;
@end

@implementation OpenScreenTask

+ (BFTask *(^)(BOOL hasUserInfo))task {
    return ^id(BOOL hasUserInfo) {
        OpenScreenTask *task = [[OpenScreenTask alloc] initWithHasUser:hasUserInfo];
        return task.tcs.task;
    };
}

- (instancetype)initWithHasUser:(BOOL)hasUser {
    if (self = [super init]) {
        self.hasUserInfo = hasUser;
        self.tcs = [BFTaskCompletionSource taskCompletionSource];
        [self loadImageRequest];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dict = self.model?@{@"model":self.model}:@{};
            [self.tcs trySetError:[NSError errorWithDomain:@"" code:999 userInfo:dict]];
        });
    }
    return self;
}

- (void)loadImageRequest {
    [[KKRequest jsonRequest].paramaters()
     .kkTask kkContinueBlock:^id(BFTask *t, JSONModel *result) {
         if (t.result) {
             self.model = [InitModel modelWithJSON:result.data];
             self.model.isLogin = [result.data[@""];
             if (!self.tcs.task.isCompleted) {
                 if (!self.model.isLogin) {
                     [UserManager clearLoginInfo];
                 }
                 [self loadImage:self.model];
             }
         } else {
             [self.tcs trySetError:[NSError errorWithDomain:@"" code:999 userInfo:@{}]];
         }
         return nil;
     }];
}

/*! 加载图片 */
- (void)loadImage:(InitModel *)model {
    NSDictionary *dict = self.model?@{@"model":self.model}:@{};
    if (!model.imageURI) {
        [self.tcs trySetError:[NSError errorWithDomain:@"" code:999 userInfo:dict]];
        return;
    }
    NSURL *url = [NSURL URLWithString:model.imageURI];

    [[SDWebImageManager sharedManager]diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.imageURI];
            [self.tcs trySetResult:RACTuplePack(model, image)];
        }else
        {
            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (error) {
                    [self.tcs trySetError:[NSError errorWithDomain:@"" code:999 userInfo:dict]];
                } else {
                    [self.tcs trySetResult:RACTuplePack(model, image)];
                }
            }];
        }
    }];
    
}

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - StartTask
////////////////////////////////////////////////////////////////////////////////

@implementation LaunchTask
#pragma mark - logical
///=============================================================================
/// @name logical
///=============================================================================

+ (void)load {
    __block id observer =
    [[NSNotificationCenter defaultCenter]
     addObserverForName: @"Root"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [self setup:note.userInfo];
         [[NSNotificationCenter defaultCenter] removeObserver:observer];
     }];
}

#pragma mark - Logic
///=============================================================================
/// @name Logic
///=============================================================================

/*! 启动开屏逻辑
 * 1.程序启动时，先显示默认启动图，同时后台加载开屏图。如果2s内开屏图加载完成，展示开屏图，展示时间为3s。如果2s内开屏图没加载完成，则直接跳过开屏，进入首页;
 * 2.当App有引导页的时候，开屏不显示;
 * 3.当开屏关联的活动需要登录时候，点击后，如未登录，直接跳转至登录页面;
 * 4.当有开屏的情况下，用户登录时，由于在别的设备上登录过此账号，不需要提示他需要登录的弹窗;
 * 5.当用户点击Push进入App时，不显示开屏。
 */

+ (void)setup:(NSDictionary *)launchOptions {
    
        /*! 是否有引导页 */
        BOOL hasIntro = [GuidePage isFirstLaunch];
        /*! 判断是否有推送 */
        NSDictionary *userInfoDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        BFTask *openTask = [OpenScreenTask task](userInfoDic?YES:NO);
        if (hasIntro) { //有引导页==>有无推送
            [[BFTask taskWithResult:@(YES)]
             continueWithBlock:^id(BFTask *t) {
                 if (userInfoDic) {
                     [self handlerPush:openTask userInfo:userInfoDic];
                 }
                 return nil;
             }];
        } else if (userInfoDic) { //没有引导页==>有推送
            [self handlerPush:openTask userInfo:userInfoDic];
        } else { //开屏==>
            LaunchBannerView *viewTask = [LaunchBannerView show];
            __block InitModel *initModel;
            [[openTask continueWithBlock:^id(BFTask *t) {
                if (t.result) { //规定时间内下载了图片
                    RACTupleUnpack(InitModel *model, UIImage *image) = t.result;
                    [viewTask showOpenScreen:image];
                    initModel = model;
                    return viewTask.tcs.task;
                } else {
                    initModel = t.error.userInfo[@"model"];
                }
                [viewTask dismiss];
                return nil;
            }] continueWithBlock:^id(BFTask *t) {
                // 用户点击了开屏图
                if (t.error && (!initModel.isLogin)) {
                    [self loginAlert];
                } else if (t.result) {
                    [KKRouter pushUri:initModel.imageHref];
                }
                return nil;
            }];
        }
}

+ (void)handlerPush:(BFTask *)task userInfo:(NSDictionary *)dict {
    LaunchBannerView *viewTask = [LaunchBannerView show];
    [task continueWithBlock:^id(BFTask *t) {
        [viewTask dismiss];
        if (t.result) {
            InitModel *model = t.result;
            if (!model.isLogin) {
                [self loginAlert];
            }
        }
        return nil;
    }];
}

+ (void)loginAlert {
//    NSString *title;
//    NSString *message;
//    switch (code) {
//        case 1: {
//            title = @"安全提示";
//            message = @"您的账号长时间未操作\n请重新登录";
//        }
//            break;
//        case 2: {
//            title = @"异常登录";
//            message = @"您的账号已在其他地方登录\n请注意账号安全";
//        }
//            break;
//        default:
//            break;
//    }
//    id action = [SZAlertAction action].title(@"我知道了")
//    .handler(^(id x){
//
//    });
//    [SZAlertView alert].title(title).message(message)
//    .addActions(action).show([UIApplication sharedApplication].keyWindow.rootViewController);
}

#pragma mark - 开屏图
///=============================================================================
/// @name 开屏图
///=============================================================================

@end
