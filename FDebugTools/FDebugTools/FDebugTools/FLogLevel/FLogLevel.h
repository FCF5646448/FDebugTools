//
//  FLogLevel.h
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FLogLevel : UIWindow
+ (instancetype)shareInstance;

- (void)minShow;

- (void)maxshow;

- (void)hide;

@end

