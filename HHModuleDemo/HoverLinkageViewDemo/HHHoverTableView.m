//
//  HHHoverTableView.m
//  HoverLinkageViewDemo
//
//  Created by hxw on 2017/5/10.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHHoverTableView.h"
#import "HHHoverTableViewCell.h"
#import "HHCircleRefreshView.h"

@interface HHHoverTableView ()

@end

@implementation HHHoverTableView

/**
 需要合成父类属性,否则需要自定义属性接收数据
 */
@synthesize dataArray = _dataArray;
@synthesize dataDict  = _dataDict;
@synthesize indexPath = _indexPath;


- (void)configInitialInfo
{
    [self registerClass:[HHHoverTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HHHoverTableViewCell class])];

    
    
/********-----------------------------------------***********
 #pragma mark -重写下面方法统一设置固定刷新样式
 ********-----------------------------------------***********

    [self setRefreshType:RefreshManagerTypeCircle];
 
 ********-----------------------------------------***********
 ********-----------------------------------------***********/
}



/********-----------------------------------------***********
 #pragma mark -重写下面方法获取控制器传递的数据
 ********-----------------------------------------***********/
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
}
- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}
/********-----------------------------------------***********
 ********-----------------------------------------***********/




/********-----------------------------------------***********
 #pragma mark -重写下面方法自定义刷新控件
 ********-----------------------------------------***********

- (void)loadRefreshModel:(RefreshManagerType)refreshType
{
    HHCircleRefreshView *circleHeaderView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
    circleHeaderView.isShowShadow = YES;
    self.refreshManager.headerView = circleHeaderView;
    
    HHCircleRefreshView *circleFooterView = [[HHCircleRefreshView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
    circleFooterView.isFooter = YES;
    circleHeaderView.isShowShadow = YES;
    self.refreshManager.footerView = circleFooterView;
}
 ********-----------------------------------------***********
 ********-----------------------------------------***********/



- (void)beginRefreshWithType:(RefreshType)type
{
/********-----------------------------------------***********
 #pragma mark - 需调用父类方法给控制器回调刷新状态
 ********-----------------------------------------***********/
    
    [super beginRefreshWithType:type];
    
/********-----------------------------------------***********
 #pragma mark - 需调用父类方法给控制器回调刷新状态
 ********-----------------------------------------***********/
    
    __weak __typeof(self) wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [wSelf endRefreshAnimation];
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHHoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HHHoverTableViewCell class])];
    cell.actionDict = self.actionDict;
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个cell",(long)(indexPath.row+1)];
    
    return cell;
}

@end
