//
//  WaitingHudView.h
//  ShareMethod
//
//  Created by hxw on 2017/3/15.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HHConstruct.h"


@interface HHWaitingHudView : UIView

+ (instancetype)hudView:(WaitHudMode)mode Offset:(CGFloat)offset;

@end
