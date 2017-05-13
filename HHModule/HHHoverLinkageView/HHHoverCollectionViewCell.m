//
//  HHHoverCollectionViewCell.m
//  HoverLinkageViewDemo
//
//  Created by hxw on 2017/5/10.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHHoverCollectionViewCell.h"

@interface HHHoverCollectionViewCell ()< HHBaseTableViewDelegate >

@end

@implementation HHHoverCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self configBaseInfo];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self configBaseInfo];
    }
    return self;
}

- (void)configBaseInfo
{

}

- (void)setTableView:(HHBaseTableView *)tableView
{
    [self.contentView.subviews.firstObject removeFromSuperview];
    _tableView = tableView;
    [self.contentView addSubview:_tableView];
}



@end
