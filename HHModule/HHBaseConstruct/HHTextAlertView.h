//
//  TextAlertView.h
//  BaseConstruct
//
//  Created by hxw on 2017/4/14.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTextAlertView : UIView

@property (nonatomic, copy) void(^removeText)();

+ (instancetype)textAlert:(NSString *)text interval:(NSTimeInterval)interval offset:(CGFloat)offset;

@end
