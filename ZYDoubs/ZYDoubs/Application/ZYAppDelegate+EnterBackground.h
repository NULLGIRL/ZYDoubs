//
//  ZYAppDelegate+EnterBackground.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAppDelegate.h"

@interface ZYAppDelegate (EnterBackground)


-(void)registNotification;

/** didFinishLaunchingWithOptions*/
-(void)didFinishLaunchingWithOptions;

/** applicationDidReceiveMemoryWarning*/
-(void)applicationDidReceiveMemoryWarning;

/** applicationDidEnterBackground*/
-(void)applicationDidEnterBackground;

/** applicationWillEnterForeground*/
-(void)applicationWillEnterForeground;

@end
