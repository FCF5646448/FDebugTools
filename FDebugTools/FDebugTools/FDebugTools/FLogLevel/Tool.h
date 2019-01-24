//
//  Tool.h
//  FDebugTools
//
//  Created by 冯才凡 on 2019/1/24.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    iPhones_4_4S,
    iPhones_5_5s_5c_SE,
    iPhones_6_6s_7_8,
    iPhone_XR,
    iPhones_6Plus_6sPlus_7Plus_8Plus,
    iPhones_X_XS,
    iPhone_XSMax,
    iPad,
    iPhone_unknown
} ScreenType;

@interface Tool : NSObject
+ (ScreenType)currentScreenType;
@end

NS_ASSUME_NONNULL_END
