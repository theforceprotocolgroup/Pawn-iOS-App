//
//  KKRequestTask.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/11/17.
//  Copyright © 2018 keke. All rights reserved.
//

#import "KKRequestTask.h"
#import "YYKit.h"
#import "ReactiveObjC.h"
#import "MBProgressHUD.h"
#import "NSString+KKURLString.h"
#import "UserManager.h"
//=============================================***   JSON   ***======================================/
@interface JSONModel()
@end
@implementation JSONModel
-(NSArray *)arrWithClass:(NSString *)className;
{
    if ([self.data isKindOfClass:[NSArray class]]) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id tmp = [NSClassFromString(className) modelWithJSON:obj];
            if (tmp) {
                [tmpArr addObject:tmp];
            }
        }];
        return tmpArr;
    }
    return nil;
}
@end

//=============================================***   KKRequestTask   ***======================================/
@implementation KKRequestTask

#pragma mark - get

- (KKRequestTask *(^)(AFRequestMethod type))methodType {
    return ^id(AFRequestMethod type) {
        self.kk_MethodType = type;
        return self;
    };
}
- (KKRequestTask *(^)(NSString *urlString))urlString {
    return ^id(NSString *urlString) {
        self.kk_UrlString = urlString;
        return self;
    };
}
- (KKRequestTask *(^)(id paramaters))paramaters {
    return ^id(id paramaters) {
        if (!paramaters) {
            paramaters = @{};
        }
        self.kk_Parameters = paramaters;
        return self;
    };
}
- (KKRequestTask *(^)(NSArray<NSNumber *> *ignoreCodes))ignoreCodes {
    return ^id(NSArray<NSNumber *> *ignoreCodes) {
        self.kk_IgnoreCodes = ignoreCodes;
        return self;
    };
}
- (KKRequestTask *(^)(UIView *view))view {
    return ^id(UIView *view) {
        self.kk_View = view;
        return self;
    };
}
- (KKRequestTask *(^)(void (^nullable)(id<AFMultipartFormData> formData)))formData {
    return ^id(void (^block)(id<AFMultipartFormData> formData)) {
        self.kk_FormData = block;
        return self;
    };
}
- (KKRequestTask *(^)(void (^nullable)(NSProgress *)))downloadProgress {
    return ^id(void (^block)(NSProgress *)) {
        self.kk_Download = block;
        return self;
    };
}
- (KKRequestTask *(^)(void (^nullable)(NSProgress *)))uploadProgress {
    return ^id(void (^block)(NSProgress *)) {
        self.kk_Upload = block;
        return self;
    };
}
- (KKRequestTask *(^)(BOOL needCustomFormat))needCustomFormat;
{
    return ^id(BOOL needCustomFormat) {
        self.kk_needCustomFormat = needCustomFormat;
        return self;
    };
}
#pragma mark - task

-(AFTask *)kkTask
{
    if (!(self.kk_UrlString && self.kk_UrlString.length)) return [AFTask new];
    if (self.kk_needCustomFormat) {
//        self.kk_UrlString = [NSString stringWithFormat:@"%@",[self.kk_UrlString kkFormaterCustomURLString]];
    }
    if ([self.kk_UrlString rangeOfString:@"http"].location == NSNotFound) {
        self.kk_UrlString = [NSString stringWithFormat:@"%@%@", KKhost, self.kk_UrlString];
    };
    BFTaskCompletionSource *tcs = [BFTaskCompletionSource taskCompletionSource];
    if (self.kk_View) [MBProgressHUD showHUDAddedTo:self.kk_View animated:YES];
    
    @weakify(self);
    [self taskWithSuccess:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        @strongify(self);
        NSError *error;
        id data;
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        } else {
            data = responseObject;
        }
        NSLog(@"url:%@ \n================================\n param:%@ \n================================\n result:%@",self.kk_UrlString , self.kk_Parameters , data);
        if (self.kk_View) [MBProgressHUD hideHUDForView:self.kk_View animated:NO];
        if (error) {
            [tcs setError:error];
        } else {
            JSONModel *model = [JSONModel modelWithJSON:data];
            if (model.code == 1000) {
                [tcs setResult:RACTuplePack(task, data)];
            }else if(model.code == 2100||model.code == 2101||model.code == 2102)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:@(model.code)];
            }
            else {
                [tcs setError:[NSError errorWithDomain:self.kk_UrlString code:model.code userInfo:data]];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError * _Nonnull error) {
        @strongify(self);
        NSLog(@"url:%@ \n================================\n param:%@ \n================================\n result:%@",self.kk_UrlString , self.kk_Parameters , error);
        if (self.kk_View) [MBProgressHUD hideHUDForView:self.kk_View animated:YES];
        NSString *message = [[YYReachability reachability] isReachable] ?
        @"服务器开小差啦，请重试~":@"网络已断开，请检查手机网络连接";
        [tcs setError:[NSError errorWithDomain:self.kk_UrlString code:error.code userInfo:@{@"code":@(error.code), @"message":message}]];
    }];
    return tcs.task;
}

