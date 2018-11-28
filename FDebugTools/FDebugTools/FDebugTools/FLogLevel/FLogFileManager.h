//
//  FLogFileManager.h
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**将日志写入临时文件夹,建议每次启动创建新的文件，每次Terminate删除文件*/
@interface FLogFileManager : NSObject
+ (instancetype)shareInstance;

- (BOOL)writeLogContent:(NSObject *)content;

- (BOOL)clearLog;

- (NSString *)readLog;

//+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
//- (instancetype)init __attribute__((unavailable("init not availbale, call shareInstance instead")));
//+ (instancetype)new __attribute__((unvailable("new not availbale, call shareInstance instead")));

@end

NS_ASSUME_NONNULL_END
