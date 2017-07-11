//
//  TextAlertView.m
//  BaseConstruct
//
//  Created by hxw on 2017/4/14.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHTextAlertView.h"
#import "UIView+HHConstruct.h"


#define ALERTFONT 17
#define ALERTTIME 0.5
#define ALERTMARGIN 15
#define SWIDTH [UIScreen mainScreen].bounds.size.width


@interface HHTextAlertView ()

@property (nonatomic, assign) BOOL isAddObserver;
@property (nonatomic, weak)   UIView *hudSuperView;
@property (nonatomic, strong) UILabel *alert;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, assign) CGFloat offset;

@end

@implementation HHTextAlertView

+ (instancetype)textAlert:(NSString *)text interval:(NSTimeInterval)interval offset:(CGFloat)offset
{
    return [[self alloc] initWithText:text interval:(NSTimeInterval)interval offset:offset];
}
- (instancetype)initWithText:(NSString *)text interval:(NSTimeInterval)interval offset:(CGFloat)offset
{
    if (self = [super init]) {
        
        self.offset = offset;
        [self configBaseInfo:text interval:interval];
    }
    return self;
}

- (void)configBaseInfo:(NSString *)text interval:(NSTimeInterval)interval
{
    self.text = text;
    self.interval = interval;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:ALERTFONT]}];
    int labelLine = (int)(size.width / (SWIDTH * 2 / 3)) + 1;
    if (size.width > SWIDTH * 2 / 3) {
        size.width = SWIDTH * 2 / 3;
        size.height *= labelLine;
    }
    self.alpha = 0;
    self.layer.zPosition = 3.0f;
    self.frame = CGRectMake(0, 0, size.width + 2 * ALERTMARGIN, size.height + 2 * ALERTMARGIN);
    [self drawCornerRadius];
    self.alert = [[UILabel alloc] init];
    _alert.text = text;
    _alert.numberOfLines = labelLine;
    _alert.font = [UIFont boldSystemFontOfSize:ALERTFONT];
    _alert.textColor = [UIColor whiteColor];
    _alert.textAlignment = NSTextAlignmentCenter;
    
    _alert.frame = CGRectMake(ALERTMARGIN,ALERTMARGIN, size.width, size.height);
    [self addSubview:_alert];
    __weak __typeof(self)wSelf = self;
    [UIView animateWithDuration:ALERTTIME animations:^{
        self.alpha = 1;
    }completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:ALERTTIME animations:^{
                wSelf.alpha = 0;
            }completion:^(BOOL finished) {
                if (wSelf.removeText) {
                    wSelf.removeText();
                }
            }];
        });
    }];
}
- (void)drawCornerRadius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,  [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor);
    CGContextFillPath(context);
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8].CGPath);
    CGContextDrawPath(context, kCGPathFill);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!self.isAddObserver) {
        
        _hudSuperView = newSuperview;
        [self addFrameObserver];
        self.isAddObserver = YES;
    }
}

- (void)addFrameObserver
{
    [_hudSuperView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    [_hudSuperView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:ALERTFONT]}];
    int labelLine = (int)(size.width / (SWIDTH * 2 / 3)) + 1;
    if (size.width > SWIDTH * 2 / 3) {
        size.width = SWIDTH * 2 / 3;
        size.height *= labelLine;
    }
    self.frame = CGRectMake(0, 0, size.width + 2 * ALERTMARGIN, size.height + 2 * ALERTMARGIN);
    _alert.numberOfLines = labelLine;
    _alert.frame = CGRectMake(ALERTMARGIN,ALERTMARGIN, size.width, size.height);
    self.center = CGPointMake(_hudSuperView.width/2, _hudSuperView.height/2+self.offset);
}

- (void)dealloc
{
    [_hudSuperView removeObserver:self forKeyPath:@"frame"];
    [_hudSuperView removeObserver:self forKeyPath:@"bounds"];
}

@end
