//
//  FLogConsoleManager.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FLogConsoleManager.h"

@interface FLogConsoleManager()



@end

@implementation FLogConsoleManager

+ (instancetype)shareInstance {
    static FLogConsoleManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [FLogConsoleManager new];
    });
    return _instance;
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
    
    NSString * fileStr = [[NSString stringWithUTF8String:file] lastPathComponent]; //file拿到的是文件路径
    NSString * funcStr = [NSString stringWithUTF8String:func];
    NSDateFormatter * format = [NSDateFormatter new];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString * timeStr = [format stringFromDate:[NSDate new]];
    
    NSString * msgResult = [NSString stringWithFormat:@"\nclass:%@:\n func:%@\n line:%ld\n time:%@\n %@\n\n",fileStr,funcStr,line,timeStr,msg];
    
    const char * resultCString = NULL;
    if ([msgResult canBeConvertedToEncoding:NSUTF8StringEncoding]) {
        resultCString = [msgResult cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    printf("☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️BEGIN☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️");
    printf("%s",resultCString);
    printf("👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻END👻👻👻👻👻👻👻👻👻👻👻👻👻👻");
    
    //将log写入文件
    
    
    
}

@end
