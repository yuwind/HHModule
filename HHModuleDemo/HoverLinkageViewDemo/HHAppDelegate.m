//
//  AppDelegate.m
//  HoverLinkageViewDemo
//
//  Created by hxw on 2017/5/10.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "HHAppDelegate.h"
#import "UIViewController+HHConstruct.h"

@interface HHAppDelegate ()

@end

@implementation HHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIViewController registerWaitHudMode:WaitHudModeTrackcircle];

    return YES;
}


@end
