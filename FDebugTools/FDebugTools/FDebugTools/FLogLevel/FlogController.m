//
//  FlogController.m
//  FDebugTools
//
//  Created by 冯才凡 on 2018/11/27.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "FlogController.h"
//#import "FLogFileManager.h"
#import "FLogConsoleManager.h"
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
@property (strong, nonatomic)UIButton * banBtn;
@property (strong, nonatomic)UIButton * stickBtn;
@property (strong, nonatomic)UIButton * bottomBtn;

@property (strong, nonatomic)NSMutableArray<NSString *>* dataSource;
@end

@implementation FlogController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    [self loadDataSource];
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
    
    _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _logBtn.frame = CGRectMake(0, 0,w/2.0, 44);
    [_logBtn addTarget:self action:@selector(printBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_logBtn setImage:[UIImage imageNamed:@"print"] forState:UIControlStateNormal];
    [_logBtn setImage:[UIImage imageNamed:@"printSelect"] forState:UIControlStateSelected];
    UIBarButtonItem * logItem = [[UIBarButtonItem alloc] initWithCustomView:_logBtn];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(w/2.0, 0, w/2.0, 44);
    [_setBtn addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_setBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [_setBtn setImage:[UIImage imageNamed:@"settingSelect"] forState:UIControlStateSelected];
    UIBarButtonItem * setItem = [[UIBarButtonItem alloc] initWithCustomView:_setBtn];
    
    self.topBar.items = @[logItem,setItem];
    [self.view addSubview:self.topBar];
    
    _contentSc = [[UIScrollView alloc] initWithFrame:(CGRect){0,44,w,h-44}];
    _contentSc.pagingEnabled = YES;
    _contentSc.delegate = self;
    _contentSc.contentSize = CGSizeMake(w*2, h-44);
    [self.view addSubview:_contentSc];
    
    _logTV = [[UITextView alloc] initWithFrame:(CGRect){0,0,w,_contentSc.frame.size.height}];
    _logTV.text = @"日志打印：";
    _logTV.editable = NO;
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
    [FLogConsoleManager shareInstance].logDidChanged = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.iconBtn.isHidden) {
                [weakself readLog];
                [weakself.logTV scrollRangeToVisible:NSMakeRange(self.logTV.text.length, 1)];
            }
        });
    };
    
    _stickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stickBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _stickBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 300, 44, 44);
    [_stickBtn setImage:[UIImage imageNamed:@"stick"] forState:UIControlStateNormal];
    [_stickBtn addTarget:self action:@selector(stickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentSc addSubview:_stickBtn];
    _stickBtn.layer.cornerRadius = 22.0;
    _stickBtn.layer.masksToBounds = YES;
    
    _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _bottomBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 240, 44, 44);
    [_bottomBtn setImage:[UIImage imageNamed:@"bottom"] forState:UIControlStateNormal];
    [_bottomBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentSc addSubview:_bottomBtn];
    _bottomBtn.layer.cornerRadius = 22.0;
    _bottomBtn.layer.masksToBounds = YES;
    
    _banBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _banBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _banBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 180, 44, 44);
    [_banBtn setImage:[UIImage imageNamed:@"canU"] forState:UIControlStateNormal];
    [_banBtn addTarget:self action:@selector(banBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentSc addSubview:_banBtn];
    _banBtn.layer.cornerRadius = 22.0;
    _banBtn.layer.masksToBounds = YES;
    _ifAllowUseInterface = YES;
    
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _clearBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 120, 44, 44);
    [_clearBtn setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentSc addSubview:_clearBtn];
    _clearBtn.layer.cornerRadius = 22.0;
    _clearBtn.layer.masksToBounds = YES;
    
    
    _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _returnBtn.frame = (CGRect){w - 60, self.view.frame.size.height - 60, 44, 44};
    [_returnBtn setImage:[UIImage imageNamed:@"re-turn"] forState:UIControlStateNormal];
    [_returnBtn addTarget:self action:@selector(returnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_returnBtn];
    _returnBtn.layer.cornerRadius = 22.0;
    _returnBtn.layer.masksToBounds = YES;
    
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
    self.contentSc.contentSize = CGSizeMake(w*2, h-44);
    
    self.logTV.frame = (CGRect){0,0,w,_contentSc.frame.size.height};
    self.setTV.frame = (CGRect){w,0,w,_contentSc.frame.size.height};
    
    self.stickBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 300, 44, 44);
    self.bottomBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 240, 44, 44);
    self.banBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 180, 44, 44);
    self.clearBtn.frame = CGRectMake(w - 60, self.logTV.frame.size.height - 120, 44, 44);
    self.returnBtn.frame = (CGRect){w - 60, self.view.frame.size.height - 60, 44, 44};
}

