//
//  ZYAppDelegate.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSNgnStack.h"

@interface ZYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


/** 判断用户是否退出当前用户 */
@property (assign, nonatomic) BOOL isLogout;

@end
