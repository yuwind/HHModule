//
//  HHBlockActionKey.h
//  HoverLinkageViewDemo
//
//  Created by hxw on 2017/5/12.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 在此对象中设置Key值常量
 */

typedef NSString *BlockActionKeyName NS_EXTENSIBLE_STRING_ENUM;

UIKIT_EXTERN BlockActionKeyName const HeaderViewButtonClick;
UIKIT_EXTERN BlockActionKeyName const TableViewCellButtonClick;




@interface HHBlockActionKey : NSObject

@end
