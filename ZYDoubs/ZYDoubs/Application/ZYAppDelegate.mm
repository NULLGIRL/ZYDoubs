//
//  ZYAppDelegate.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAppDelegate.h"


#import "ZYMainNavViewController.h"
#import "ZYMainTabBarViewController.h"

#import "ZYSipSettingViewController.h"  // 设置页面
#import "ZYChatViewController.h"        // 聊天界面
#import "ZYSupportViewController.h"     // 技术支持

#import "ZYAppDelegate+Private.h"
#import "ZYAppDelegate+SipCallback.h"
#import "ZYAppDelegate+EnterBackground.h"
#import "ZYAppDelegate+Notification.h"


#import "ZYNewFeatureViewController.h"  // 新特性界面
@interface ZYAppDelegate ()

@end

@implementation ZYAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.sipRegCount = 0;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    // 初始化Log输出信息
    [ZYLog setupLog];
    
    // 初始化一些变量
    _isLogout = [[NSUserDefaults standardUserDefaults] boolForKey:ZYUserLogout];
    
    // 判断idoubs是注册 没有的话就注册
    [self registSipAccount];
    

    //开启网络状况的监听
    [self MyNetReachability];
    
    // idoubs 注册通知
    [self registNotification];
    
    // idoubs 后台运行
    [self didFinishLaunchingWithOptions];
    
    
    //判断是否需要显示新特性界面
    ZYNewFeatureViewController *newFeaVC = [self setupDefaultContoller];
    if (newFeaVC) {
        self.window.rootViewController = newFeaVC;
    } else {
        self.window.rootViewController = [self setupRoutable];
    }
    
//    self.window.rootViewController = [self setupRoutable];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)registSipAccount{
    NSString * impu = [[NgnEngine sharedInstance].configurationService getStringWithKey:IDENTITY_IMPU];
    BOOL ret1 = [ZYTools isNullOrEmpty:impu];
    BOOL ret2 = [ZYSipTools sipUnRegister];
    
    if (!ret1 && ret2) {
        [ZYSipTools sipRegister];
    }
    
    
}


/**
 *  程序进入后台
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    DDLogInfo(@"程序进入后台, _isLogout = %d", _isLogout);
    [[NSUserDefaults standardUserDefaults] setBool:_isLogout forKey:ZYUserLogout];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
/**
 *  程序即将进入前台
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {

    _isLogout = NO;
}

#pragma mark - Private Method

- (ZYNewFeatureViewController *)setupDefaultContoller {
    
    if ([ZYNewFeatureViewController canShowNewFeature]) {
        ZYNewFeatureViewController *newFeatureVC = [[ZYNewFeatureViewController alloc] init];
        newFeatureVC.guideImagesArr = @[@"newFeature1", @"newFeature2", @"newFeature3"];
        
        [newFeatureVC setLastOnePlayFinished:^{
            [UIApplication sharedApplication].keyWindow.rootViewController = [self setupRoutable];
        }];
        
        return newFeatureVC;
        
    } else {
        return nil;
    }
    
}

- (UIViewController *)setupRoutable {

    
    ZYMainNavViewController *syNC = [[ZYMainNavViewController alloc] init];
    [self setupRouter];
    [[Routable sharedRouter] setNavigationController:syNC];
    
    // 进入控制器
    DDLogInfo(@"进入控制器, _isLogout = %d", _isLogout);
    
    [[Routable sharedRouter] open:TABLEBARCONTROLLER];
    
    return syNC;
}


- (void)setupRouter {
    
    [[Routable sharedRouter] map:TABLEBARCONTROLLER toController:[ZYMainTabBarViewController class]];
    
    [[Routable sharedRouter] map:ZYSIPSETTING_VIEWCONTROLLER toController:[ZYSipSettingViewController class]];
    
    [[Routable sharedRouter] map:ZYCHAT_VIEWCONTROLLER toController:[ZYChatViewController class]];
    
    [[Routable sharedRouter] map:ZYSupportViewController_VIEWCONTROLLER toController:[ZYSupportViewController class]];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(UIWindow *)window{
    if (_window == nil) {
        //窗体
        CGRect frame = [[UIScreen mainScreen]bounds];
        _window= [[UIWindow alloc]initWithFrame:frame];
        
    }
    return _window;
}



@end
