//
//  LECLinkageView.h
//  LECLinkageView
//
//  Created by hxw on 16/10/23.
//  Copyright © 2016年 HXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+HHConstruct.h"

@class HHLinkageView;
@protocol HHLinkageViewDelegate <NSObject>

@optional
- (void)linkageView:(HHLinkageView *)view index:(NSInteger)index;
- (void)actionButtonClickEvent:(HHLinkageView *)view;

@end

@interface HHLinkageView : UIView

@property (nonatomic, strong) NSArray <NSString *>*titleArray;//标题数组
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) BOOL isShowIndicator;
@property (nonatomic, weak)   id<HHLinkageViewDelegate>delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy)   void (^callBack)();

/**
 内部通过KVO监听scrollView的滚动, 改变indicator的位置

 @param scrollView 需要监听的对象
 */
- (void)adjustTitleAndLine:(UIScrollView *)scrollView;

@end
