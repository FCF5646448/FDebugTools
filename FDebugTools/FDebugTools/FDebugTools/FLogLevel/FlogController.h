//
//  FlogController.h
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define KAppDelegate ([UIApplication sharedApplication].delegate)
#define  FNavBarHeight ((IS_IPHONE_X_XR_MAX) ? (88) : (64))
#define  FTabBarHeight ((IS_IPHONE_X_XR_MAX) ? (83) : (49))
#define  FStatusBarHeight ((IS_IPHONE_X_XR_MAX) ? (44) : (20))

#define IS_IPHONE_X_XR_MAX ([Tool currentScreenType] == iPhones_X_XS || [Tool currentScreenType] == iPhone_XR  || [Tool currentScreenType] == iPhone_XSMax)

#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    min = 0,
    max = 1,
    move = 3,
    movend = 4, //y拖动结束
} VCCallBackType;

typedef void(^returnBtnAction)(VCCallBackType type);


@interface FlogController : UIViewController
@property (nonatomic, copy)returnBtnAction callback;

@property (nonatomic, strong) UIButton * iconBtn;
@property (strong, nonatomic)UIButton * returnBtn;

@property (nonatomic, assign) CGRect originRect;

@property (nonatomic, assign) BOOL ifAllowUseInterface;

- (void)readLog;

@end

NS_ASSUME_NONNULL_END
