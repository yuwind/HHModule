//
//  RetryAlertView.h
//  BaseConstruct
//
//  Created by hxw on 2017/4/14.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HHConstruct.h"

@interface HHRetryAlertView : UIView

@property (nonatomic, copy)  retryEvent event;

+ (instancetype)retryView:(RetryViewInfo)retryViewInfo event:(retryEvent)event;

@end
