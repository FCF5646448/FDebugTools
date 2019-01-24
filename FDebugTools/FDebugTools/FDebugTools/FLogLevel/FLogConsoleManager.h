//
//  FLogConsoleManager.h
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

/*注：
 * frmt : 表示执行的是NSLog函数
 * ##__VA_ARGS__ 不定参数
 */

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



typedef void(^FLogConsoleManagerBlock)(void);

@interface FLogConsoleManager : NSObject
@property (nonatomic, copy)FLogConsoleManagerBlock logDidChanged;
+ (instancetype)shareInstance;

- (void)logFile:(const char*)file
           func:(const char*)func
           line:(NSUInteger)line
         format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

- (NSMutableArray<NSString *> *)getLogs;
- (void)clearLog;

// 外部调用将产生编译错误
+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
