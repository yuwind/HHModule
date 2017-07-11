//
//  UIView+Construct.m
//  BaseConstruct
//
//  Created by hxw on 2017/4/13.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "UIView+HHConstruct.h"
#import <objc/runtime.h>

static char * const panGestureKey           = "panGestureKey";
static char * const lockGestureKey          = "lockGestureKey";
static char * const beginPointKey           = "beginPointKey";
static char * const tempPointKey            = "tempPointKey";
static char * const panDirectionKey         = "panDirectionKey";
static char * const gestureDirectionKey     = "gestureDirectionKey";
static char * const horizontalDirectionKey  = "horizontalDirectionKey";
static char * const panResponseDelegateKey  = "panResponseDelegateKey";

@interface UIView ()

@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGPoint tempPoint;
@property (nonatomic, assign) BOOL panDirection;
@property (nonatomic, assign) LCPanGestureDirection gestureDirection;
@property (nonatomic, assign) BOOL horizontalDirection;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation UIView (HHConstruct)


- (void)addBottomLine:(UIColor *)lineColor
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, self.height-1, self.width, .5);
    layer.backgroundColor = lineColor ? lineColor.CGColor : [UIColor darkTextColor].CGColor;
    [self.layer addSublayer:layer];
}
- (void)addTopLine:(UIColor *)lineColor
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.width, .5);
    layer.backgroundColor = lineColor ? lineColor.CGColor : [UIColor darkTextColor].CGColor;
    [self.layer addSublayer:layer];
}

