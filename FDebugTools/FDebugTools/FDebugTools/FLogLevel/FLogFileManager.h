//
//  FLogFileManager.h
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *将日志写入临时文件夹,建议每次启动创建新的文件，每次Terminate删除文件
 *为了保证文件安全性，应该是多读单写的机制
 */

typedef void(^FLogFileManagerBlock)(void);

@interface FLogFileManager : NSObject
@property (nonatomic, copy)FLogFileManagerBlock fileDidChanged;

+ (instancetype)shareInstance;

- (BOOL)writeLogContent:(NSString *)content;

- (BOOL)clearLog;

- (NSString *)readLog;

@end

NS_ASSUME_NONNULL_END
