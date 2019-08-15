//
//  KKFileManager.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/11/18.
//  Copyright © 2018 keke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    KKFilePathRooterDoc,
    KKFilePathRooterLibCaches,
    KKFilePathRooterTmp,
}KKFilePathRooter;

typedef void(^KKFileWriteHandle)(NSString * path , NSError * error , BOOL result);

typedef void(^KKFileReadHandle)(NSString * path , id data , NSError * error , BOOL result);

NS_ASSUME_NONNULL_BEGIN

@interface KKFileManager : NSObject
/**
 *  主目录
 *
 *  @return 主目录地址
 */
+(NSString *)homePath;


/**
 *  app路径
 *
 *  @return app路径
 */
+(NSString *)appPath;


/**
 *  document路径，可以同步itunes备份，退出不删
 *
 *  @return document路径
 */
+(NSString *)docPath;


/**
 *  Library/Caches缓存路径，无法同步itunes备份，退出不删
 *
 *  @return Library/Caches缓存路径
 */
+(NSString *)libCachePath;


/**
 *  tmp临时缓存路径，退出即删
 *
 *  @return tmp临时缓存路径
 */
+(NSString *)tmpPath;


/**
 *  检查是否有此路径
 *
 *  @param rooter 根目录
 *  @param name   文件路径 若多重目录用"/"隔开
 *
 *  @return 是否
 */
+(BOOL)hasLivePathWithRooter:(KKFilePathRooter)rooter withName:(NSString*)name;

/**
 *  添加一个路径，如果没有就添加
 *
 *  @param rooter 根目录
 *  @param name   文件路径  若多重目录用"/"隔开
 *
 *  @return 创建的路径
 */
+(NSString*)makePathWithRooter:(KKFilePathRooter)rooter withName:(NSString*)name;

/**
 *  添加一个路径，如果没有就添加
 *
 *  @param rooter 根目录
 *  @param name   文件路径  若多重目录用"/"隔开
 *
 *  @return 创建的路径
 */
+(NSString*)createPathWithRooter:(KKFilePathRooter)rooter withName:(NSString*)name;

/**
 *  写入文件
 *
 *  @param path   文件路径 若多重目录用"/"隔开
 *  @param rooter 根目录
 *  @param data   文件数据
 *  @param isrecover 是否覆盖  no表示追加
 *  @param handle 写完回调
 */
+(void)writeDataWithPath:(NSString *)path wihtRooter:(KKFilePathRooter)rooter withData:(id)data needRecover:(BOOL)isrecover withFinishHandle:(KKFileWriteHandle)handle;
/**
 *  读取文件成字符串
 *
 *  @param path   文件路径 若多重目录用"/"隔开
 *  @param rooter 根目录
 *  @param handle 读完回调
 */
+(void)readStringWithPath:(NSString *)path withRooter:(KKFilePathRooter)rooter withFinishHandle:(KKFileReadHandle)handle;
/**
 *  读取文件成字典
 *
 *  @param path   文件路径 若多重目录用"/"隔开
 *  @param rooter 根目录
 *  @param handle 读完回调
 */
+(void)readDicWithPath:(NSString *)path withRooter:(KKFilePathRooter)rooter withFinishHandle:(KKFileReadHandle)handle;
/**
 *  读取文件成数组
 *
 *  @param path   文件路径 若多重目录用"/"隔开
 *  @param rooter 根目录
 *  @param handle 读完回调
 */
+(void)readArrayWithPath:(NSString *)path withRooter:(KKFilePathRooter)rooter withFinishHandle:(KKFileReadHandle)handle;
/**
 *  读取文件成数据流
 *
 *  @param path   文件路径 若多重目录用"/"隔开
 *  @param rooter 根目录
 *  @param handle 读完回调
 */
+(void)readDataWithPath:(NSString *)path withRooter:(KKFilePathRooter)rooter withFinishHandle:(KKFileReadHandle)handle;
/**
 *  删除文件
 *
 *  @param path   文件路径 若多重目录用"/"隔开
 *  @param rooter 根目录
 *
 *  @return 删除是否成功
 */
+(BOOL)removeDataWithPath:(NSString *)path wihtRooter:(KKFilePathRooter)rooter;
/**
 *  文件大小
 *
 *  @param path   文件路径 若多重目录用"/"隔开
 *  @param rooter 根目录
 *
 *  @return 大小
 */
+ (long long) fileSizeAtPath:(NSString *)path withRooter:(KKFilePathRooter)rooter;
@end

NS_ASSUME_NONNULL_END
