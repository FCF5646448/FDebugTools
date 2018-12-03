//
//  FlogController.h
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    min = 0,
    max = 1,
} VCCallBackType;

typedef void(^returnBtnAction)(VCCallBackType type);


@interface FlogController : UIViewController
@property (nonatomic, copy)returnBtnAction callback;

@property (nonatomic, strong) UIButton * iconBtn;

@end

NS_ASSUME_NONNULL_END
