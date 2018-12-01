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
    CGRect baseRect = (CGRect){0,kScreenHeight*1.0/3.0,kScreenWidth,kScreenHeight*2.0/3.0};
    CGRect minRect = CGRectMake(kScreenWidth-100, kScreenHeight-40-100, 100, 100);
    
    self = [super initWithFrame:minRect];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.defaultRect = baseRect;
        self.originRect = minRect;
        self.windowLevel = UIWindowLevelStatusBar + 100;
        FlogController * vc = [FlogController new];
        __weak typeof(FLogLevel *) weakSelf = self;
        vc.callback = ^{
            [weakSelf minShow];
        };
        self.rootViewController = vc;
    }
    return self;
}

- (void)maxshow {
    [self makeKeyAndVisible];
    self.frame = self.defaultRect;
    [self setNeedsLayout];
}

- (void)minShow {
    [self makeKeyAndVisible];
    self.frame = self.originRect;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rootViewController.view.frame = self.bounds;
}

- (void)hide {
    [self resignKeyWindow];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
