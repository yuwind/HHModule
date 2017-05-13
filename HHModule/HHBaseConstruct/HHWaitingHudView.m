//
//  WaitingHudView.m
//  ShareMethod
//
//  Created by hxw on 2017/3/15.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHWaitingHudView.h"
#import "UIView+HHConstruct.h"


#define HUDT 0.2
#define HUDWH 80
#define DESCHUDWH 90
#define LINEWIDTH 3
#define ANIMATETIME 0.75
#define GRADULER 12
#define GRADULECOLOR [UIColor redColor]

@interface HHWaitingHudView () <CAAnimationDelegate>

@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, weak)   UIView *hudSuperView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) CAShapeLayer *coverLayer;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL isAddObserver;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isTrackAnimation;
@property (nonatomic, assign) BOOL isGraduleAnimation;
@property (nonatomic, assign) BOOL isGraduleDescrible;
@property (nonatomic, strong) CAShapeLayer *graduleLayer;
@property (nonatomic, strong) CAReplicatorLayer *graduleRep;

@end

@implementation HHWaitingHudView

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]init];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityIndicator.frame = self.bounds;
        [_activityIndicator startAnimating];
    }
    return _activityIndicator;
}
- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.font = [UIFont systemFontOfSize:15];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.text = @"加载中...";
        [_descLabel sizeToFit];
    }
    return _descLabel;
}

- (CAShapeLayer *)coverLayer
{
    if (!_coverLayer) {
        _coverLayer = [CAShapeLayer layer];
        _coverLayer.fillColor = [UIColor clearColor].CGColor;
        _coverLayer.strokeColor = [UIColor redColor].CGColor;
        _coverLayer.lineCap = kCALineCapRound;
        _coverLayer.lineJoin = kCALineJoinRound;
        _coverLayer.lineWidth = LINEWIDTH;
        _coverLayer.bounds = CGRectMake(0, 0,35, 35);
        _coverLayer.path = [UIBezierPath bezierPathWithOvalInRect:_coverLayer.bounds].CGPath;
        _coverLayer.strokeStart = 0;
        _coverLayer.strokeEnd = 1;
    }
    return _coverLayer;
}

- (CAShapeLayer *)graduleLayer
{
    if (!_graduleLayer) {
        _graduleLayer = [CAShapeLayer layer];
        _graduleLayer.bounds = CGRectMake(0, 0, GRADULER, GRADULER);
        _graduleLayer.position = CGPointMake(_isGraduleDescrible?23:18, GRADULER/2);
        _graduleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, GRADULER, GRADULER)].CGPath;
        _graduleLayer.fillColor = GRADULECOLOR.CGColor;
    }
    return _graduleLayer;
}

- (CAReplicatorLayer *)graduleRep
{
    if (!_graduleRep) {
        _graduleRep = [CAReplicatorLayer layer];
        _graduleRep.bounds = CGRectMake(0, 0, self.width, GRADULER);
        _graduleRep.position = CGPointMake(self.width/2, _isGraduleDescrible?self.height/2-8:self.height/2);
        _graduleRep.instanceCount = 3;
        _graduleRep.instanceDelay = 0.15;
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DTranslate(transform, GRADULER+10, 0, 0.0);
        _graduleRep.instanceTransform = transform;
        [_graduleRep addSublayer:self.graduleLayer];
    }
    return _graduleRep;
}

+ (instancetype)hudView:(WaitHudMode)mode Offset:(CGFloat)offset
{
    return [[HHWaitingHudView alloc]initWithMode:mode Offset:offset];
}

- (instancetype)initWithMode:(WaitHudMode)mode Offset:(CGFloat)offset
{
    if (self = [super init]) {
        self.offset = offset;
        [self addActiveNotify];
        [self configBaseInfo:mode];
    }
    return self;
}

