//
//  Tool.m
//  FDebugTools
//
//  Created by 冯才凡 on 2019/1/24.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import "Tool.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIKitDefines.h>
#import <objc/message.h>
#import "sys/utsname.h"

@implementation Tool
+ (ScreenType)currentScreenType{
    int height = (int)[UIScreen mainScreen].bounds.size.height;
    //UIDevice.current.name.hasPrefix("iPad")
    if ([UIDevice.currentDevice.name hasPrefix:@"iPad"]) {
        return iPad;
    }
    switch (height) {
        case 960:
            return iPhones_4_4S;
        case 1136:
            return iPhones_5_5s_5c_SE;
        case 1334:
            return iPhones_6_6s_7_8;
        case 1792:
            return iPhone_XR;
        case 1920:
            return iPhones_6Plus_6sPlus_7Plus_8Plus;
        case 2208:
            return iPhones_6Plus_6sPlus_7Plus_8Plus;
        case 2436:
            return iPhones_X_XS;
        case 2688:
            return iPhone_XSMax;
        default:
            return iPhone_unknown;
            break;
    }
    
}

@end
