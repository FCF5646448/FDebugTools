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

@property (nonatomic, assign) CGRect originRect;

- (void)readLog;

@end

NS_ASSUME_NONNULL_END
