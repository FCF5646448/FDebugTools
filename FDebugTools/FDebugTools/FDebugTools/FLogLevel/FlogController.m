//
//  FlogController.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FlogController.h"

/**日志展示Controller*/
@interface FlogController ()
@property (strong, nonatomic)UIToolbar * topBar;
@property (strong, nonatomic)UITextView * logTV;
@property (strong, nonatomic)UITableView * setTV;
@end

@implementation FlogController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self initUI];
}

- (void)initUI {
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    self.topBar = [[UIToolbar alloc] initWithFrame:(CGRect){0,0,w,44}];
    
    UIButton * logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logBtn setImage:[UIImage imageNamed:@"print"] forState:UIControlStateNormal];
    [logBtn setImage:[UIImage imageNamed:@"printSelect"] forState:UIControlStateSelected];
    UIBarButtonItem * logItem = [[UIBarButtonItem alloc] initWithCustomView:logBtn];
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [setBtn setImage:[UIImage imageNamed:@"settingSelect"] forState:UIControlStateSelected];
    UIBarButtonItem * setItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    
    self.topBar.items = @[logItem, setItem];
    [self.view addSubview:self.topBar];
    
    UIScrollView * contentSc = [[UIScrollView alloc] initWithFrame:(CGRect){0,44,w,h-44}];
    contentSc.contentSize = CGSizeMake(w*self.topBar.items.count, h-44);
    [self.view addSubview:contentSc];
    
    _logTV = [[UITextView alloc] initWithFrame:(CGRect){0,0,w,contentSc.frame.size.height}];
    _logTV.text = @"xxxxxxxxxxxxxxxxxx";
    [contentSc addSubview:_logTV];
    
    
}

- (void)printBtnAction:(UIBarButtonItem *)sender {
    
}

- (void)setBtnAction:(UIBarButtonItem *)sender {
    
}

@end
