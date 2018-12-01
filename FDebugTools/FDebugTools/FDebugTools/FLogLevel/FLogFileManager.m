//
//  FLogFileManager.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FLogFileManager.h"

static char *queueName = "FLogFileManagerQueue";

@interface FLogFileManager()
@property (nonatomic, strong)dispatch_queue_t queue;
@property (nonatomic, strong)dispatch_source_t source;
@property (nonatomic, assign)NSInteger lastLength; //最后字节
@end

@implementation FLogFileManager
+ (instancetype)shareInstance {
    static FLogFileManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FLogFileManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_CONCURRENT); //创建一个并行队列
        [self startMonitorFile];
    }
    return self;
}

//所有日志z写在一个文件里。
- (NSString *)path{
    NSString * docPath = NSTemporaryDirectory();
    NSString* txtPath = [docPath stringByAppendingPathComponent:@"flog.txt"];
    return txtPath;
}

- (BOOL)isExitsAtPath:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError * __autoreleasing)error {
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL isSuccess;
    if ([manager fileExistsAtPath:path isDirectory:&isSuccess]) {
        isSuccess = YES;
    }else{
        isSuccess = [manager createFileAtPath:path contents:nil attributes:nil];//注意不能用创建文件夹的函数创建
    }
    return isSuccess;
}

- (BOOL)writeLogContent:(NSString *)content {
    if ([self createDirectoryAtPath:[self path] error:nil]) {
        return [self writeLog:[self path] content:content];
    }else{
        [NSException raise:@"创建文件失败" format:@"创建文件失败"];
        return NO;
    }
}

- (BOOL)clearLog {
    return [self removeItemAtPath:[self path] error:nil];
}

//
- (NSString *)readLog {
    __block NSString * resultStr;
    NSData * data = [[NSFileManager defaultManager] contentsAtPath:[self path]];
    resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return resultStr;
}


- (BOOL)writeLog:(NSString *)path content:(NSString *)content {
    if (!content) {
        [NSException raise:@"写入内容为空" format:@"写入内容不能为空"];
        return NO;
    }
    __block BOOL isSuccess;
    dispatch_barrier_sync(_queue, ^{
        if ([self isExitsAtPath:path]){
            NSFileHandle * fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
            [fileHandle seekToEndOfFile]; //将字节跳到文件末尾
            [fileHandle writeData:[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
            isSuccess = YES;
        }else{
            //第一次写入文件
            NSError * error;
            isSuccess = [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }
    });
    return isSuccess;
}

- (BOOL)removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

- (void)startMonitorFile {
    
    NSURL *directoryURL = [NSURL URLWithString:[self path]];
    int const fd =
    open([[directoryURL path] fileSystemRepresentation], O_EVTONLY); //O_EVTONLY：仅为事件通知请求的描述符 notifications only */
    if (fd < 0) {
        NSLog(@"Unable to open the path = %@", [directoryURL path]);
        return;
    }
    dispatch_source_t source =
    dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd,
                           DISPATCH_VNODE_WRITE,
                           DISPATCH_TARGET_QUEUE_DEFAULT);
    __weak typeof(FLogFileManager *)weakself = self;
    dispatch_source_set_event_handler(source, ^() {
        unsigned long const type = dispatch_source_get_data(source);
        switch (type) {
            case DISPATCH_VNODE_WRITE: {
                NSLog(@"目录内容改变!!!\n");
                weakself.fileDidChanged();
                break;
            }
            default:
                break;
        }
    });
    dispatch_source_set_cancel_handler(source, ^{
        close(fd);
    });
    self.source = source;
    dispatch_resume(self.source);
}

- (void)stopManager {
    dispatch_cancel(self.source);
}

@end
