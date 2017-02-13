//
//  UITabBar+ZYBadge.h
//  ZYDoubs
//
//  Created by Momo on 17/2/13.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (ZYBadge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
