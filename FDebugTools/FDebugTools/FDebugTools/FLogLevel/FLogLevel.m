//
//  FLogLevel.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FLogLevel.h"
#import "FlogController.h"

@interface FLogLevel()
@property (assign, nonatomic)CGRect defaultRect; //放大时dframe
@property (assign, nonatomic)CGRect originRect; //缩小时frame

@end

@implementation FLogLevel

+ (instancetype)shareInstance {
    static FLogLevel * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FLogLevel alloc] init];
    });
    return instance;
}

- (instancetype)init {
    CGRect baseRect = (CGRect){0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height*2.0/3};
    CGRect minRect = CGRectMake([UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.height-40-100, 40, 40);
    
    self = [super initWithFrame:baseRect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];//[ colorWithAlphaComponent:1];
        self.defaultRect = baseRect;
        self.originRect = minRect;
        self.windowLevel = UIWindowLevelStatusBar + 100;
        FlogController * vc = [FlogController new];
        self.rootViewController = vc;
    }
    return self;
}

- (void)maxshow {
    self.frame = self.defaultRect;
}

- (void)minShow {
    self.frame = self.originRect;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rootViewController.view.frame = self.bounds;
}

- (void)hide {
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
