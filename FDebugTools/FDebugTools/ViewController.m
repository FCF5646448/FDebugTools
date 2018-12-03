//
//  ViewController.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "FLogLevel.h"
#import "FLogConsoleManager.h"
#import "UIButton+Extention.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"Tools";
    FLog(@"viewDidLoad");
    
    int i =0;
    while (i < 10) {
        FLog(@"xx:%d",i++);
    }
    //
    UIButton * btn = [UIButton createBtnTitle:@"test" andFrame:(CGRect){50,50,100,44} btnAction:^{
        FLog(@"按钮点击测试");
    }];
    [self.view addSubview:btn];
    
    UIButton * btn1 = [UIButton createBtnTitle:@"show" andFrame:(CGRect){200,50,100,44} btnAction:^{
        [[FLogLevel shareInstance] minShow];
    }];
    
    [self.view addSubview:btn1];
    
    UIButton * btn2 = [UIButton createBtnTitle:@"hide" andFrame:(CGRect){50,100,100,44} btnAction:^{
        [[FLogLevel shareInstance] hide];
    }];
    [self.view addSubview:btn2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FLog(@"%@",@"viewWillAppear");
}



@end
