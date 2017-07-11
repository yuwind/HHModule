//
//  UIViewController+Construct.h
//  BaseConstruct
//
//  Created by hxw on 2017/4/13.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, WaitHudMode) {
    WaitHudModeActivity = 0,
    WaitHudModeActivityDescrible,
    WaitHudModeCircle,
    WaitHudModeCircleDescrible,
    WaitHudModeTrackcircle,
    WaitHudModeTrackcircleDescrible,
    WaitHudModeGraduleScale,
    WaitHudModeGraduleScaleDescrible,
};


typedef struct RetryViewAttributes {
    __unsafe_unretained  NSString *imageName;
    __unsafe_unretained  NSString *titleText;
    __unsafe_unretained  NSString *descText;
    CGFloat fontSize;
} RetryViewInfo;

UIKIT_STATIC_INLINE RetryViewInfo retryViewInfoMake(NSString *imageName,NSString *titleText, NSString *descText)
{
    RetryViewInfo retryViewInfo = {imageName, titleText, descText};
    return retryViewInfo;
}

typedef void(^retryEvent)();



@interface UIViewController (HHConstruct)

/**
 修改默认Hud样式

 @usage 在方法: didFinishLaunchingWithOptions 中调用 
 [UIViewController registerWaitHudMode:WaitHudModeTrackcircle];
 
 @param mode 选择使用刷新控件样式
 */
+ (void)registerWaitHudMode:(WaitHudMode)mode;

/**
 展示WaitHud, 可加载在指定视图上, 默认在视图的中间, 可设置offset修改上下偏移量, 向下为正
 */
- (void)showWaitHud;//默认样式:WaitHudModeActivity
- (void)showWaitHud:(WaitHudMode)mode;
- (void)showWaitHudInView:(UIView *)view;
- (void)showWaitHudInView:(UIView *)view mode:(WaitHudMode)mode;

- (void)showWaitHudOffset:(CGFloat)offset;
- (void)showWaitHud:(WaitHudMode)mode Offset:(CGFloat)offset;
- (void)showWaitHudInView:(UIView *)view Offset:(CGFloat)offset;
- (void)showWaitHudInView:(UIView *)view mode:(WaitHudMode)mode Offset:(CGFloat)offset;

- (void)hideWaitHud;

/**
 展示text,自适应宽高, 可加载在指定视图上, 默认在视图的中间, 可设置offset修改上下偏移量, 向下为正

 @param text 默认1秒后自动消失
 */
- (void)showText:(NSString *)text;
- (void)showText:(NSString *)text interval:(NSTimeInterval)interval;
- (void)showText:(NSString *)text inview:(UIView *)view;
- (void)showText:(NSString *)text inview:(UIView *)view interval:(NSTimeInterval)interval;

- (void)showText:(NSString *)text Offset:(CGFloat)offset;
- (void)showText:(NSString *)text inview:(UIView *)view Offset:(CGFloat)offset;
- (void)showText:(NSString *)text interval:(NSTimeInterval)interval Offset:(CGFloat)offset;
- (void)showText:(NSString *)text inview:(UIView *)view interval:(NSTimeInterval)interval Offset:(CGFloat)offset;

- (void)hideText;

/**
 展示错误页面, 包含一个图片、一个标题、一个描述, 可加载在指定视图上, 默认在视图的中间
 
 @param retryViewInfo 内联函数创建结构体存储数据 使用如下
 @usage retryViewInfoMake(<#NSString *imageName#>, <#NSString *titleText#>, <#NSString *descText#>)
 @param block 按钮点击事件
 */
- (void)showRetryView:(RetryViewInfo)retryViewInfo buttonClick:(retryEvent)block;
- (void)showRetryView:(RetryViewInfo)retryViewInfo below:(UIView *)view buttonClick:(retryEvent)block;
- (void)showRetryView:(RetryViewInfo)retryViewInfo above:(UIView *)view buttonClick:(retryEvent)block;
- (void)hideRetryView;

/**
 AlertController,取消事件不做任何操作
 */
- (void)showAlertController:(NSString *)title
                    message:(NSString *)message
                cancelTitle:(NSString *)cancelTitle
                 otherTitle:(NSString *)otherTitle
                otherAction:(void (^ __nullable)(UIAlertAction *action))handler NS_AVAILABLE_IOS(8);

@end
