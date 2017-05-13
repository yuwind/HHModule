//
//  HHBaseTableView.m
//  HoverLinkageViewDemo
//
//  Created by hxw on 2017/5/10.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHBaseTableView.h"
#import "HHCircleRefreshView.h"
#import "HHBaseFooterRefreshView.h"
#import "HHBaseHeaderRefreshView.h"

@interface HHBaseTableView ()< UITableViewDelegate, UITableViewDataSource, HHRefreshManagerDelegate >


@end

@implementation HHBaseTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        [self configBaseInfo];
        [self configInitialInfo];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configBaseInfo];
        [self configInitialInfo];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self configBaseInfo];
        [self configInitialInfo];
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        
        [self configBaseInfo];
        [self configInitialInfo];
    }
    return self;
}

- (void)configBaseInfo
{
    self.refreshManager = [HHRefreshManager refreshWithDelegate:self tableView:self];
    self.showsVerticalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    [self setRefreshType:((NSInteger)arc4random_uniform(3)+1)];
}
- (void)configInitialInfo{}

- (void)setRefreshType:(RefreshManagerType)refreshType
{
    _refreshType = refreshType;
    [self loadRefreshModel:refreshType];
}
- (void)loadRefreshModel:(RefreshManagerType)refreshType
{
    switch (refreshType) {
        case RefreshManagerTypeNone:
        {
            self.refreshManager.headerView = nil;
            self.refreshManager.footerView = nil;
        }
            break;
        case RefreshManagerTypeDefault:
        {
            HHBaseHeaderRefreshView *baseHeader = [[HHBaseHeaderRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
            HHBaseFooterRefreshView *baseFooter = [[HHBaseFooterRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
            self.refreshManager.headerView = baseHeader;
            self.refreshManager.footerView = baseFooter;
        }
            break;
        case RefreshManagerTypeCircle:
        {
            HHCircleRefreshView *circleHeaderView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
            circleHeaderView.isShowShadow = NO;
            self.refreshManager.headerView = circleHeaderView;
            
            HHCircleRefreshView *circleFooterView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
            circleFooterView.isFooter = YES;
            circleFooterView.isShowShadow = NO;
            self.refreshManager.footerView = circleFooterView;
        }
            break;
        case RefreshManagerTypeSemiCircle:
        {
            HHCircleRefreshView *semiHeaderView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
            semiHeaderView.animateType = AnimationTypeSemiCircle;
            semiHeaderView.isShowShadow = NO;
            semiHeaderView.coverColor = [UIColor redColor];
            semiHeaderView.animationTime = 1;
            self.refreshManager.headerView = semiHeaderView;
            
            HHCircleRefreshView *semiFooterView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
            semiFooterView.animateType = AnimationTypeSemiCircle;
            semiFooterView.isShowShadow = NO;
            semiFooterView.coverColor = [UIColor redColor];
            semiFooterView.animationTime = 1;
            semiFooterView.isFooter = YES;
            self.refreshManager.footerView = semiFooterView;
        }
            break;
        default:
            break;
    }
}
- (void)beginRefreshWithType:(RefreshType)type
{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshWithType:)]) {
        [self.refreshDelegate beginRefreshWithType:type];
    }
}
- (void)endRefreshAnimation
{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(endRefreshAnimation)]) {
        [self.refreshDelegate endRefreshAnimation];
    }
    [self.refreshManager endRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return 0;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{return nil;}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(hh_ScrollViewDidScroll:)]) {
        [_refreshDelegate hh_ScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(hh_ScrollViewDidEndDecelerating:)]) {
        [_refreshDelegate hh_ScrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(hh_ScrollViewDidEndDecelerating:)]) {
        [_refreshDelegate hh_ScrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(hh_ScrollViewWillBeginDragging:)]) {
        [_refreshDelegate hh_ScrollViewWillBeginDragging:scrollView];
    }
}

@end
