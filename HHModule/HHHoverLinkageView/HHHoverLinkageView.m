//
//  HoverLinkageView.m
//  HoverLinkageView
//
//  Created by hxw on 2017/5/10.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHHoverLinkageView.h"
#import "HHHoverCollectionViewCell.h"
#import "UIView+HHConstruct.h"
#import "HHBaseTableView.h"
#import "HHBlockActionKey.h"


typedef NS_ENUM(NSUInteger, HHScrollDirection) {
    HHScrollDirectionNone = 0,
    HHScrollDirectionUp,
    HHScrollDirectionDown,
};


@interface HHHoverLinkageView ()< UICollectionViewDelegate, UICollectionViewDataSource,HHLinkageViewDelegate, UIGestureViewDelegate, HHBaseTableViewDelegate >

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *responseView;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*offsetArray;
@property (nonatomic, strong) NSMutableArray <HHBaseTableView *>*contentArray;
@property (nonatomic, assign) HHScrollDirection direction;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat beginOffset;

@property (nonatomic, assign) BOOL isFirstDisplay;
@property (nonatomic, assign) BOOL isNeedScroll;

@property (nonatomic, assign) CGFloat panChange;
@property (nonatomic, assign) CGFloat panTurn;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGFloat lastVelocity;

#pragma mark TestData
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation HHHoverLinkageView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initBaseInfo];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initBaseInfo];
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        
        [self initBaseInfo];
    }
    return self;
}

#pragma mark ========>>> initBaseInfo <<<========
- (void)initBaseInfo
{
    [self configUtilityInfo];
    [self configCollectionViewInfo];
    [self configLinkageViewInfo];
    [self configHeaderViewInfo];
}
- (void)configUtilityInfo
{
    _offsetArray  = [NSMutableArray array];
    _contentArray = [NSMutableArray array];
    _actionDict   = [NSMutableDictionary dictionary];
    _isNeedHeaderViewZoom                = YES;
    _isNeedHeaderViewScroll              = YES;
    _isNeedCollectionViewScrollAnimation = YES;
    self.backgroundColor = [UIColor whiteColor];
}
- (void)configCollectionViewInfo
{
    _collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionLayout.itemSize = CGSizeMake(KWIDTH, KHEIGHT-LINKAGEVIEWH);
    _collectionLayout.minimumInteritemSpacing = 0;
    _collectionLayout.minimumLineSpacing = 0;
    _collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, TOPVIEWH+LINKAGEVIEWH, KWIDTH, KHEIGHT-LINKAGEVIEWH) collectionViewLayout:_collectionLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[HHHoverCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HHHoverCollectionViewCell class])];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    [self addSubview:_collectionView];
}
- (void)configLinkageViewInfo
{
    __weak __typeof(self)wSelf = self;
    _linkageView = [[HHLinkageView alloc]initWithFrame:CGRectMake(0, TOPVIEWH, KWIDTH, LINKAGEVIEWH)];
    _linkageView.callBack = ^(){
    
        int i = 0;
        [wSelf.offsetArray removeAllObjects];
        while (i<wSelf.linkageView.titleArray.count) {
            
            wSelf.offsetArray[i] = [NSNumber numberWithFloat:0];
            i++;
        }
        [wSelf.collectionView reloadData];
    };
    _linkageView.normalColor = [UIColor darkGrayColor];
    _linkageView.selectedColor = [UIColor redColor];
    _linkageView.delegate = self;
    _linkageView.isShowIndicator = YES;
    [_linkageView adjustTitleAndLine:_collectionView];
    [self addSubview:_linkageView];
}

- (void)configHeaderViewInfo
{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, TOPVIEWH)];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, TOPVIEWH)];
    _imageView.image = [UIImage imageNamed:@"pic.jpg"];
    [_headerView addSubview:_imageView];
    
    _button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    _button.frame = CGRectMake(KWIDTH/2-15, TOPVIEWH/2, 30, 30);
    [_button addTarget:self action:@selector(headerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_button];
    [_headerView addPanGesture];
    _headerView.panResponseDelegate = self;
    [self insertSubview:_headerView belowSubview:_collectionView];
}