- (void)loadDataSource {
    [self.dataSource removeAllObjects];
    //IP
    [self.dataSource addObject:[NSString stringWithFormat:@"IP: %@",[IPTool getIPAddress]]];
    
    //baseurl
    [self.dataSource addObject:@"BaseURL: https://fcf5646448.github.io/"];
    
    //cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:@"https://fcf5646448.github.io/"]];//得到cookie
    NSString*JSESSIONID=@"";
    for (NSHTTPCookie*cookie in cookies) {
        if ([cookie.name isEqualToString:@"JSESSIONID"]) {
            JSESSIONID=cookie.value;
        }
    }
    [self.dataSource addObject:[NSString stringWithFormat:@"cookie: %@",JSESSIONID]];
    
    //网络状态
    
    [self.setTV reloadData];
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    
    //移动中
    CGPoint p = [recognizer translationInView:self.iconBtn]; //在keywindow上的位置
    CGRect originF = self.originRect;
    if (originF.origin.x >= 0 || originF.origin.x + originF.size.width <= SCREEN_WIDTH ) {
        originF.origin.x += p.x;
    }
    if (originF.origin.y >= 0 || originF.origin.y + originF.size.height <= SCREENH_HEIGHT) {
        originF.origin.y += p.y;
    }
    
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
    sender.selected = YES;
    _setBtn.selected = NO;
    self.clearBtn.alpha = 1;
    self.contentSc.contentOffset = CGPointMake(0, 0);
}

- (void)setBtnAction:(UIButton *)sender {
    sender.selected = YES;
    _logBtn.selected = NO;
    self.clearBtn.alpha = 0;
    self.contentSc.contentOffset = CGPointMake(self.view.frame.size.width, 0);
}

- (void)returnBtnAction {
    if (self.callback) {
        self.callback(min);
    }
}

- (void)stickBtnAction:(UIButton *)sender {
    [self.logTV scrollRangeToVisible:NSMakeRange(0, 1)];
}

- (void)bottomBtnAction:(UIButton *)sender {
    [self.logTV scrollRangeToVisible:NSMakeRange(self.logTV.text.length, 1)];
}


- (void)banBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_banBtn setImage:[UIImage imageNamed:@"canU"] forState:UIControlStateNormal];
    }else{
        [_banBtn setImage:[UIImage imageNamed:@"banU"] forState:UIControlStateNormal];
    }
    self.ifAllowUseInterface = sender.selected;
}

//
- (void)iconBtnAction:(UIButton *)sender {
    if (self.callback) {
        self.callback(max);
    }
}

- (void)clearBtnAction:(UIButton *)sender {
    [[FLogConsoleManager shareInstance] clearLog];
    [self readLog];
}

//读取文件，并监听文件/文件夹的变化
- (void)readLog {
    NSMutableArray<NSString *> * logs = [NSMutableArray arrayWithArray:[[[FLogConsoleManager shareInstance] getLogs] copy]];
    NSMutableAttributedString * logStr = [[NSMutableAttributedString alloc] init];
    for (NSString * log in logs) {
        if (log.length <= 0) {
            continue;
        }
        NSArray * strArr = [log componentsSeparatedByString:@"\n"];
        if (strArr.count > 0) {
            NSString * firstStr = strArr[0];
            if ([firstStr hasPrefix:@"API"]) {
                [logStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstStr] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}]];
                [logStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[log substringFromIndex:firstStr.length]] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
            }else{
                [logStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",log] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
            }
        }else{
            [logStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",log] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        }
    }
    if (logStr != nil) {
        self.logTV.attributedText = logStr;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat w = self.view.frame.size.width;
    if (scrollView == self.contentSc) {
        
        CGFloat alpha = self.contentSc.contentOffset.x*1.0/w;
        self.clearBtn.alpha = alpha > 0 ? (1-alpha): 1;
        if (self.clearBtn.alpha == 1) {
            self.logBtn.selected = YES;
            self.setBtn.selected = NO;
        }else{
            self.logBtn.selected = NO;
            self.setBtn.selected = YES;
        }
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
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - 获取IP


@end