- (void)setPanGesture:(UIPanGestureRecognizer *)panGesture
{
     objc_setAssociatedObject(self, panGestureKey,panGesture,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIPanGestureRecognizer *)panGesture
{
    return objc_getAssociatedObject(self, panGestureKey);
}
- (void)setPanResponseDelegate:(id)panResponseDelegate
{
     objc_setAssociatedObject(self, panResponseDelegateKey,panResponseDelegate,OBJC_ASSOCIATION_ASSIGN);
}
- (id)panResponseDelegate
{
    return objc_getAssociatedObject(self, panResponseDelegateKey);
}
- (void)setLockGesture:(BOOL)lockGesture
{
    objc_setAssociatedObject(self, lockGestureKey, [NSNumber numberWithBool:lockGesture],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)lockGesture
{
    NSNumber *enableLockGestureNumber = objc_getAssociatedObject(self, lockGestureKey);
    return [enableLockGestureNumber boolValue];
}
- (void)setBeginPoint:(CGPoint)beginPoint
{
    objc_setAssociatedObject(self, beginPointKey, [NSValue valueWithCGPoint:beginPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGPoint)beginPoint
{
    NSValue *beginValue = objc_getAssociatedObject(self, beginPointKey);
    return beginValue.CGPointValue;
}
- (void)setTempPoint:(CGPoint)tempPoint
{
    objc_setAssociatedObject(self, tempPointKey, [NSValue valueWithCGPoint:tempPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGPoint)tempPoint
{
    NSValue *tempValue = objc_getAssociatedObject(self, tempPointKey);
    return tempValue.CGPointValue;
}
- (void)setPanDirection:(BOOL)panDirection
{
     objc_setAssociatedObject(self, panDirectionKey, [NSNumber numberWithBool:panDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)panDirection
{
    NSNumber *panNumber = objc_getAssociatedObject(self, panDirectionKey);
    return panNumber.boolValue;
}
- (void)setGestureDirection:(LCPanGestureDirection)gestureDirection
{
    objc_setAssociatedObject(self, gestureDirectionKey, [NSNumber numberWithInteger:gestureDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LCPanGestureDirection)gestureDirection
{
    NSNumber *gesNumber = objc_getAssociatedObject(self, gestureDirectionKey);
    return gesNumber.integerValue;
}
- (void)setHorizontalDirection:(BOOL)horizontalDirection
{
    objc_setAssociatedObject(self, horizontalDirectionKey, [NSNumber numberWithBool:horizontalDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)horizontalDirection
{
    NSNumber *horizonNumber = objc_getAssociatedObject(self, horizontalDirectionKey);
    return horizonNumber.boolValue;
}
- (void)addPanGesture
{
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:self.panGesture];
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (self.lockGesture)return;
    if (!self.panResponseDelegate)
    self.panResponseDelegate = (UIViewController <UIGestureViewDelegate>*)[self viewController];
    
    CGPoint translation = [gesture translationInView:self];
    CGPoint velocity = [gesture velocityInView:self];

    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        self.beginPoint = [gesture locationInView:self];
        
        if (self.panResponseDelegate && [self.panResponseDelegate respondsToSelector:@selector(gestureView:startGestureLocation:)])
        {
            [self.panResponseDelegate gestureView:self startGestureLocation:self.beginPoint];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newerPoint = [gesture locationInView:self];
        if (!self.panDirection)
        {
            if (fabs(velocity.x) > fabs(velocity.y))
            {
                self.horizontalDirection = YES;
            }else
            {
                self.gestureDirection = self.beginPoint.x >= [UIScreen mainScreen].bounds.size.width / 2 ? LCPanGestureDirectionRight : LCPanGestureDirectionLeft;
            }
            self.panDirection = YES;
        }
        if (self.horizontalDirection) {
            self.gestureDirection = newerPoint.x > self.tempPoint.x ? LCPanGestureDirectionHorizontalRight : LCPanGestureDirectionHorizontalLeft;
        }
        float speed = 0;
        self.tempPoint = newerPoint;
        switch (self.gestureDirection) {
                
            case LCPanGestureDirectionLeft:
                speed = -translation.y * 2 / [UIScreen mainScreen].bounds.size.height;
                break;
                
            case LCPanGestureDirectionRight:
                speed = -translation.y * 2 / [UIScreen mainScreen].bounds.size.height;
                break;
                
            case LCPanGestureDirectionHorizontalLeft:
                speed = translation.x / [UIScreen mainScreen].bounds.size.width;
                break;
            case LCPanGestureDirectionHorizontalRight:
                speed = translation.x / [UIScreen mainScreen].bounds.size.width;
                break;
                
            default:
                break;
        }
        if (self.panResponseDelegate && [self.panResponseDelegate respondsToSelector:@selector(gestureView:recognizerStateChanged:rate:translation:velocity:)])
        {
            [self.panResponseDelegate gestureView:self recognizerStateChanged:self.gestureDirection rate:speed translation:translation velocity:velocity];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        self.panDirection = NO;
        self.horizontalDirection = NO;
        self.tempPoint = CGPointZero;
        if (self.panResponseDelegate && [self.panResponseDelegate respondsToSelector:@selector(gestureView:didEndGestureDirection:)])
        {
            [self.panResponseDelegate gestureView:self didEndGestureDirection:self.gestureDirection];
        }
    }
}

- (UIViewController<UIGestureViewDelegate> *)viewController
{
    if ([[self nextResponder] isKindOfClass:[UIViewController class]] && [[self nextResponder] conformsToProtocol:@protocol(UIGestureViewDelegate)]) {
        return (UIViewController<UIGestureViewDelegate> *)[self nextResponder];
    }
    if (![self superview]) return nil;
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]] && [nextResponder conformsToProtocol:@protocol(UIGestureViewDelegate)])
        {
            return (UIViewController<UIGestureViewDelegate> *)nextResponder;
        }
    }
    return nil;
}

- (void)removePanGesture
{
    if (self.panGesture) {
        [self removeGestureRecognizer:self.panGesture];
    }
}
/********-----------------------------------------***********/
#pragma mark -坐标层
/********-----------------------------------------***********/

- (void)setX:(CGFloat)x
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = y;
    self.frame = tempFrame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setWidth:(CGFloat)width
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin
{
    return self.frame.origin;
}
- (void)setMaxX:(CGFloat)maxX
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = maxX - self.width;
    self.frame = tempFrame;
}

- (CGFloat)maxX
{
    return self.x+self.width;
}

- (void)setMaxY:(CGFloat)maxY
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = maxY - self.height;
    self.frame = tempFrame;
}
- (CGFloat)maxY
{
    return self.y+self.height;
}
- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint centerPoint = self.center;
    centerPoint.x = centerX;
    self.center = centerPoint;
}
-(CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint centerPoint = self.center;
    centerPoint.y = centerY;
    self.center = centerPoint;
}

@end
