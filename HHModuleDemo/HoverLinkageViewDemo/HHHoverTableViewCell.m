//
//  HHHoverTableViewCell.m
//  HoverLinkageViewDemo
//
//  Created by hxw on 2017/5/10.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHHoverTableViewCell.h"
#import "UIView+HHConstruct.h"
#import "HHBlockActionKey.h"

@implementation HHHoverTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        [self configBaseInfo];
    }
    return self;
}

- (void)configBaseInfo
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.size = CGSizeMake(50, 50);
    button.x = self.width - 50;
    button.centerY = self.width;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = button;
}

- (void)buttonClick:(UIButton *)sender
{
    id block = [self.actionDict objectForKey:TableViewCellButtonClick];
    if (block == nil)return;
    void (^buttonAction)(NSString *text) = (void (^)(NSString *text)) block;
    buttonAction([NSString stringWithFormat:@"点击了%@",self.textLabel.text]);
}



@end
