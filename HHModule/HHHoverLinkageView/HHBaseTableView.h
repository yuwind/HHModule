//
//  HHBaseTableView.h
//  HoverLinkageViewDemo
//
//  Created by hxw on 2017/5/10.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHRefreshManager.h"

typedef NS_ENUM(NSUInteger, RefreshManagerType) {
    RefreshManagerTypeNone = 0,
    RefreshManagerTypeDefault,
    RefreshManagerTypeCircle,
    RefreshManagerTypeSemiCircle,
};

@protocol HHBaseTableViewDelegate <NSObject>

@optional
- (void)beginRefreshWithType:(RefreshType)type;
- (void)endRefreshAnimation;

- (void)hh_ScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)hh_ScrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)hh_ScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface HHBaseTableView : UITableView

@property (nonatomic, assign) RefreshManagerType refreshType;//子类重写 "setter" 方法设置刷新样式,基类有三种, 优先级低于 "loadRefreshModel:(RefreshManagerType)refreshType"
@property (nonatomic, strong) NSMutableDictionary *actionDict;//存储 block 事件的字典
@property (nonatomic, strong) HHRefreshManager * refreshManager;//刷新控件管理类
@property (nonatomic, weak) id <HHBaseTableViewDelegate> refreshDelegate;
@property (nonatomic, copy)   NSDictionary *dataDict;//子类重写 "setter" 获得数据
@property (nonatomic, copy)   NSArray *dataArray;//子类重写 "setter" 获得数据
@property (nonatomic, strong) NSIndexPath *indexPath;//子类重写"setter" 获得索引

- (void)configInitialInfo;//子类重写作为初始化入口
- (void)loadRefreshModel:(RefreshManagerType)refreshType;//重写此方法覆盖刷新控件，由用户自定义

- (void)beginRefreshWithType:(RefreshType)type; //子类重写接收开始刷新事件，需要调用父类的方法
- (void)endRefreshAnimation;//子类直接调用结束刷新

@end
