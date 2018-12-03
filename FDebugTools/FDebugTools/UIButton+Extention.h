//
//  UIButton+Extention.h
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/29.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^btnAction)(void);

@interface UIButton (Extention)
+ (UIButton *)createBtnTitle:(NSString *)title andFrame:(CGRect)frame btnAction:(btnAction)actionCallback;
@end

NS_ASSUME_NONNULL_END
