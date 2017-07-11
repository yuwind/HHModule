//
//  HoverLinkageView.h
//  HoverLinkageView
//
//  Created by hxw on 2017/5/10.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHLinkageView.h"
#import "HHRefreshManager.h"


#define TOPVIEWH 200          //default headerView height
#define LINKAGEVIEWH 50      //default linkageView height
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHEIGHT [UIScreen mainScreen].bounds.size.height


/**
 给属性字典 "actionDict" 增加block数据

 @param dictM   对象的属性字典 "actionDict"
 @param key     定义在 "HHBlockActionKey" 中的常量字符串
 @param block   需要保存在属性字典 "actionDict" 中的block
 */
UIKIT_STATIC_INLINE void AddBlockAction(NSMutableDictionary *dictM, NSString *key, id block)
{
    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (dictM == nil || key == nil || block == nil)return;
    [dictM setObject:block forKey:key];
}


@protocol HHHoverLinkageViewDelegate <NSObject>

@optional

/**
 视图开始刷新时调用
 
 @param type 区分是头部刷新还是尾部刷新
 */
- (void)beginRefreshWithType:(RefreshType)type;

/**
 视图结束刷新时回调
 */
- (void)endRefreshAnimation;

@end


@interface HHHoverLinkageView : UIView

/**
 自定义的顶部视图
 @usage:  setter method
 */
@property (nonatomic, strong) UIView *headerView;

/**
 中间标题视图, 只需要设置属性 "titleArray" 即可, 数组类型只包含标题字符串, e&g:NSArray <NSString *> *titleArray。
 @usage:  self.linkageView = @[@"helloWorld"]
 */
@property (nonatomic, strong) HHLinkageView *linkageView;

@property (nonatomic, assign) BOOL isNeedHeaderViewZoom;//是否需要顶部视图缩放,默认YES
@property (nonatomic, assign) BOOL isNeedHeaderViewScroll;//是否需要顶部视图滚动,默认YES
@property (nonatomic, assign) BOOL isNeedCollectionViewScrollAnimation;//是否需要ollectionView滚动,默认YES
@property (nonatomic, weak)   id < HHHoverLinkageViewDelegate >delegate;

/**
 自定义的tableView, 需要继承 "HHBaseTableView" 获取回调数据,详见说明 "HHRefreshManager.h"
 */
@property (nonatomic, copy)   NSString *tableViewClassName;//需要注册的tableView类名

@property (nonatomic, strong) NSMutableDictionary *actionDict;//存储block,给子视图传递事件
@property (nonatomic, copy)   NSDictionary *dataDict;//需要传递给子视图tableView的字典
@property (nonatomic, copy)   NSArray *dataArray;//需要传递给子视图tableView的数组

@end
