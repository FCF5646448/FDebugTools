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
    CGRect minRect = CGRectMake(kScreenWidth-60, kScreenHeight-40-60, 50, 50);
    
    self = [super initWithFrame:minRect];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.defaultRect = baseRect;
        self.originRect = minRect;
        self.windowLevel = UIWindowLevelStatusBar + 100;
        FlogController * vc = [FlogController new];
        vc.originRect = minRect;
        __weak typeof(FLogLevel *) weakSelf = self;
        vc.callback = ^(VCCallBackType type) {
            if (type == min) {
                [weakSelf minShow];
            }else if (type == max) {
                [weakSelf maxshow];
            }else if (type == move) {
                [weakSelf changeOrigin];
            }else if (type == movend) {
                [weakSelf movendOrigin];
            }
        };
        self.rootViewController = vc;
    }
    return self;
}

- (void)maxshow {
    [self makeKeyAndVisible];
    self.frame = self.defaultRect;
    ((FlogController *)self.rootViewController).iconBtn.hidden = YES;
    [self setNeedsLayout];
    [((FlogController *)self.rootViewController) readLog];
}

- (void)minShow {
    [self makeKeyAndVisible];
    self.frame = self.originRect;
    ((FlogController *)self.rootViewController).iconBtn.hidden = NO;
    [self setNeedsLayout];
}

//一定是缩小的时候才出发
- (void)changeOrigin {
    [self makeKeyAndVisible];
    self.originRect = ((FlogController *)self.rootViewController).originRect;
    self.frame = self.originRect;
    [self setNeedsLayout];
}

- (void)movendOrigin {
    CGRect rect = self.originRect;
    if (rect.origin.x < kScreenWidth/2.0 && rect.origin.x > 0) {
        rect.origin.x = 5;
    }
    
    if (rect.origin.x >= kScreenWidth/2.0 &&  rect.origin.x < (kScreenWidth - 5 - 50)) {
        rect.origin.x = (kScreenWidth - 5 - 50);
    }
    
    if (rect.origin.y < 64) {
        rect.origin.y = 64;
    }
    
    if (rect.origin.y > kScreenHeight - 50 - 60 ) {
        rect.origin.y = kScreenHeight - 50 - 60;
    }
    
    [UIView animateWithDuration:0.38 animations:^{
        self.originRect = rect;
        self.frame = self.originRect;
        ((FlogController *)self.rootViewController).originRect = self.originRect;
        [self setNeedsLayout];
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rootViewController.view.frame = self.bounds;
}

- (void)hide {
    self.hidden = YES;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