- (void)layoutSubviews
{
    if (_collectionLayout) {
        _collectionLayout.itemSize = CGSizeMake(KWIDTH, KHEIGHT-LINKAGEVIEWH-self.y);
    }
    if (_collectionView) {
        _collectionView.frame = CGRectMake(0, TOPVIEWH+LINKAGEVIEWH, KWIDTH, KHEIGHT-LINKAGEVIEWH-self.y);
    }
}

#pragma mark ========>>> setterConfig <<<========
- (void)setHeaderView:(UIView *)headerView
{
    [_headerView removeFromSuperview];
    _headerView = nil;
    _headerView = headerView;
    [_headerView addPanGesture];
    _headerView.panResponseDelegate = self;
    _headerView.frame = CGRectMake(0, 0, KWIDTH, TOPVIEWH);
    [self insertSubview:_headerView belowSubview:_collectionView];
}
- (void)setIsNeedHeaderViewScroll:(BOOL)isNeedHeaderViewScroll
{
    _isNeedHeaderViewScroll = isNeedHeaderViewScroll;
    _headerView ? nil : [_headerView removePanGesture];
}

#pragma mark ========>>> JustForTest <<<========
- (void)headerViewButtonClick:(UIButton *)sender
{
    id block = [self.actionDict objectForKey:HeaderViewButtonClick];
    if (block == nil)return;
    void (^headerViewAction)(NSString *text) = (void (^)(NSString *text)) block;
    headerViewAction(@"最怕你一生碌碌无为，还安慰自己平凡可贵。");
}

#pragma mark ========>>> UICollectionViewDataSource <<<========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.offsetArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFirstDisplay) {
        
        _isNeedScroll = NO;
    }else
    {
        _isNeedScroll = YES;
        _isFirstDisplay = YES;
    }

    HHHoverCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HHHoverCollectionViewCell class]) forIndexPath:indexPath];
    
    if (_contentArray.count <= indexPath.row) {
        Class className = NSClassFromString(self.tableViewClassName);
        HHBaseTableView *tableView = [[className alloc]initWithFrame:collectionCell.bounds style:UITableViewStylePlain];
        tableView.refreshDelegate = self;
        collectionCell.tableView = tableView;
        tableView.actionDict = self.actionDict;
        tableView.indexPath = indexPath;
        tableView.dataDict = self.dataDict;
        tableView.dataArray = self.dataArray;
        [_contentArray addObject:tableView];
    }else
    {
        [collectionCell.contentView.subviews.firstObject removeFromSuperview];
        [collectionCell.contentView addSubview:_contentArray[indexPath.row]];
    }
    
    return collectionCell;
}

#pragma mark ========>>> UICollectionViewDelegate <<<========
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isNeedScroll = YES;
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isNeedScroll = YES;
}

#pragma mark ========>>> HHRefreshManagerDelegate <<<========
- (void)beginRefreshWithType:(RefreshType)type
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginRefreshWithType:)]) {
        [self.delegate beginRefreshWithType:type];
    }
}
- (void)endRefreshAnimation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endRefreshAnimation)]) {
        [self.delegate endRefreshAnimation];
    }
}

#pragma mark ========>>> HHLinkageViewDelegate <<<========
- (void)linkageView:(HHLinkageView *)view index:(NSInteger)index
{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:_isNeedCollectionViewScrollAnimation];
}

