//
//  RetryAlertView.m
//  BaseConstruct
//
//  Created by hxw on 2017/4/14.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHRetryAlertView.h"
#import "UIView+HHConstruct.h"

#define titleColor [UIColor darkGrayColor]
#define descColor  [UIColor lightGrayColor]
#define titleFont  [UIFont boldSystemFontOfSize:16]
#define descFont   [UIFont systemFontOfSize:16]


@interface HHRetryAlertView ()

@property (nonatomic, assign) BOOL isAddObserver;
@property (nonatomic, weak)   UIView *hudSuperView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation HHRetryAlertView

+ (instancetype)retryView:(RetryViewInfo)retryViewInfo event:(retryEvent)event
{
    return [[self alloc] initWithRetryView:retryViewInfo event:event];
}

- (instancetype)initWithRetryView:(RetryViewInfo)retryViewInfo event:(retryEvent)event
{
    if (self = [super init]) {
        
        [self configRetryView:retryViewInfo event:event];
    }
    return self;
}

- (void)configRetryView:(RetryViewInfo)retryViewAtt event:(retryEvent)event
{
    self.event = event;
    self.retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.retryButton setBackgroundImage:[UIImage imageNamed:retryViewAtt.imageName] forState:UIControlStateNormal];
    [self.retryButton addTarget:self action:@selector(retryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.retryButton sizeToFit];
    [self addSubview:self.retryButton];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = retryViewAtt.titleText;
    self.titleLabel.textColor = titleColor;
    self.titleLabel.font = titleFont;
    [self addSubview:self.titleLabel];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.numberOfLines = 0;
    self.descLabel.text = retryViewAtt.descText;
    self.descLabel.textColor = descColor;
    self.descLabel.font = descFont;
    [self addSubview:self.descLabel];
    self.backgroundColor = [UIColor whiteColor];
}
- (void)retryButtonClick
{
    if (self.event) {
        self.event();
    }
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
    self.frame = _hudSuperView.bounds;
    self.retryButton.center = CGPointMake(self.width / 2, self.height / 2 -80);
    CGRect frame = self.titleLabel.frame;
    frame.size.width = self.width * 2 / 3;
    frame.origin.y = CGRectGetMaxY(self.retryButton.frame)+20;
    self.titleLabel.frame = frame;
    [self.titleLabel sizeToFit];
    CGPoint center = self.titleLabel.center;
    center.x  = self.width / 2;
    self.titleLabel.center = center;
    
    CGRect descFrame = self.descLabel.frame;
    descFrame.size.width = self.width * 2 / 3;
    descFrame.origin.y = CGRectGetMaxY(self.titleLabel.frame)+8;
    self.descLabel.frame = descFrame;
    [self.descLabel sizeToFit];
    CGPoint descCenter = self.descLabel.center;
    descCenter.x  = self.width / 2;
    self.descLabel.center = descCenter;
}

- (void)dealloc
{
    [_hudSuperView removeObserver:self forKeyPath:@"frame"];
    [_hudSuperView removeObserver:self forKeyPath:@"bounds"];
}

@end
