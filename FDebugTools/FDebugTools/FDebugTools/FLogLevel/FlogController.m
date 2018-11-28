//
//  FlogController.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FlogController.h"
#import "FLogFileManager.h"

/**日志展示Controller*/
@interface FlogController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UIToolbar * topBar;
@property (strong, nonatomic)UITextView * logTV;
@property (strong, nonatomic)UITableView * setTV;

@property (strong, nonatomic)UIButton * logBtn;
@property (strong, nonatomic)UIButton * setBtn;
@end

@implementation FlogController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self printBtnAction:self.logBtn];
}

- (void)initUI {
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    self.topBar = [[UIToolbar alloc] initWithFrame:(CGRect){0,0,w,44}];
    
    _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _logBtn.frame = CGRectMake(0, 0, w/2.0, 44);
    [_logBtn addTarget:self action:@selector(printBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_logBtn setImage:[UIImage imageNamed:@"print"] forState:UIControlStateNormal];
    [_logBtn setImage:[UIImage imageNamed:@"printSelect"] forState:UIControlStateSelected];
    UIBarButtonItem * logItem = [[UIBarButtonItem alloc] initWithCustomView:_logBtn];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(0, w/2.0, w/2.0, 44);
    [_setBtn addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_setBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [_setBtn setImage:[UIImage imageNamed:@"settingSelect"] forState:UIControlStateSelected];
    UIBarButtonItem * setItem = [[UIBarButtonItem alloc] initWithCustomView:_setBtn];
    
    self.topBar.items = @[logItem,setItem];
    [self.view addSubview:self.topBar];
    
    UIScrollView * contentSc = [[UIScrollView alloc] initWithFrame:(CGRect){0,44,w,h-44}];
    contentSc.pagingEnabled = YES;
    contentSc.contentSize = CGSizeMake(w*self.topBar.items.count, h-44);
    [self.view addSubview:contentSc];
    
    _logTV = [[UITextView alloc] initWithFrame:(CGRect){0,0,w,contentSc.frame.size.height}];
    _logTV.text = @"xxxxxxxxxxxxxxxxxx";
    [contentSc addSubview:_logTV];
    _logTV.backgroundColor = [UIColor clearColor];
    
    _setTV = [[UITableView alloc] initWithFrame:(CGRect){w,0,w,contentSc.frame.size.height} style:UITableViewStylePlain];
    [_setTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellDefault"];
    [contentSc addSubview:_setTV];
    _setTV.delegate = self;
    _setTV.dataSource = self;
    
}

- (void)printBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _setBtn.selected = NO;
    [self readLog];
}

- (void)setBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _logBtn.selected = NO;
    
}

//读取文件，并监听文件/文件夹的变化
- (void)readLog {
    self.logTV.text = [[FLogFileManager shareInstance] readLog];
    
}


#pragma mark - UITableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellDefault" forIndexPath:indexPath];
    
    return cell;
}

@end
