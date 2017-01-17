//
//  ZYAppDelegate+EnterBackground.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAppDelegate+EnterBackground.h"
#import "ZYAppDelegate+SipCallback.h"

@implementation ZYAppDelegate (EnterBackground)

static UIBackgroundTaskIdentifier sBackgroundTask = UIBackgroundTaskInvalid;
static dispatch_block_t sExpirationHandler = nil;

-(void)applicationDidEnterBackground:(UIApplication *)application{
    
    // sip进入后台回调保持清醒
    [self applicationDidEnterBackground];
    
    //保证后台运行
    [self saveBackgroundRun:application];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
    
    [self applicationWillEnterForeground];
}


#pragma mark
#pragma mark - idoubs相关
-(void)registNotification{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onNetworkEvent:) name:kNgnNetworkEventArgs_Name object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onNativeContactEvent:) name:kNgnContactEventArgs_Name object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onStackEvent:) name:kNgnStackEventArgs_Name object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onRegistrationEvent:) name:kNgnRegistrationEventArgs_Name object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onInviteEvent:) name:kNgnInviteEventArgs_Name object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onMessagingEvent:) name:kNgnMessagingEventArgs_Name object:nil];
}




#pragma mark AudioSessionListner for iOS 6.0+

- (void) onAudioSessionInteruptionEvent:(NSNotification*)notif {
    const NSInteger iType = [[[notif userInfo] valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    NgnNSLog(TAG, @"onAudioSessionInteruptionEvent:%d", (int)iType);
    switch (iType) {
        case AVAudioSessionInterruptionTypeBegan:
        {
            //            [self setAudioInterrupt:YES];
            break;
        }
        case AVAudioSessionInterruptionTypeEnded:
        {
            //            [self setAudioInterrupt:NO];
            break;
        }
    }
}

#pragma mark AudioSessionListner for iOS 6.0-

- (void)beginInterruption {
    NgnNSLog(TAG, @"beginInterruption");
    //    [self setAudioInterrupt:YES];
}

- (void)endInterruption {
    NgnNSLog(TAG, @"endInterruption");
    //    [self setAudioInterrupt:NO];
}

//+(void) setAudioInterrupt: (BOOL)interrupt {
//    NgnAVSession *avSession = [[NgnAVSession getFirstActiveCallAndNot:-1] retain];
//    if (avSession) {
//        [avSession setAudioInterrupt:interrupt];
//    }
//    [avSession release];
//}




/** didFinishLaunchingWithOptions*/
-(void)didFinishLaunchingWithOptions{
    // 按home键 app挂在后台后设置程序的长连接
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(onAudioSessionInteruptionEvent:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    }
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 6000
    else {
        [[AVAudioSession sharedInstance] setDelegate:self]; // deprecated starting SDK6
    }
#endif
    
    //注册sip
//    if (![PMTools isNullOrEmpty:userToken]) {
    
//        NSLog(@"[UserManagerTool userManager].user_sip] === %@",[UserManagerTool userManager].user_sip);
        NSLog(@"didFinishLaunchingWithOptions ");
    
//        if (![PMSipTools sipIsRegister]) {
    
//            [PMSipTools sipRegister];
            [[NgnEngine sharedInstance].soundService setSpeakerEnabled:YES];
//        }
    
        multitaskingSupported = [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] && [[UIDevice currentDevice] isMultitaskingSupported];
        sBackgroundTask = UIBackgroundTaskInvalid;
        sExpirationHandler = ^{
            NSLog(@"777777777777777777777777");
            NgnNSLog(TAG, @"Background task completed");
            // keep awake
//            if([PMSipTools sipIsRegister]){
                NSLog(@"88888888888888888888888");
                if([[NgnEngine sharedInstance].configurationService getBoolWithKey:NETWORK_USE_KEEPAWAKE]){
                    NSLog(@"999999999999999999999999");
                    [[NgnEngine sharedInstance] startKeepAwake];
                }
//            }
            [[UIApplication sharedApplication] endBackgroundTask:sBackgroundTask];
            sBackgroundTask = UIBackgroundTaskInvalid;
            
            //  add star
            sBackgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:sExpirationHandler];
            // end by zy
        };
        
        if(multitaskingSupported){
            NgnNSLog(TAG, @"Multitasking IS supported");
        }
        
        // Set media parameters if you want
        MediaSessionMgr::defaultsSetAudioGain(0, 0);
        
        
//    }
    
}


//保证后台一直运行
-(void)saveBackgroundRun:(UIApplication *)application{
    __block UIBackgroundTaskIdentifier background_task;
    
    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(TRUE)
        {
            NSTimeInterval sleepTime = 240.0f;
            NSLog(@"===============每%f唤醒一次", sleepTime);
            [NSThread sleepForTimeInterval:sleepTime];
            //            self.time ++;
        }
    });
}



