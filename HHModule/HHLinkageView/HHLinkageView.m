//
//  LECLinkageView.m
//  LECLinkageView
//
//  Created by hxw on 16/10/23.
//  Copyright © 2016年 HXW. All rights reserved.
//

#import "HHLinkageView.h"

#define kTopTabScrollButtonTag 19291
@interface HHLinkageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttonList;
@property (nonatomic, strong) UIButton * tempButton;
@property (nonatomic, strong) UIView *scrollLineView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIScrollView *observerScrollView;
@property (nonatomic, assign) BOOL isShowActionButton;

@end

@implementation HHLinkageView
{
    NSInteger _nextIndex;
    NSInteger _tempIndex;
    CGFloat   _beginOffSetX;
    BOOL      _clickTopButton;
}
- (NSMutableArray *)buttonList
{
    if (!_buttonList) {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

- (UIButton *)actionButton
{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.size = CGSizeMake(self.height, self.height);
        [_actionButton setBackgroundColor:[UIColor yellowColor]];
        _actionButton.centerY = self.height/2;
        _actionButton.maxX = self.maxX;
        _actionButton.hidden = YES;
        [_actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.actionButton];
        [self bringSubviewToFront:_actionButton];
    }
    return _actionButton;
}
- (void)actionButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(actionButtonClickEvent:)]) {
        [self.delegate actionButtonClickEvent:self];
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollsToTop = NO;
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return _scrollView;
}
-(UIView *)scrollLineView
{
    if (!_scrollLineView) {
        _scrollLineView = [[UIView alloc]init];
        _scrollLineView.backgroundColor = _selectedColor?_selectedColor:[UIColor redColor];
    }
    return _scrollLineView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.scrollView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.scrollView];
    }
    return self;
}
- (void)layoutSubviews
{
    self.scrollView.frame = self.bounds;
}
- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [self configScrollViewTitle:_titleArray];
    if (self.callBack)self.callBack();
}
- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    if (self.buttonList.count) {
        for (UIButton *btn in self.buttonList) {
            [btn setTitleColor:normalColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    self.scrollLineView.backgroundColor = selectedColor;
    if (self.selectedButton) {
        [self.selectedButton setTitleColor:selectedColor forState:UIControlStateNormal];
    }
}
- (void)setIsShowIndicator:(BOOL)isShowIndicator
{
    _isShowIndicator = isShowIndicator;
    self.scrollLineView.hidden = !isShowIndicator;
}
- (void)setIsShowActionButton:(BOOL)isShowActionButton
{
    _isShowActionButton = isShowActionButton;
    self.actionButton.hidden = !isShowActionButton;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.scrollView.backgroundColor = backgroundColor;
}

- (void)configScrollViewTitle:(NSArray *)titleArray
{
    self.tempButton = nil;
    if (_buttonList.count)
    {
        [_buttonList removeAllObjects];
    }
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.contentSize = self.frame.size;
    for (int i = 0; i < titleArray.count; i++) {
        
        NSDictionary * fontDict = @{
                                    NSFontAttributeName : [UIFont systemFontOfSize:14]
                                    };
        CGFloat buttonW = [titleArray[i] sizeWithAttributes:fontDict].width;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font     = [UIFont systemFontOfSize:14];
        btn.tag                 = kTopTabScrollButtonTag + i;
        
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_normalColor?_normalColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickTopBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame = CGRectMake(10 + CGRectGetMaxX(self.tempButton.frame), 2.5, buttonW + 10, 30);
        btn.centerY = self.height/2+5;
        if (i == 0) {
            
            self.scrollLineView.frame = CGRectMake(btn.frame.origin.x+5, CGRectGetMaxY(btn.frame), btn.frame.size.width-10, 2);
            [self.scrollView addSubview:_scrollLineView];
            self.selectedButton = btn;
            [btn setTitleColor:_selectedColor?_selectedColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        if (i == titleArray.count - 1)
        {
            self.scrollView.contentSize = CGSizeMake(10 + CGRectGetMaxX(btn.frame), self.frame.size.height);
        }
        self.tempButton = btn;
        [self.scrollView addSubview:btn];
        [self.buttonList addObject:btn];
    }
}

- (void)clickTopBarButton:(UIButton *)button
{
    if ([self.selectedButton isEqual:button]) return;
    _clickTopButton = YES;
    _scrollView.userInteractionEnabled = NO;

    [UIView animateWithDuration:0.3 animations:^{
        
        self.scrollLineView.frame = CGRectMake(button.frame.origin.x+5, CGRectGetMaxY(button.frame), button.frame.size.width-10, 2);
    }completion:^(BOOL finished) {
        _clickTopButton = NO;
        _scrollView.userInteractionEnabled = YES;
    }];
    if (self.buttonList.count) {
        for (UIButton *btn in self.buttonList) {
            [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        }
    }
    
    [button setTitleColor:self.selectedColor forState:UIControlStateNormal];
    self.selectedButton = button;
    [self invokeEventWithIndex:button.tag - kTopTabScrollButtonTag];
    _currentIndex = _nextIndex = button.tag - kTopTabScrollButtonTag;
    [self scrollToCenter:button];
    _currentIndex = button.tag - kTopTabScrollButtonTag;
}
- (void)invokeEventWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(linkageView:index:)]) {
        [self.delegate linkageView:self index:index];
    }
}
- (void)scrollToCenter:(UIButton *)button
{
    if (self.scrollView.contentSize.width > self.scrollView.frame.size.width)
    {
        CGFloat leftOffset  = CGRectGetMidX(button.frame) - CGRectGetWidth(self.bounds) / 2;
        CGFloat rightOffset = CGRectGetWidth(self.bounds) / 2 + CGRectGetMidX(button.frame) - self.scrollView.contentSize.width;
        
        if (leftOffset >= 0 && rightOffset <= 0)
        {
            [self.scrollView setContentOffset:CGPointMake(leftOffset, 0) animated:YES];
        }
        else
        {
            [self.scrollView setContentOffset:CGPointMake((leftOffset >= 0 ?: 0), 0) animated:YES];
            [self.scrollView setContentOffset:CGPointMake((rightOffset <= 0 ?: self.scrollView.contentSize.width - CGRectGetWidth(self.bounds)), 0) animated:YES];
        }
    }
}

- (void)adjustTitleAndLine:(UIScrollView *)scrollView
{
    if (!scrollView)return;
    self.observerScrollView = scrollView;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(scrollView)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (_clickTopButton) return;
    
    UIScrollView *scrollView = (__bridge UIScrollView *)(context);
    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _beginOffSetX = scrollView.contentOffset.x;
    }
    
    CGFloat offSetX = scrollView.contentOffset.x;
    CGFloat temp = offSetX / self.bounds.size.width;
    CGFloat progress = 0;
    
    if (offSetX - _beginOffSetX > 0) {
        
        _currentIndex = floor(temp);
        _nextIndex = _currentIndex + 1;
        _tempIndex = _currentIndex;
        if (_nextIndex >= self.buttonList.count) {
            _nextIndex = _currentIndex;
            return;
        }
    }
    if (offSetX - _beginOffSetX < 0) {
        
        _currentIndex = ceil(temp);
        if (_currentIndex <= 0) {
            return;
        }
        _nextIndex = _currentIndex - 1;
        if (_nextIndex >= 0) {
            
            _tempIndex = _nextIndex;
        }
    }
    
    progress = temp - _tempIndex;
    if (progress == 0.0) return;
    
    [self adjustTitleProgress:progress nextIndex:_nextIndex currentIndex:_currentIndex andScrollView:scrollView];
}

- (void)adjustTitleProgress:(CGFloat)progress nextIndex:(NSInteger)nextIndex currentIndex:(NSInteger)currentIndex andScrollView:(UIScrollView *)scrollView {
    
    UIButton *currenButton = (UIButton *)self.buttonList[currentIndex];
    UIButton *nextButton = (UIButton *)self.buttonList[nextIndex];
    
    CGFloat xDistance = nextButton.x - currenButton.x;
    CGFloat wDistance = nextButton.width - currenButton.width;
    
    if (self.scrollLineView) {
        self.scrollLineView.x = currenButton.x+5 + (nextIndex > currentIndex ? xDistance * progress : xDistance * (1-progress));
        self.scrollLineView.width = currenButton.width-10 + (nextIndex > currentIndex ? wDistance * progress :wDistance * (1-progress));
    }
    
    if (!(self.scrollLineView.centerX>currenButton.x-15) || !(self.scrollLineView.centerX<currenButton.maxX+15)) {
        [currenButton setTitleColor:self.normalColor forState:UIControlStateNormal];
        [nextButton setTitleColor:self.selectedColor forState:UIControlStateNormal];
        self.selectedButton = nextButton;
        [self scrollToCenter:nextButton];
    }else
    {
        [currenButton setTitleColor:self.selectedColor forState:UIControlStateNormal];
        [nextButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
}

-(void)dealloc
{
    [self.observerScrollView removeObserver:self forKeyPath:@"contentOffset"];
}


@end
