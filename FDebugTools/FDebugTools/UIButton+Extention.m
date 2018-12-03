//
//  UIButton+Extention.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/29.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "UIButton+Extention.h"
#import <objc/runtime.h>

static NSString * key = @"btnAction";

@implementation UIButton (Extention)
+ (UIButton *)createBtnTitle:(NSString *)title andFrame:(CGRect)frame btnAction:(btnAction)actionCallback {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:btn action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(btn, &key, actionCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return btn;
}

- (void)btnAction:(UIButton *)sender {
    btnAction block = (btnAction)objc_getAssociatedObject(sender, &key);
    if (block) {
        block();
    }
}

@end
