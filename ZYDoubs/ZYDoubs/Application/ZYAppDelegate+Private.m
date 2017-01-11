//
//  ZYAppDelegate+Private.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAppDelegate+Private.h"

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




@end
