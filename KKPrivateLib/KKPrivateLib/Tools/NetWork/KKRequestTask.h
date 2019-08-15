//
//  KKRequestTask.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/11/17.
//  Copyright © 2018 keke. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "Bolts.h"
#import "KKMacro.h"

NS_ASSUME_NONNULL_BEGIN

#define KKhost @"http://ios.bibidai.com/"    //@"http://jedai.io/"//@"http://52.195.4.110:9411/"
// 宏学@"http://192.168.127.92:8080/" //@"http://114.116.54.133:8080/" //明亮@"http://172.16.4.180:8080/" //@"http://39.104.28.244:8080/  //     "http:jedai.io // 52.195.4.110:9411

#define AFTask BFTask

/** 请求函数类型 */
typedef NS_ENUM(NSInteger, AFRequestMethod) {
    AFRequestMethodPost = 0,
    AFRequestMethodGet,
    AFRequestMethodHead,
    AFRequestMethodPut,
    AFRequestMethodDelete,
    AFRequestMethodPatch
};

/** 网络请求任务 */
@interface KKRequestTask : AFHTTPSessionManager


- (KKRequestTask *(^)(AFRequestMethod type))methodType;
- (KKRequestTask *(^)(NSString *urlString))urlString;
- (KKRequestTask *(^)(id __nullable paramaters))paramaters;
- (KKRequestTask *(^)(void (^nullable)(id<AFMultipartFormData> formData)))formData;
- (KKRequestTask *(^)(void (^nullable)(NSProgress *)))downloadProgress;
- (KKRequestTask *(^)(void (^nullable)(NSProgress *)))uploadProgress;
- (KKRequestTask *(^)(UIView *view))view;
- (KKRequestTask *(^)(NSArray<NSNumber *> *ignoreCodes))ignoreCodes;
- (KKRequestTask *(^)(BOOL needCustomFormat))needCustomFormat;

#pragma mark - 属性
/*! */
@property (nonatomic, assign) AFRequestMethod kk_MethodType;
/*! */
@property (nonatomic, strong) NSString * kk_UrlString;
/*! */
@property (nonatomic, weak) UIView * kk_View;
/*! */
@property (nonatomic, strong) id kk_Parameters;
/*! */
@property (nonatomic, copy) void (^kk_FormData)(id<AFMultipartFormData> formData);
/*! */
@property (nonatomic, copy) void (^kk_Upload)(NSProgress *progress);
/*! */
@property (nonatomic, copy) void (^kk_Download)(NSProgress *progress);
/*! */
@property (nonatomic, strong) NSArray<NSNumber *> *kk_IgnoreCodes;
/*! */
@property (nonatomic, assign) BOOL kk_Continue;
/*! */
@property (nonatomic, assign) BOOL kk_needCustomFormat;
#pragma mark - fanction

- (AFTask *)kkTask;

- (AFTask *)kkDownloadTask;

@end

//=============================================***   JSON   ***======================================/

@interface JSONModel : NSObject
/*! */
@property (nonatomic, assign) NSInteger code;
/*! */
@property (nonatomic, strong) NSString *message;
/*! */
@property (nonatomic, strong) id data;
/*! */
@property (nonatomic, assign) BOOL isSuccess;
//如果数据是数组，直接解析成数组
-(NSArray *)arrWithClass:(NSString *)className;
@end

//=============================================***   BFTask   ***======================================/

typedef __nullable id(^KKBFContinuationBlock)(AFTask *t, JSONModel *result);

@interface BFTask (KKTask)

- (BFTask *)kkContinueBlock:(KKBFContinuationBlock)block;

@end
NS_ASSUME_NONNULL_END
