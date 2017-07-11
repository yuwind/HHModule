//
//  CommonHeaderView.h
//  RefreshManager
//
//  Created by hxw on 2017/3/30.
//  Copyright © 2017年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHBaseRefreshView : UIView


/**
 需要子类重写

 @param rate 比率eg.[0 1]
 */
- (void)normalRefresh:(CGFloat)rate;

- (void)readyRefresh;

- (void)beginRefresh;

- (void)endRefresh;


@end