-(AFTask *)kkDownloadTask
{
    if (!(self.kk_UrlString && self.kk_UrlString.length)) return [AFTask new];
    if ([self.kk_UrlString rangeOfString:@"http"].location == NSNotFound) {
        self.kk_UrlString = [NSString stringWithFormat:@"%@%@", KKhost, self.kk_UrlString];
    };
    BFTaskCompletionSource *tcs = [BFTaskCompletionSource taskCompletionSource];
    
    @weakify(self);
    [self taskWithSuccess:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        NSLog(@"result=%@",responseObject);
        [tcs setResult:RACTuplePack(task, responseObject)];
        
    } failure:^(NSURLSessionDataTask *task, NSError * _Nonnull error) {
        @strongify(self);
        if (self.kk_View) [MBProgressHUD hideHUDForView:self.kk_View animated:YES];
        NSString *message = [[YYReachability reachability] isReachable] ?
        @"服务器开小差啦，请重试~":@"网络已断开，请检查手机网络连接";
        [tcs setError:[NSError errorWithDomain:self.kk_UrlString code:error.code userInfo:@{@"code":@(error.code), @"message":message}]];
    }];
    return tcs.task;
}

- (void)taskWithSuccess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    switch (self.kk_MethodType) {
        case AFRequestMethodGet: {
            [self GET:self.kk_UrlString parameters:self.kk_Parameters
             progress:self.kk_Download success:success failure:failure];
        } break;
        case AFRequestMethodPost: {
            if (self.kk_FormData) {
                [self POST:self.kk_UrlString parameters:self.kk_Parameters constructingBodyWithBlock:self.kk_FormData progress:self.kk_Upload success:success failure:failure];
            }else {
                [self POST:self.kk_UrlString parameters:self.kk_Parameters
                  progress:self.kk_Upload success:success failure:failure];
            }
        } break;
        case AFRequestMethodHead: {
            [self HEAD:self.kk_UrlString parameters:self.kk_Parameters
               success:^(NSURLSessionDataTask * task) {
                   success(task, nil);
               } failure:failure];
        } break;
        case AFRequestMethodPut: {
            [self PUT:self.kk_UrlString parameters:self.kk_Parameters
              success:success failure:failure];
        } break;
        case AFRequestMethodDelete: {
            [self DELETE:self.kk_UrlString parameters:self.kk_Parameters
                 success:success failure:failure];
        } break;
        case AFRequestMethodPatch: {
            [self PATCH:self.kk_UrlString parameters:self.kk_Parameters
                success:success failure:failure];
        } break;
        default: {
            [self GET:self.kk_UrlString parameters:self.kk_Parameters
             progress:self.kk_Download success:success failure:failure];
        }
            break;
    }
}
@end
//=============================================***   BFTask   ***======================================/
@implementation BFTask (SZTask)

- (BFTask *)kkContinueBlock:(KKBFContinuationBlock)block {
    return [self continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        if (t.error) {
            JSONModel *model = [JSONModel modelWithJSON:t.error.userInfo];
            block(t, model);
        } else {
            RACTuple *tuple = t.result;
            JSONModel *model = [JSONModel modelWithJSON:tuple.second];
            block(t, model);
        }
        return nil;
    }];
}
@end