- (void)addActiveNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)appWillEnterForeground:(NSNotification *)notify
{
    if (_isTrackAnimation) {
        [self startTrackCircleAnimation:NO];
    }
    if (_isGraduleAnimation) {
        
        [self beginGraduleAnimatin];
    }
}
- (void)configBaseInfo:(WaitHudMode)mode
{
    switch (mode) {
        case WaitHudModeActivity:
        {
            self.frame = CGRectMake(0, 0, HUDWH, HUDWH);
            [self addSubview:self.activityIndicator];
        }
            break;
        case WaitHudModeActivityDescrible:
        {
            self.frame = CGRectMake(0, 0, DESCHUDWH, DESCHUDWH);
            
            [self addSubview:self.activityIndicator];
            [self addSubview:self.descLabel];
            self.activityIndicator.centerX = self.width/2;
            self.activityIndicator.centerY = self.height/2-12;
            self.descLabel.centerX = self.width/2;
            self.descLabel.centerY = self.height/2+25;
        }
            break;
        case WaitHudModeCircle:
        {
            self.frame = CGRectMake(0, 0, HUDWH, HUDWH);
            [self.layer addSublayer:self.coverLayer];
            self.coverLayer.position = CGPointMake(HUDWH/2, HUDWH/2);
            [self beginCircleAnimation];
            
        }
            break;
        case WaitHudModeCircleDescrible:
        {
            self.frame = CGRectMake(0, 0, DESCHUDWH, DESCHUDWH);
            [self.layer addSublayer:self.coverLayer];
            self.coverLayer.position = CGPointMake(DESCHUDWH/2, DESCHUDWH/2-12);
            [self addSubview:self.descLabel];
            self.descLabel.centerX = self.width/2;
            self.descLabel.centerY = self.height/2+25;
            [self beginCircleAnimation];
        }
            break;
        case WaitHudModeTrackcircle:
        {
            self.frame = CGRectMake(0, 0, HUDWH, HUDWH);
            [self.layer addSublayer:self.coverLayer];
            self.coverLayer.position = CGPointMake(HUDWH/2, HUDWH/2);
            _isTrackAnimation = YES;
            [self startTrackCircleAnimation:NO];
        }
            break;
        case WaitHudModeTrackcircleDescrible:
        {
            self.frame = CGRectMake(0, 0, DESCHUDWH, DESCHUDWH);
            [self.layer addSublayer:self.coverLayer];
            self.coverLayer.position = CGPointMake(DESCHUDWH/2, DESCHUDWH/2-12);
            [self addSubview:self.descLabel];
            self.descLabel.centerX = self.width/2;
            self.descLabel.centerY = self.height/2+25;
            _isTrackAnimation = YES;
            [self startTrackCircleAnimation:NO];
        }
            break;
        case WaitHudModeGraduleScale:
        {
            _isGraduleDescrible = NO;
            self.frame = CGRectMake(0, 0, HUDWH, HUDWH);
            [self.layer addSublayer:self.graduleRep];
            _isGraduleAnimation = YES;
            [self beginGraduleAnimatin];
        }
            break;
        case WaitHudModeGraduleScaleDescrible:
        {
            _isGraduleDescrible = YES;
            self.frame = CGRectMake(0, 0, DESCHUDWH, DESCHUDWH);
            [self.layer addSublayer:self.graduleRep];
            [self addSubview:self.descLabel];
            self.descLabel.centerX = self.width/2;
            self.descLabel.centerY = self.height/2+22;
            _isGraduleAnimation = YES;
            [self beginGraduleAnimatin];
        }
            break;
        default:
            break;
    }
    [self drawCornerRadius];
    self.alpha = 0.0f;
    self.layer.zPosition = 2.0f;
    [UIView animateWithDuration:HUDT animations:^{
        self.alpha = 1;
    }];
}
- (void)drawCornerRadius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,  [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor);
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10].CGPath);
    CGContextDrawPath(context, kCGPathFill);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)beginGraduleAnimatin
{
    CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DScale(t, 1.0, 1.0, 0.0);
    CATransform3D t3 = CATransform3DScale(t, 0.1, 0.1, 0.0);
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
    scaleAnim.duration = 0.45;
    scaleAnim.autoreverses = YES;
    scaleAnim.repeatCount = HUGE;
    [self.graduleLayer addAnimation:scaleAnim forKey:nil];
}

- (void)beginCircleAnimation
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.coverLayer.strokeStart = 0;
    self.coverLayer.strokeEnd = 0.8;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.9;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = HUGE;
    [self.coverLayer removeAnimationForKey:@"rotation"];
    [self.coverLayer addAnimation:rotationAnimation forKey:@"rotation"];
    [CATransaction commit];
}

- (void)startTrackCircleAnimation:(BOOL)reverse
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (reverse) {
        
        self.coverLayer.strokeStart = 0.89;
        self.coverLayer.strokeEnd = 0.9;
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeAnimation.fromValue = @(0);
        strokeAnimation.toValue = @(0.9);
        strokeAnimation.duration = ANIMATETIME;
        strokeAnimation.delegate = self;
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.62 :0.0 :0.38 :1.0];
        
        [self.coverLayer removeAnimationForKey:@"strokeStart"];
        [self.coverLayer addAnimation:strokeAnimation forKey:@"strokeStart"];
        
    }else
    {
        if (_isFirst) _rate -= 0.2*M_PI;
        _isFirst = YES;
        self.coverLayer.strokeStart = 0;
        self.coverLayer.strokeEnd = 0.9;
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @(0);
        strokeAnimation.toValue = @(0.9);
        strokeAnimation.duration = ANIMATETIME;
        strokeAnimation.delegate = self;
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.62 :0.0 :0.38 :1.0];
        
        [self.coverLayer removeAnimationForKey:@"strokeEnd"];
        [self.coverLayer addAnimation:strokeAnimation forKey:@"strokeEnd"];
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @(_rate);
        rotationAnimation.toValue = @(_rate + 2 * M_PI);
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.duration = 2*ANIMATETIME;
        rotationAnimation.fillMode = kCAFillModeForwards;
        rotationAnimation.removedOnCompletion = NO;
        [self.coverLayer removeAnimationForKey:@"rotation"];
        [self.coverLayer addAnimation:rotationAnimation forKey:@"rotation"];
        
    }
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (finished && [anim isKindOfClass:[CABasicAnimation class]])
    {
        CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
        BOOL isStrokeEnd = [basicAnim.keyPath isEqualToString:@"strokeEnd"];
        [self startTrackCircleAnimation:isStrokeEnd];
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
    self.center = CGPointMake(_hudSuperView.width/2, _hudSuperView.height/2+self.offset);
}

- (void)dealloc
{
    [_hudSuperView removeObserver:self forKeyPath:@"frame"];
    [_hudSuperView removeObserver:self forKeyPath:@"bounds"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
