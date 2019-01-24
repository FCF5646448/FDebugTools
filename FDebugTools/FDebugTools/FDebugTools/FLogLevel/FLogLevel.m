//
//  FLogLevel.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FLogLevel.h"
#import "Tool.h"
#import "FlogController.h"

@interface FLogLevel()
@property (assign, nonatomic)CGRect defaultRect; //放大时dframe
@property (assign, nonatomic)CGRect originRect; //缩小时frame
@property (assign, nonatomic)UIViewController * rootViewController;

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
    CGRect baseRect = (CGRect){0,SCREENH_HEIGHT*1.0/3.0,SCREEN_WIDTH,SCREENH_HEIGHT*2.0/3.0};
    CGRect minRect = CGRectMake(SCREEN_WIDTH-60, SCREENH_HEIGHT-40-FTabBarHeight, 50, 50);
    
    self = [super initWithFrame:minRect];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.defaultRect = baseRect;
        self.originRect = minRect;
        FlogController * vc = [[FlogController alloc] init];
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
        [self addSubview:vc.view];
        self.rootViewController = vc;
    }
    return self;
}

- (void)maxshow {
    [KAppDelegate.window addSubview:self];
    [KAppDelegate.window bringSubviewToFront:self];
    self.frame = self.defaultRect;
    ((FlogController *)self.rootViewController).iconBtn.hidden = YES;
    ((FlogController *)self.rootViewController).returnBtn.hidden = NO;
    [self setNeedsLayout];
    [((FlogController *)self.rootViewController) readLog];
    self.hidden = NO;
}

- (void)minShow {
    [KAppDelegate.window addSubview:self];
    [KAppDelegate.window bringSubviewToFront:self];
    self.frame = self.originRect;
    ((FlogController *)self.rootViewController).iconBtn.hidden = NO;
    ((FlogController *)self.rootViewController).returnBtn.hidden = YES;
    [self setNeedsLayout];
    self.hidden = NO;
}

//一定是缩小的时候才出发
- (void)changeOrigin {
    self.originRect = ((FlogController *)self.rootViewController).originRect;
    self.frame = self.originRect;
    [self setNeedsLayout];
}

- (void)movendOrigin {
    CGRect rect = self.originRect;
    if (rect.origin.x < SCREEN_WIDTH/2.0 ) {
        rect.origin.x = 5;
    }
    
    if (rect.origin.x >= SCREEN_WIDTH/2.0) {
        rect.origin.x = (SCREEN_WIDTH - 5 - 50);
    }
    
    if (rect.origin.y < FNavBarHeight) {
        rect.origin.y = FNavBarHeight;
    }
    
    if (rect.origin.y > SCREENH_HEIGHT - 50 - FTabBarHeight ) {
        rect.origin.y = SCREENH_HEIGHT - 50 - FTabBarHeight;
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
    [self removeFromSuperview];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView * gesView = [super hitTest:point withEvent:event];
    if ([gesView isKindOfClass:[UITextView class]]) {
        //        CGRect swipeRect = CGRectMake(SCREEN_WIDTH/4.0 * 3, 0, SCREEN_WIDTH/4.0, SCREENH_HEIGHT);
        //        if (CGRectContainsPoint(swipeRect, point)) {
        //            return gesView;
        //        }
        if (((FlogController *)self.rootViewController).ifAllowUseInterface) {
            return gesView;
        }
        return nil;
    }
    return gesView;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
