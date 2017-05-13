//
//  UIView+Construct.h
//  BaseConstruct
//
//  Created by hxw on 2017/4/13.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCPanGestureDirection) {
    LCPanGestureDirectionNone = 0,
    LCPanGestureDirectionLeft = 1,
    LCPanGestureDirectionRight = 2,
    LCPanGestureDirectionHorizontalLeft = 3,
    LCPanGestureDirectionHorizontalRight = 4,
};

@protocol UIGestureViewDelegate <NSObject>

@optional

- (void)gestureView:(UIView *)view startGestureLocation:(CGPoint)point;
- (void)gestureView:(UIView *)view recognizerStateChanged:(LCPanGestureDirection)direction rate:(CGFloat)rate translation:(CGPoint)translation velocity:(CGPoint)velocity;
- (void)gestureView:(UIView *)view didEndGestureDirection:(LCPanGestureDirection)direction;

@end

@interface UIView (HHConstruct)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) BOOL    lockGesture; //默认是NO
@property (nonatomic, weak) id panResponseDelegate;

/**
 增加手势
 */
- (void)addPanGesture;

/**
 移除手势
 */
- (void)removePanGesture;

/**
 增加底部分割线

 @param lineColor 线的颜色
 */
- (void)addBottomLine:(UIColor *)lineColor;

/**
 增加顶部分割线

 @param lineColor 线的颜色
 */
- (void)addTopLine:(UIColor *)lineColor;

@end
