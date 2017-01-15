//
//  ZYAppDelegate+Private.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAppDelegate+Private.h"

#import "Reachability.h"  //网络监听

@implementation ZYAppDelegate (Private)

#pragma mark
#pragma mark - AppDelegate(Private)
-(void) networkAlert:(NSString*)message{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"物业管理"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:kAlertMsgButtonOkText
                                              otherButtonTitles: nil];
        [alert show];
        
    }
}

-(void) newMessageAlert:(NSString*)message{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"物业管理"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:kAlertMsgButtonCancelText
                                              otherButtonTitles:kAlertMsgButtonOkText, nil];
        [alert show];
    }
}

-(BOOL) queryConfigurationAndRegister{
    
    BOOL on3G = ([NgnEngine sharedInstance].networkService.networkType & NetworkType_WWAN);
    BOOL use3G = [[NgnEngine sharedInstance].configurationService getBoolWithKey:NETWORK_USE_3G];
    if(on3G && !use3G){
        [self networkAlert:kNetworkAlertMsgThreedGNotEnabled];
        return NO;
    }
    else if(![[NgnEngine sharedInstance].networkService isReachable]){
        [self networkAlert:kNetworkAlertMsgNotReachable];
        return NO;
    }
    else {

//        [PMSipTools sipRegister];
//        return [PMSipTools sipIsRegister];
        return [[NgnEngine sharedInstance].sipService registerIdentity];
    }


}

-(void) setAudioInterrupt: (BOOL)interrupt {
    NgnAVSession *avSession = [NgnAVSession getFirstActiveCallAndNot:-1];
    if (avSession) {
        [avSession setAudioInterrupt:interrupt];
    }
}



#pragma mark - 开启网络监听
-(void)MyNetReachability{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    Reachability *hostReach =[Reachability reachabilityWithHostName:@"www.google.com"];//可以以多种形式初始化
    [hostReach startNotifier]; //开始监听,会启动一个run loop
    [self updateInterfaceWithReachability: hostReach];
}

- (void)reachabilityChanged: (NSNotification*)note
{
    Reachability*curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


//处理连接改变后的情况
- (void)updateInterfaceWithReachability: (Reachability*)curReach
{
    //对连接改变做出响应的处理动作。
    
    NetworkStatus status=[curReach currentReachabilityStatus];
    
    if(status != NotReachable)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reachable" object:nil];
    } else if (status== NotReachable) {
        
        //停止刷新等
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotReachable" object:nil];
    }
}






@end
