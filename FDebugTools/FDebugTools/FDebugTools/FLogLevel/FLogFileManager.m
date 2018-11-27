//
//  FLogFileManager.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FLogFileManager.h"

@interface FLogFileManager()

@end

@implementation FLogFileManager
+ (instancetype)shareInstance {
    static FLogFileManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FLogFileManager new];
    });
    return instance;
}

- (NSString *)dateStr {
    NSDateFormatter * dformatter = [NSDateFormatter new];
    dformatter.dateFormat = @"yyyy-MM-dd";
    NSString * dateStr = [dformatter stringFromDate:[NSDate new]];
    return dateStr;
}

- (NSString *)path{
    return [NSString stringWithFormat:@"%@/temp/%@",NSTemporaryDirectory(),[self dateStr]];
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
        isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return isSuccess;
}

- (BOOL)writeLogContent:(NSObject *)content {
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


- (BOOL)writeLog:(NSString *)path content:(NSObject *)content {
    if (!content) {
        [NSException raise:@"写入内容为空" format:@"写入内容不能为空"];
        return NO;
    }
    if ([self isExitsAtPath:path]){
        if ([content isKindOfClass:[NSMutableArray class]]) {
            [(NSMutableArray *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSArray class]]) {
            [(NSArray *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableData class]]) {
            [(NSMutableData *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSData class]]) {
            [(NSData *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableDictionary class]]) {
            [(NSMutableDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSDictionary class]]) {
            [(NSDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSJSONSerialization class]]) {
            [(NSDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableString class]]) {
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSString class]]) {
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
        }else{
            [NSException raise:@"非法的文件内容" format:@"文件类型%@异常，无法被处理。", NSStringFromClass([content class])];
            return NO;
        }
    }else{
        return NO;
    }
    return YES;
}

- (BOOL)removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

@end
