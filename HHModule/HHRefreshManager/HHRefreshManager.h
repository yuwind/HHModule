//
//  RefreshManager.h
//  RefreshManager
//
//  Created by hxw on 16/11/11.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHBaseRefreshView.h"


typedef enum : NSUInteger {
    RefreshTypeNone = 0,
    RefreshTypeFooter,
    RefreshTypeHeader,
} RefreshType;

@protocol HHRefreshManagerDelegate <NSObject>

- (void)beginRefreshWithType:(RefreshType)type;

@end

@interface HHRefreshManager : NSObject

/**
 刷新控件视图, 若自定义需继承于 "HHBaseRefreshView", 重写父类的方法接收状态即可
 @usage:    self.headerView = "circleHeader";
 */
@property (nonatomic, strong) HHBaseRefreshView *headerView;
@property (nonatomic, strong) HHBaseRefreshView *footerView;

@property (nonatomic, assign) BOOL gradualAlpha;//头部是否渐变
@property (nonatomic, assign) BOOL isNeedRefresh;//是否需要刷新, NO不会回调事件
@property (nonatomic, assign) BOOL isNeedFootRefresh;//是否需要尾部刷新, NO不会回调尾部刷新事件

/**
 实例化方法, 内部KVO监听tableView的contentOffset

 @param delegate 代理对象
 @param tableView 需要监听的对象
 @return 当前类的实例
 */
+ (instancetype)refreshWithDelegate:(id<HHRefreshManagerDelegate>)delegate tableView:(UITableView *)tableView;

/**
 结束刷新
 */
- (void)endRefresh;

@end
