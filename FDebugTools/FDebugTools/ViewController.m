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
    
    self.title = @"Tools";
    FLog(@"viewDidLoad");
    
    int i =0;
    while (i < 10) {
        FLog(@"xx:%d",i++);
    }
//    FLog(@"viewDidLoad");
    
    
    UIButton * btn = [UIButton createBtnTitle:@"shabi" btnAction:^{
        FLog(@"%@",@"按钮点击");
    }];
    
    [self.view addSubview:btn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FLog(@"%@",@"viewWillAppear");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[FLogLevel shareInstance] minShow];
}


@end
