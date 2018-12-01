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
@property (strong, nonatomic)UIScrollView * contentSc;
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
    [self readLog];
}

- (void)initUI {
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    self.topBar = [[UIToolbar alloc] initWithFrame:(CGRect){0,0,w,44}];
    
    UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = (CGRect){0,0,44,44};
    [returnBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * returnItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    
    _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _logBtn.frame = CGRectMake(44, 0,(w-44)/2.0, 44);
    [_logBtn addTarget:self action:@selector(printBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_logBtn setImage:[UIImage imageNamed:@"print"] forState:UIControlStateNormal];
    [_logBtn setImage:[UIImage imageNamed:@"printSelect"] forState:UIControlStateSelected];
    UIBarButtonItem * logItem = [[UIBarButtonItem alloc] initWithCustomView:_logBtn];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake((w-44)/2.0+44, 0, (w-44)/2.0, 44);
    [_setBtn addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_setBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [_setBtn setImage:[UIImage imageNamed:@"settingSelect"] forState:UIControlStateSelected];
    UIBarButtonItem * setItem = [[UIBarButtonItem alloc] initWithCustomView:_setBtn];
    
    self.topBar.items = @[returnItem,logItem,setItem];
    [self.view addSubview:self.topBar];
    
    _contentSc = [[UIScrollView alloc] initWithFrame:(CGRect){0,44,w,h-44}];
    _contentSc.pagingEnabled = YES;
    _contentSc.contentSize = CGSizeMake(w*self.topBar.items.count, h-44);
    [self.view addSubview:_contentSc];
    
    _logTV = [[UITextView alloc] initWithFrame:(CGRect){0,0,w,_contentSc.frame.size.height}];
    _logTV.text = @"日志打印：";
    _logTV.layoutManager.allowsNonContiguousLayout = NO;
    [_contentSc addSubview:_logTV];
    _logTV.backgroundColor = [UIColor clearColor];
    
    _setTV = [[UITableView alloc] initWithFrame:(CGRect){w,0,w,_contentSc.frame.size.height} style:UITableViewStylePlain];
    [_setTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellDefault"];
    [_contentSc addSubview:_setTV];
    _setTV.delegate = self;
    _setTV.dataSource = self;
    
    __weak typeof(FlogController *)weakself = self;
    [FLogFileManager shareInstance].fileDidChanged = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself readLog];
        });
    };
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    self.topBar.frame = (CGRect){0,0,w,44};
    self.contentSc.frame = (CGRect){0,44,w,h-44};
    self.contentSc.contentSize = CGSizeMake(w*self.topBar.items.count, h-44);
    
    self.logTV.frame = (CGRect){0,0,w,_contentSc.frame.size.height};
    self.setTV.frame = (CGRect){w,0,w,_contentSc.frame.size.height};
    
}

- (void)printBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _setBtn.selected = NO;
    
    self.contentSc.contentOffset = CGPointMake(0, 0);
}

- (void)setBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _logBtn.selected = NO;
    self.contentSc.contentOffset = CGPointMake(self.view.frame.size.width, 0);
}

- (void)returnBtnAction {
    self.callback();
}

//读取文件，并监听文件/文件夹的变化
- (void)readLog {
    self.logTV.text = [[FLogFileManager shareInstance] readLog];
    [self.logTV scrollRangeToVisible:NSMakeRange(self.logTV.text.length, 1)];
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
