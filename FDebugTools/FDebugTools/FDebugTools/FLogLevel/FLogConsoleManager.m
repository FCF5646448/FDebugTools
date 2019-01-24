//
//  FLogConsoleManager.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FLogConsoleManager.h"
#import "FLogFileManager.h"

@interface FLogConsoleManager()
@property (nonatomic, strong)NSMutableArray<NSString *> * logArr;
@property (nonatomic, strong)dispatch_queue_t syncQueue; //数据操作方法 (凡涉及更改数组中元素的操作，使用异步派发+栅栏块；读取数据使用 同步派发+并行队列)
@end

@implementation FLogConsoleManager

+ (instancetype)shareInstance {
    static FLogConsoleManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] initUnique];
        _instance.logArr = [NSMutableArray array];
        NSString* uuid = [NSString stringWithFormat:@"com.btclass.array_%p", self];
        _instance.syncQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT); //并行队列
    });
    return _instance;
}

- (instancetype)initUnique{
    return [super init];
}


- (void)logFile:(const char*)file
           func:(const char*)func
           line:(NSUInteger)line
         format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5) {
    va_list args;
    if (format) {
        
        va_start(args, format);
        
        NSString *msgStr = [[NSString alloc] initWithFormat:format arguments:args];
        
        [self recordLog:msgStr andfile:file andFunc:func andLine:line];
        
        va_end(args);
    }
}


- (void)recordLog:(NSString *)msg andfile:(const char*)file andFunc:(const char *)func andLine:(NSUInteger)line {
    dispatch_barrier_async(_syncQueue, ^{
        NSString * fileStr = [[NSString stringWithUTF8String:file] lastPathComponent]; //file拿到的是文件路径
        NSString * funcStr = [NSString stringWithUTF8String:func];
        NSDateFormatter * format = [NSDateFormatter new];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSString * timeStr = [format stringFromDate:[NSDate new]];
        
        NSString * msgResult = [NSString stringWithFormat:@"\n class:%@: [line:%ld]\n func:%@\n  time:%@\n %@\n\n",fileStr,line,funcStr,timeStr,msg];
        //数量大于10就删除第一条
        if (self.logArr.count >= 10) {
            [self.logArr removeObjectAtIndex:0];
        }
        
        [self.logArr addObject:[NSString stringWithFormat:@"%@\n",msgResult]];
        
        if (self.logDidChanged){
            self.logDidChanged();
        }
    });
    //将log写入文件，注意读写的线程的安全问题
    //    BOOL isSuccess = [[FLogFileManager shareInstance] writeLogContent:msgResult];
    //    if (isSuccess) {
    //        printf("写入成功\n");
    //    }else{
    //        printf("写入失败\n");
    //    }
}

- (NSMutableArray<NSString *> *)getLogs {
    __block NSMutableArray<NSString *> * tempArr;
    dispatch_sync(_syncQueue, ^{
        tempArr = [self.logArr mutableCopy];
    });
    return tempArr;
}

- (void)clearLog {
    dispatch_barrier_async(_syncQueue, ^{
        [self.logArr removeAllObjects];
    });
}

- (void)dealloc{
    if (_syncQueue) {
        _syncQueue = NULL;
    }
}

@end