/** applicationDidEnterBackground*/
-(void)applicationDidEnterBackground{
    
    // 进入后台
//    if (![PMTools isNullOrEmpty:userToken]) {
    
        NgnEngine *engine = [NgnEngine sharedInstance];
        
        // application.idleTimerDisabled = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000
        if(multitaskingSupported){
            ConnectionState_t registrationState = [engine.sipService getRegistrationState];
            if(registrationState == CONN_STATE_CONNECTING || registrationState == CONN_STATE_CONNECTED){
                NSLog(@"11111111111111111111111111");
                NgnNSLog(TAG, @"applicationDidEnterBackground (Registered or Registering)");
                //if(registrationState == CONN_STATE_CONNECTING){
                // request for 10min to complete the work (registration, computation ...)
                sBackgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:sExpirationHandler];
                //}
                
                if(registrationState == CONN_STATE_CONNECTED){
                    NSLog(@"222222222222222222222222222222222222");
                    if([engine.configurationService getBoolWithKey:NETWORK_USE_KEEPAWAKE]){
                        NSLog(@"33333333333333333333333333");
                        if(![NgnAVSession hasActiveSession]){
                            NSLog(@"4444444444444444444");
                            [engine startKeepAwake];
                        }
                    }
                }
                
                [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler: ^{             //设置长连接10分钟
                    NSLog(@"55555555555555555555");
                    NgnNSLog(TAG, @"applicationDidEnterBackground:: setKeepAliveTimeout:handler^");
                }];
                NSLog(@"66666666666666666666666");
            }
//        }
#endif /* __IPHONE_OS_VERSION_MIN_REQUIRED */
    }
    
    
}


/** applicationWillEnterForeground*/
-(void)applicationWillEnterForeground{
    
//    if (![PMTools isNullOrEmpty:userToken]) {
    
        NgnEngine *engine = [NgnEngine sharedInstance];
        
        ConnectionState_t registrationState = [engine.sipService getRegistrationState];
        NgnNSLog(TAG, @"applicationWillEnterForeground and RegistrationState=%d, NetworkReachable=%s", registrationState, engine.networkService.reachable ? "TRUE" : "FALSE");
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000
        // terminate background task
        if(sBackgroundTask != UIBackgroundTaskInvalid){
            [[UIApplication sharedApplication] endBackgroundTask:sBackgroundTask]; // Using shared instance will crash the application
            sBackgroundTask = UIBackgroundTaskInvalid;
        }
        // stop keepAwake
        [engine stopKeepAwake];
        
#endif /* __IPHONE_OS_VERSION_MIN_REQUIRED */
        
        if(registrationState != CONN_STATE_CONNECTED){
//            [self queryConfigurationAndRegister];
//            [PMSipTools sipRegister];
        }
        
        // check native contacts changed while app was runnig on background
        if(nativeABChangedWhileInBackground){
            // trigger refresh
            nativeABChangedWhileInBackground = NO;
        }
        
//    }
    
}


-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [self applicationDidReceiveMemoryWarning];
}

/** applicationDidReceiveMemoryWarning*/
-(void)applicationDidReceiveMemoryWarning{
//    [[SDImageCache sharedImageCache] clearMemory];
    
//    if (![PMTools isNullOrEmpty:[UserManagerTool userManager].user_sip]) {
        NgnNSLog(TAG, @"applicationDidReceiveMemoryWarning");
        [[NgnEngine sharedInstance].contactService unload];
        [[NgnEngine sharedInstance].historyService clear];
        [[NgnEngine sharedInstance].storageService clearFavorites];
        
//    }
    
}



@end
