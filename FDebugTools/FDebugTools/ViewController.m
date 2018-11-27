//
//  ViewController.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "FLogConsoleManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tools";
    
    FLog(@"xxxx");
//    FLog(@"viewDidLoad");
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FLog(@"%@",@"viewWillAppear");
}


@end