#pragma mark ========>>> UIGestureViewDelegate <<<========
- (void)gestureView:(UIView *)view startGestureLocation:(CGPoint)point
{
    _originY = _linkageView.y;
}
- (void)gestureView:(UIView *)view didEndGestureDirection:(LCPanGestureDirection)direction
{
    _originY = _panTurn = _panChange = _lastVelocity = 0;
}
- (void)gestureView:(UIView *)view recognizerStateChanged:(LCPanGestureDirection)direction rate:(CGFloat)rate translation:(CGPoint)translation velocity:(CGPoint)velocity
{
    if (!_isNeedHeaderViewScroll){[_headerView addPanGesture];return;}
    if (direction == LCPanGestureDirectionLeft || direction == LCPanGestureDirectionRight) {
        
        CGFloat distant = rate * [UIScreen mainScreen].bounds.size.height / 2;
        [self gestureInHeaderViewDistant:distant translation:translation velocity:velocity];
    }
}
- (void)gestureInHeaderViewDistant:(CGFloat)distant translation:(CGPoint)translation velocity:(CGPoint)velocity
{
    if (velocity.y>0 && _lastVelocity<= 0) {
        
        _panTurn = distant;
        _originY = _linkageView.y;
    }
    if (velocity.y<0 && _lastVelocity>= 0) {
        
        _panTurn = distant;
        _originY = _linkageView.y;
    }
    _lastVelocity = velocity.y;
    _panChange = distant;
    
    if (_linkageView.y<0) {
        _linkageView.y = 0;
        return;
    }else if (_linkageView.y>TOPVIEWH)
    {
        _linkageView.y = TOPVIEWH;
    }
    else {
        if (_linkageView.y == 0) {
            if ((distant - _panTurn)>0) {
                return;
            }
        }
        if (_linkageView.y==TOPVIEWH) {
            
            if ((distant - _panTurn)<0) {
                return;
            }
        }
        _linkageView.y = (_originY - (distant - _panTurn)) >= TOPVIEWH ? TOPVIEWH : _originY - (distant - _panTurn);
    }
    _collectionView.y = _linkageView.y+LINKAGEVIEWH ;
}

#pragma mark ========>>> HHBaseTableViewDelegate <<<========
- (void)hh_ScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isNeedScroll)return;
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (_beginOffset - translation.y < 0)
    {
        _direction = HHScrollDirectionDown;
    }else if (_beginOffset - translation.y > 0)
    {
        _direction = HHScrollDirectionUp;
    }
    _beginOffset = translation.y;
    _currentIndex = ceil(_collectionView.contentOffset.x / _collectionView.width);
    if (offsetY>0)
    {
        if (_collectionView.y>LINKAGEVIEWH) {
            
            if (_direction == HHScrollDirectionUp) {
                CGFloat conserverOffset = _offsetArray[_currentIndex].floatValue;
                if (conserverOffset) {
                    
                    _collectionView.y -= (offsetY-conserverOffset);
                    CGRect tempFrame = scrollView.bounds;
                    tempFrame.origin.y = conserverOffset;
                    scrollView.bounds = tempFrame;
                }else
                {
                    _collectionView.y -= offsetY;
                    CGRect tempFrame = scrollView.bounds;
                    tempFrame.origin.y = 0;
                    scrollView.bounds = tempFrame;
                }
            }else if (_direction == HHScrollDirectionDown)
            {
                _offsetArray[_currentIndex] = [NSNumber numberWithFloat:offsetY<0?0:offsetY];
            }
        }else
        {
            _collectionView.y = LINKAGEVIEWH;
            _offsetArray[_currentIndex] = [NSNumber numberWithFloat:offsetY<0?0:offsetY];
        }
        
    }else
    {
        if (_collectionView.y<TOPVIEWH+LINKAGEVIEWH) {
            _collectionView.y += -offsetY;
            CGRect tempFrame = scrollView.bounds;
            tempFrame.origin.y = 0.01;
            scrollView.bounds = tempFrame;
            _offsetArray[_currentIndex] = [NSNumber numberWithFloat:0];
        }else
        {
            _collectionView.y = TOPVIEWH+LINKAGEVIEWH;
        }
    }
    _linkageView.y = _collectionView.y>=TOPVIEWH+LINKAGEVIEWH?TOPVIEWH:_collectionView.y<LINKAGEVIEWH?0:_collectionView.y-LINKAGEVIEWH;
    
    if (_isNeedHeaderViewZoom)
    {
        if (offsetY<0&&_linkageView.y == TOPVIEWH)
        {
            CGFloat scale = fabs(offsetY)/KWIDTH + 1;
            _headerView.transform = CGAffineTransformMakeScale(scale, scale);
        }else
        {
            _headerView.transform = CGAffineTransformIdentity;
        }
    }
}



@end
