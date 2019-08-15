//
//  KKFileManager.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/11/18.
//  Copyright © 2018 keke. All rights reserved.
//

#import "KKFileManager.h"
#import "YYKit.h"
@implementation KKFileManager
+ (NSString *)homePath{
    return NSHomeDirectory();
}

+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

+ (BOOL)hasLive:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+(BOOL)hasLivePathWithRooter:(KKFilePathRooter)rooter withName:(NSString*)name;
{
    return [self hasLive:[self makePathWithRooter:rooter withName:name]];
}
+(NSString*)makePathWithRooter:(KKFilePathRooter)rooter withName:(NSString*)name;
{
    NSString * string ;
    switch (rooter) {
        case KKFilePathRooterDoc:
        {
            string = [self docPath];
        }   break;
        case KKFilePathRooterLibCaches:
        {
            string = [self libCachePath];
        }   break;
        case KKFilePathRooterTmp:
        {
            string =[self tmpPath];
        }   break;
        default:
            break;
    }
    string = [string stringByAppendingPathComponent:[self makePath:name]];
    return string;
}
+(NSString*)createPathWithRooter:(KKFilePathRooter)rooter withName:(NSString*)name;
{
    NSString *string = [self makePathWithRooter:rooter withName:name];
    
    if (![self hasLive:string]) {
        //        NSError *error = nil;
        //        BOOL result = [[NSFileManager defaultManager]createDirectoryAtPath:[string stringByDeletingLastPatKKomponent]withIntermediateDirectories:YES attributes:nil error:&error];
        BOOL result = [[NSFileManager defaultManager]createFileAtPath:string contents:nil attributes:nil];
        if (!result) {
            return nil;
        }
        
    }
    return string.length ? string : nil;
}
+(NSString*)makePath:(NSString*)name
{
    if (!name) {
        return nil;
    }
    if ([self hasLive:name]) {
        return name;
    }
    
    NSArray * arr = [name componentsSeparatedByString:@"/"];
    if (arr && arr.count>1) {
        __block NSString * tempStr = name;
        [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:@"Preference"] && ![obj isEqualToString:@"Caches"] && ![obj isEqualToString:@"tmp"] && idx == 0) {
                tempStr = [tempStr stringByAppendingPathComponent:obj];
            }
        }];
        return tempStr;
    }else
    {
        return name;
    }
}
+(void)writeDataWithPath:(NSString *)path wihtRooter:(KKFilePathRooter)rooter withData:(id)data needRecover:(BOOL)isrecover withFinishHandle:(KKFileWriteHandle)handle;
{
    NSString * tempPath = [self createPathWithRooter:rooter withName:path];
    if (tempPath) {
        if ([data isKindOfClass:[NSString class]]) {
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSError * error = nil;
                BOOL result;
                if (isrecover) {
                    result = [(NSString*)data writeToFile:tempPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                }else
                {
                    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:tempPath];
                    [fileHandle seekToEndOfFile];
                    [fileHandle writeData:[(NSString*)data dataUsingEncoding:NSUTF8StringEncoding]];
                    result = YES;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handle) {
                        handle(tempPath,error,result);
                    }
                });
            });
            
        }else if ([data isKindOfClass:[NSData class]]){
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSError * error = nil;
                BOOL result;
                if (isrecover) {
                    result = [(NSData*)data writeToFile:tempPath options:NSDataWritingAtomic error:&error];
                }else
                {
                    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:tempPath];
                    [fileHandle seekToEndOfFile];
                    [fileHandle writeData:data];
                    result = YES;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handle) {
                        handle(tempPath,error,result);
                    }
                });
                
            });
        }else if ([data isKindOfClass:[NSArray class]])
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                BOOL result;
                if (isrecover) {
                    result = [(NSArray*)data writeToFile:tempPath atomically:YES];
                }else
                {
                    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:tempPath];
                    [fileHandle seekToEndOfFile];
                    //序列化存入
                    [fileHandle writeData:[NSKeyedArchiver archivedDataWithRootObject:(NSArray*)data]];
                    result = YES;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handle) {
                        handle(tempPath,nil,result);
                    }
                });
            });
            
        }else if ([data isKindOfClass:[NSDictionary class]]){
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                BOOL result;
                if (isrecover) {
                    result = [(NSDictionary*)data writeToFile:tempPath atomically:YES];
                }else
                {
                    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:tempPath];
                    [fileHandle seekToEndOfFile];
                    //序列化存入
                    [fileHandle writeData:[NSKeyedArchiver archivedDataWithRootObject:(NSDictionary*)data]];
                    result = YES;
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handle) {
                        handle(tempPath,nil,result);
                    }
                });
            });
        }else
        {
            NSError * error = [NSError errorWithDomain:@"数据类型错误" code:0 userInfo:nil];
            if (handle) {
                handle(tempPath,error,NO);
            }
        }
    }else
    {
        NSError * error = [NSError errorWithDomain:@"路径添加错误" code:0 userInfo:nil];
        if (handle) {
            handle(tempPath,error,NO);
        }
    }
}

