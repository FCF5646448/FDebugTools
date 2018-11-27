//
//  FLogConsoleManager.h
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define FLog(frmt, ...) Log_objc(frmt, ##__VA_ARGS__)
#else
#define FLog(frmt, ...)
#endif

#define Log_objc(frmt, ...)     \
Log_func(__PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define Log_func(fnct,frmt,...)     \
do{ if(1 & 1) Log(__FILE__, fnct, frmt, ##__VA_ARGS__); } while(0)

#define Log(file,fnct,frmt, ...)     \
[[FLogConsoleManager shareInstance] logFile : file     \
func : fnct     \
line : __LINE__     \
format : (frmt), ##__VA_ARGS__]

//fprintf(stderr,"\nFunction:%s Line:%d Content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])




@interface FLogConsoleManager : NSObject

+ (instancetype)shareInstance;

- (void)logFile:(const char*)file
           func:(const char*)func
           line:(NSUInteger)line
         format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

@end
