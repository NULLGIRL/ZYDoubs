//
//  UITabBar+ZYBadge.m
//  ZYDoubs
//
//  Created by Momo on 17/2/13.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "UITabBar+ZYBadge.h"
#define TabbarItemNums 4.0
@implementation UITabBar (ZYBadge)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 1500 + index;
    //    badgeView.layer.cornerRadius = 5;//圆形
    //    badgeView.backgroundColor = [UIColor whiteColor];
    badgeView.backgroundColor = [UIColor clearColor];
    //确定小红点的位置
    CGFloat tabBarW = ([UIScreen mainScreen].bounds.size.width) / 5;
    CGFloat y = self.frame.size.height - (self.frame.size.height - 5);
    switch (index) {
        case 0:
            badgeView.frame = CGRectMake(tabBarW - 30, y, 10, 10);//圆形大小为10
            break;
        case 1:
            badgeView.frame = CGRectMake(2 * tabBarW - 30, y, 10, 10);//圆形大小为10
            break;
        case 2:
            badgeView.frame = CGRectMake(3*tabBarW + 50, y, 10, 10);//圆形大小为10
            break;
        case 3:
            badgeView.frame = CGRectMake(4 * tabBarW + 50, y, 10, 10);//圆形大小为10
        default:
            break;
    }
    
    NSLog(@" tabBarW = %f",tabBarW);
    
    [self addSubview:badgeView];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red"]];
    [badgeView addSubview:imageV];
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 1500 + index) {
            [subView removeFromSuperview];
        }
    }
}


@end