+(void)readStringWithPath:(NSString *)path withRooter:(KKFilePathRooter)rooter withFinishHandle:(KKFileReadHandle)handle;
{
    NSString * temppath = [self makePathWithRooter:rooter withName:path];
    if ([self hasLive:temppath]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSError * error = nil;
            NSString * string = [NSString stringWithContentsOfFile:temppath encoding:NSUTF8StringEncoding error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handle) {
                    handle(temppath,string,error,error?YES:NO);
                }
            });
        });
        
    }else
    {
        if (handle) {
            handle(temppath,nil,[NSError errorWithDomain:@"路径错误" code:0 userInfo:nil],NO);
        }
    }
}
+(void)readDicWithPath:(NSString *)path withRooter:(KKFilePathRooter)rooter withFinishHandle:(KKFileReadHandle)handle;
{
    NSString * temppath = [self makePathWithRooter:rooter withName:path];
    if ([self hasLive:temppath]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:temppath];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handle) {
                    handle(temppath,dic,nil,dic?YES:NO);
                }
            });
        });
        
    }else
    {
        if (handle) {
            handle(temppath,nil,[NSError errorWithDomain:@"路径错误" code:0 userInfo:nil],NO);
        }
    }
}
+(void)readArrayWithPath:(NSString *)path withRooter:(KKFilePathRooter)rooter withFinishHandle:(KKFileReadHandle)handle;
{
    NSString * temppath = [self makePathWithRooter:rooter withName:path];
    if ([self hasLive:temppath]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSArray * arr = [NSArray arrayWithContentsOfFile:temppath];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handle) {
                    handle(temppath,arr,nil,arr?YES:NO);
                }
            });
        });
        
    }else
    {
        if (handle) {
            handle(temppath,nil,[NSError errorWithDomain:@"路径错误" code:0 userInfo:nil],NO);
        }
    }
}
+(void)readDataWithPath:(NSString *)path withRooter:(KKFilePathRooter)rooter withFinishHandle:(KKFileReadHandle)handle;
{
    NSString * temppath = [self makePathWithRooter:rooter withName:path];
    if ([self hasLive:temppath]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSData * data = [NSData dataWithContentsOfFile:temppath];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handle) {
                    handle(temppath,data,nil,data?YES:NO);
                }
            });
        });
        
    }else
    {
        if (handle) {
            handle(temppath,nil,[NSError errorWithDomain:@"路径错误" code:0 userInfo:nil],NO);
        }
    }
}
+(BOOL)removeDataWithPath:(NSString *)path wihtRooter:(KKFilePathRooter)rooter;
{
    NSString * temppath = [self makePathWithRooter:rooter withName:path];
    if ([self hasLive:temppath]) {
        return [[NSFileManager defaultManager]removeItemAtPath:temppath error:nil];
    }
    return YES;
}
+(long long) fileSizeAtPath:(NSString *)path withRooter:(KKFilePathRooter)rooter;
{
    NSString * temppath = [self makePathWithRooter:rooter withName:path];
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:temppath]){
        
        return [[manager attributesOfItemAtPath:temppath error:nil] fileSize];
    }
    return 0;
}
@end
