//
//  FlogController.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FlogController.h"
#import "FLogFileManager.h"
#import "IPTool.h"

/**日志展示Controller*/
@interface FlogController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (strong, nonatomic)UIToolbar * topBar;
@property (strong, nonatomic)UIScrollView * contentSc;
@property (strong, nonatomic)UITextView * logTV;
@property (strong, nonatomic)UITableView * setTV;

@property (strong, nonatomic)UIButton * logBtn;
@property (strong, nonatomic)UIButton * setBtn;
@property (strong, nonatomic)UIButton * clearBtn;

@property (strong, nonatomic)NSMutableDictionary* dataSource;
@end

@implementation FlogController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableDictionary dictionary];
    [self.dataSource setObject:[NSString stringWithFormat:@"IP: %@",[IPTool getIPAddress]] forKey:@"IP"];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self printBtnAction:self.logBtn];
    [self readLog];
    [self.logTV scrollRangeToVisible:NSMakeRange(self.logTV.text.length, 1)];
}

- (void)initUI {
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    self.topBar = [[UIToolbar alloc] initWithFrame:(CGRect){0,0,w,44}];
    self.topBar.backgroundColor = [UIColor blueColor];
    UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = (CGRect){0,0,w/3.0,44};
    [returnBtn setImage:[UIImage imageNamed:@"re-turn"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * returnItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    
    _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _logBtn.frame = CGRectMake(w/3.0, 0,w/3.0, 44);
    [_logBtn addTarget:self action:@selector(printBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_logBtn setImage:[UIImage imageNamed:@"print"] forState:UIControlStateNormal];
    UIBarButtonItem * logItem = [[UIBarButtonItem alloc] initWithCustomView:_logBtn];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(w/3.0 * 2.0, 0, w/3.0, 44);
    [_setBtn addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_setBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    UIBarButtonItem * setItem = [[UIBarButtonItem alloc] initWithCustomView:_setBtn];
    
    self.topBar.items = @[returnItem,logItem,setItem];
    [self.view addSubview:self.topBar];
    
    _contentSc = [[UIScrollView alloc] initWithFrame:(CGRect){0,44,w,h-44}];
    _contentSc.pagingEnabled = YES;
    _contentSc.delegate = self;
    _contentSc.contentSize = CGSizeMake(w*self.topBar.items.count, h-44);
    [self.view addSubview:_contentSc];
    
    _logTV = [[UITextView alloc] initWithFrame:(CGRect){0,0,w,_contentSc.frame.size.height}];
    _logTV.text = @"日志打印：";
    _logTV.layoutManager.allowsNonContiguousLayout = NO;
    [_contentSc addSubview:_logTV];
    _logTV.backgroundColor = [UIColor clearColor];
    _logTV.textColor = UIColor.whiteColor;
    
    _setTV = [[UITableView alloc] initWithFrame:(CGRect){w,0,w,_contentSc.frame.size.height} style:UITableViewStylePlain];
    [_setTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellDefault"];
    _setTV.backgroundColor = [UIColor clearColor];
    _setTV.tableFooterView = [UIView new];
    [_contentSc addSubview:_setTV];
    _setTV.delegate = self;
    _setTV.dataSource = self;
    
    __weak typeof(FlogController *)weakself = self;
    [FLogFileManager shareInstance].fileDidChanged = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself readLog];
            [weakself.logTV scrollRangeToVisible:NSMakeRange(self.logTV.text.length, 1)];
        });
    };
    
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _clearBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 60, 44, 44);
    [_clearBtn setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentSc addSubview:_clearBtn];
    _clearBtn.layer.cornerRadius = 22.0;
    _clearBtn.layer.masksToBounds = YES;
    
    
    //缩小时的按钮
    _iconBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _iconBtn.frame = self.view.bounds;
    _iconBtn.backgroundColor = UIColor.whiteColor;
    [_iconBtn setImage:[UIImage imageNamed:@"console"] forState:UIControlStateNormal];
    _iconBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_iconBtn addTarget:self action:@selector(iconBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_iconBtn];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_iconBtn addGestureRecognizer:pan];
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
    
    self.clearBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 60, 44, 44);
    
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    
    //移动中
    CGPoint p = [recognizer translationInView:self.iconBtn]; //在keywindow上的位置
    CGRect originF = self.originRect;
    if (originF.origin.x >= 0 || originF.origin.x + originF.size.width <= kScreenWidth ) {
        originF.origin.x += p.x;
    }
    if (originF.origin.y >= 0 || originF.origin.y + originF.size.height <= kScreenHeight) {
        originF.origin.y += p.y;
    }
    
    NSLog(@"x:%f,y:%f", originF.origin.x,originF.origin.y);
    
    self.originRect = originF;
    
    [recognizer setTranslation:CGPointZero inView:[UIApplication sharedApplication].keyWindow];
    
    if (self.callback) {
        self.callback(move);
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.iconBtn.enabled = NO;
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //移动结束
        self.iconBtn.enabled = YES;
        if (self.callback) {
            self.callback(movend);
        }
    }
    
}

- (void)printBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _setBtn.selected = NO;
    self.clearBtn.alpha = 1;
    self.contentSc.contentOffset = CGPointMake(0, 0);
}

- (void)setBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _logBtn.selected = NO;
    self.clearBtn.alpha = 0;
    self.contentSc.contentOffset = CGPointMake(self.view.frame.size.width, 0);
}

- (void)returnBtnAction {
    if (self.callback) {
        self.callback(min);
    }
}

//
- (void)iconBtnAction:(UIButton *)sender {
    if (self.callback) {
        self.callback(max);
    }
}

- (void)clearBtnAction:(UIButton *)sender {
    [[FLogFileManager shareInstance] clearLog];
    [self readLog];
}

//读取文件，并监听文件/文件夹的变化
- (void)readLog {
    self.logTV.text = [[FLogFileManager shareInstance] readLog];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat w = self.view.frame.size.width;
    if (scrollView == self.contentSc) {
        
        CGFloat alpha = self.contentSc.contentOffset.x*1.0/w;
        NSLog(@"w:%f; a:%f", self.contentSc.contentOffset.x,alpha);
        self.clearBtn.alpha = alpha > 0 ? (1-alpha): 1;
    }
}

#pragma mark - UITableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellDefault" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.dataSource[@"IP"];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - 获取IP


@end
