//
//  RefreshManager.m
//  RefreshManager
//
//  Created by hxw on 16/11/11.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "HHRefreshManager.h"
#import "HHBaseHeaderRefreshView.h"
#import "HHBaseFooterRefreshView.h"
#import "UIView+HHConstruct.h"
#import "HHCircleRefreshView.h"

#define REFRESHHEIGHT -60
#define TOLERANT 6

@interface HHRefreshManager ()

@property (nonatomic, weak) id<HHRefreshManagerDelegate>delegate;
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, assign) BOOL isHeader;

@end

@implementation HHRefreshManager
{
    BOOL isRefresh;
    CGFloat offsetY;
}

- (HHBaseRefreshView *)configHeaderView
{
    if (!_headerView) {
        _headerView = [[HHBaseHeaderRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, abs(REFRESHHEIGHT))];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (HHBaseRefreshView *)configFooterView
{
    if (!_footerView) {
        _footerView = [[HHBaseFooterRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, abs(REFRESHHEIGHT))];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}

+ (instancetype)refreshWithDelegate:(id<HHRefreshManagerDelegate>)delegate tableView:(UITableView *)tableView
{
    HHRefreshManager *refresh = [[HHRefreshManager alloc]init];
    [refresh addNotification:tableView];
    [refresh setDelegate:delegate];
    [refresh setTableView:tableView];
    [refresh addRefreshSubViews];
    [refresh configBaseInfo];
    
    return refresh;
}

- (void)addNotification:(UITableView *)tableView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)applicationWillEnterForeground:(NSNotification *)notify
{
    if (isRefresh)
    {
        if (_isHeader)
        {
            if (![_headerView isMemberOfClass:[HHCircleRefreshView class]])return;
            [_headerView beginRefresh];
        }else
        {
            if (![_footerView isMemberOfClass:[HHCircleRefreshView class]])return;
            [_footerView beginRefresh];
        }
    }
}

- (void)applicationWillResignActive:(NSNotification *)notify
{
    if (isRefresh) {
        if (_isHeader)
        {
            if (![_headerView isMemberOfClass:[HHCircleRefreshView class]])return;
            [_headerView endRefresh];
        }else
        {
            if (![_footerView isMemberOfClass:[HHCircleRefreshView class]])return;
            [_footerView endRefresh];
        }
    }
}
- (void)configBaseInfo
{
    _gradualAlpha = YES;
    _isNeedRefresh = YES;
    _isNeedFootRefresh = YES;
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, REFRESHHEIGHT, 0)];
}

- (void)addRefreshSubViews
{
    [self configHeaderView];
    [self configFooterView];
    self.tableView.tableFooterView = self.footerView;
    [self.tableView addSubview:self.headerView];
    self.headerView.width = self.tableView.width;
    self.headerView.maxY = 0;
    self.headerView.x = 0;
}

- (void)setHeaderView:(HHBaseRefreshView *)headerView
{
    if (_headerView)[_headerView removeFromSuperview];
    _headerView = headerView;
    if (!headerView) return;
    [self.tableView addSubview:self.headerView];
    self.headerView.width = self.tableView.width;
    self.headerView.maxY = 0;
    self.headerView.x = 0;
}

- (void)setFooterView:(HHBaseRefreshView *)footerView
{
    if (_footerView)[_footerView removeFromSuperview];
    _footerView = footerView;
    if (!footerView) return;
    self.tableView.tableFooterView = footerView;
}
- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
}
- (void)setDelegate:(id<HHRefreshManagerDelegate>)delegate
{
    _delegate = delegate;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (!_isNeedRefresh)return;
    self.headerView.width = self.tableView.width;
    if (isRefresh) return;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        offsetY = _tableView.contentOffset.y;
        
        if (_tableView.frame.size.height>_tableView.contentSize.height+REFRESHHEIGHT)
        {
            _tableView.tableFooterView.hidden = YES;
            if (!_isNeedFootRefresh)return;
            if (!_footerView)return;
            if (offsetY > abs(REFRESHHEIGHT) && !_tableView.isDragging) {
                [_footerView beginRefresh];
                _isHeader = NO;
                isRefresh = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    [_tableView setContentInset:UIEdgeInsetsZero];
                }];
                if (_delegate && [_delegate respondsToSelector:@selector(beginRefreshWithType:)]) {
                    [_delegate beginRefreshWithType:RefreshTypeFooter];
                }
            }
        }else
        {
            _tableView.tableFooterView.hidden = NO;
            if (!_isNeedFootRefresh)return;
            if (!_footerView)return;
            if (offsetY+_tableView.frame.size.height>_tableView.contentSize.height+REFRESHHEIGHT && offsetY+_tableView.frame.size.height<_tableView.contentSize.height) {
                
                [_footerView normalRefresh:1-(CGFloat)fabs(_tableView.contentSize.height-offsetY-_tableView.frame.size.height)/abs(REFRESHHEIGHT)];
            }
            if (offsetY+_tableView.frame.size.height>_tableView.contentSize.height && _tableView.isDragging) {
                [_footerView readyRefresh];
            }
            if (offsetY+_tableView.frame.size.height>_tableView.contentSize.height-TOLERANT && !_tableView.isDragging) {
                [_footerView beginRefresh];
                _isHeader = NO;
                isRefresh = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    [_tableView setContentInset:UIEdgeInsetsZero];
                }];
                if (_delegate && [_delegate respondsToSelector:@selector(beginRefreshWithType:)]) {
                    [_delegate beginRefreshWithType:RefreshTypeFooter];
                }
            }
        }
        if (!_headerView)return;
        if (offsetY > REFRESHHEIGHT && offsetY < 0) {
            
            [_headerView normalRefresh:fabs(offsetY)/abs(REFRESHHEIGHT)];
            if (_gradualAlpha) {
                
                _headerView.alpha = fabs(offsetY)/abs(REFRESHHEIGHT);
            }
        }
        if (offsetY < REFRESHHEIGHT && _tableView.isDragging) {
            
            _headerView.alpha = 1.0f;
            [_headerView readyRefresh];
        }
        if (offsetY < REFRESHHEIGHT+TOLERANT && !_tableView.isDragging) {
            
            [_headerView beginRefresh];
            isRefresh = YES;
            _isHeader = YES;
            [UIView animateWithDuration:0.2 animations:^{
                [_tableView setContentInset:UIEdgeInsetsMake(abs(REFRESHHEIGHT), 0, REFRESHHEIGHT, 0)];
            }];
            if (_delegate && [_delegate respondsToSelector:@selector(beginRefreshWithType:)]) {
                [_delegate beginRefreshWithType:RefreshTypeHeader];
            }
        }
    }
}

- (void)endRefresh
{
    [_headerView endRefresh];
    [_footerView endRefresh];
    isRefresh = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, REFRESHHEIGHT, 0)];
        
    }];
}

- (void)dealloc
{
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
