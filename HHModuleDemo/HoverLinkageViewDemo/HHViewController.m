//
//  ViewController.m
//  HoverLinkageViewDemo
//
//  Created by hxw on 2017/5/10.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHViewController.h"
#import "HHHoverLinkageView.h"
#import "UIViewController+HHConstruct.h"
#import "HHBlockActionKey.h"
#import "HHHoverTableView.h"

@interface HHViewController ()< HHHoverLinkageViewDelegate >

@property (nonatomic, strong) HHHoverLinkageView *hoverView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation HHViewController

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"新闻头条0",@"国际要闻1",@"体育2",@"中国足球3",@"汽车4",@"囧途旅游5",@"幽默搞笑6",@"视频7",@"无厘头8",@"今日房价9", nil];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _hoverView= [[HHHoverLinkageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _hoverView.delegate = self;
    _hoverView.linkageView.titleArray = self.titleArray;
    _hoverView.tableViewClassName = NSStringFromClass([HHHoverTableView class]);
    _hoverView.dataArray = self.titleArray;
    [self.view addSubview:_hoverView];

    [self addBlockActionEvents];
}

- (void)addBlockActionEvents
{
     __weak __typeof(self)wSelf = self;
    AddBlockAction(_hoverView.actionDict, HeaderViewButtonClick, ^(NSString *text){
        
        [wSelf showText:text];
    });
    AddBlockAction(_hoverView.actionDict, TableViewCellButtonClick, ^(NSString *text){
        
        [wSelf showText:text];
    });
}

- (void)beginRefreshWithType:(RefreshType)type
{
    NSInteger index = arc4random_uniform(8);
    if (type == RefreshTypeHeader) {
        
        [self showWaitHud:index Offset:100];
    }else
    {
        [self showWaitHud:index];
    }
}
- (void)endRefreshAnimation
{
    [self hideWaitHud];
}

@end
