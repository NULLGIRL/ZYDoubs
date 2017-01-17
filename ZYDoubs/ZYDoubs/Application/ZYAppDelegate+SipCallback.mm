//
//  ZYAppDelegate+SipCallback.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAppDelegate+SipCallback.h"
#import "ZYAppDelegate+Private.h"
#import "ZYCallViewController.h"

@implementation ZYAppDelegate (SipCallback)

#pragma mark
#pragma mark - AppDelegate(Sip_And_Network_Callbacks)

//== Network events == //
-(void) onNetworkEvent:(NSNotification*)notification {
    
    NgnNetworkEventArgs *eargs = [notification object];
    
    switch (eargs.eventType) {
        case NETWORK_EVENT_STATE_CHANGED:
        default:
        {
            NgnNSLog(TAG,@"NetworkEvent reachable=%@ networkType=%i",
                     [NgnEngine sharedInstance].networkService.reachable ? @"YES" : @"NO", [NgnEngine sharedInstance].networkService.networkType);
            
            if([NgnEngine sharedInstance].networkService.reachable){
                BOOL onMobileNework = ([NgnEngine sharedInstance].networkService.networkType & NetworkType_WWAN);
                
                if(onMobileNework){ // 3G, 4G, EDGE ...
                    MediaSessionMgr::defaultsSetBandwidthLevel(tmedia_bl_medium); // QCIF, SQCIF
                }
                else {// WiFi
                    MediaSessionMgr::defaultsSetBandwidthLevel(tmedia_bl_unrestricted);// SQCIF, QCIF, CIF ...
                }
                
                // unregister the application and schedule another registration
                BOOL on3G = onMobileNework; // Downgraded to 3G even if it could be 4G or EDGE
                BOOL use3G = [[NgnEngine sharedInstance].configurationService getBoolWithKey:NETWORK_USE_3G];
                if(on3G && !use3G){
                    [self networkAlert:kNetworkAlertMsgThreedGNotEnabled];
                    [[NgnEngine sharedInstance].sipService stopStackSynchronously];
                }
                else { // "on3G and use3G" or on WiFi
                    // stop stack => clean up all dialogs
                    [[NgnEngine sharedInstance].sipService stopStackSynchronously];
                    [[NgnEngine sharedInstance].sipService registerIdentity];
                }
            }
            else{
                if([NgnEngine sharedInstance].sipService.registered){
                    [[NgnEngine sharedInstance].sipService stopStackSynchronously];
                }
            }
            
            break;
        }
    }
}

//== Native Contact events == //
-(void) onNativeContactEvent:(NSNotification*)notification {
    NgnContactEventArgs *eargs = [notification object];
    
    switch (eargs.eventType) {
        case CONTACT_RESET_ALL:
        default:
        {
            if([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
                self->nativeABChangedWhileInBackground = YES;
            }
            // otherwise addAll will be called when the client registers
            break;
        }
    }
}

-(void) onStackEvent:(NSNotification*)notification {
    NgnStackEventArgs * eargs = [notification object];
    switch (eargs.eventType) {
        case STACK_STATE_STARTING:
        {
            NgnNSLog(TAG,@"STACK_STATE_STARTING");
            // this is the only place where we can be sure that the audio system is up
            [[NgnEngine sharedInstance].soundService setSpeakerEnabled:YES];
            
            break;
        }
        case STACK_DISCONNECTED: // Network connection closed
        {
            NgnNSLog(TAG,@"STACK_DISCONNECTED");
            // Uncomment next line if you want to connect again
            
            [self queryConfigurationAndRegister];
            break;
        }
        default:
            break;
    }
}

//== REGISTER events == //
-(void) onRegistrationEvent:(NSNotification*)notification {
    SYFunc
    SYLog(@"appdelegate ---- 注册事件 ----  %@",[[NgnEngine sharedInstance].sipService isRegistered]?@"YES":@"NO");
    
    // gets the new registration state
    ConnectionState_t registrationState = [[NgnEngine sharedInstance].sipService getRegistrationState];
    switch (registrationState) {
        case CONN_STATE_NONE:
        case CONN_STATE_TERMINATED:
            if(scheduleRegistration){
                scheduleRegistration = FALSE;
                [self queryConfigurationAndRegister];
                
            }
            break;
            
        case CONN_STATE_CONNECTING:
        case CONN_STATE_TERMINATING:
        case CONN_STATE_CONNECTED:
        default:
            break;
    }
    
    NgnRegistrationEventArgs* eargs = [notification object];
    switch (eargs.eventType) {
        case REGISTRATION_NOK:
            //注册失败
            break;
        case UNREGISTRATION_OK:
            //未注册 （掉线)
            if ([self checkNetWork]) {
                self.sipRegCount ++;
                if (self.sipRegCount <= 3) {
                    [ZYSipTools sipRegister];
                    
                }else{
                    
                }
            }
            else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self checkNetWork]) {
                        self.sipRegCount ++;
                        if (self.sipRegCount <= 3) {
                            [ZYSipTools sipRegister];
                        }else{
                            
                        }
                    }
                });
            }
            
            
            
            break;
        case REGISTRATION_OK:
            //已注册
            self.sipRegCount = 0;
            break;
        case REGISTRATION_INPROGRESS:
            //正在注册
            break;
        case UNREGISTRATION_INPROGRESS:
            //正在注销
            break;
        case UNREGISTRATION_NOK:
            //未注销失败
            break;
    }
    
}

// 检查网络是否通畅
- (BOOL)checkNetWork{
    
    if (![ZYTools connectedToNetwork]) {
        return NO;
    }
    return YES;
}

//== PagerMode IM (MESSAGE) events == //
-(void) onMessagingEvent:(NSNotification*)notification {
    NgnMessagingEventArgs* eargs = [notification object];
    
    switch (eargs.eventType) {
        case MESSAGING_EVENT_CONNECTING:
        case MESSAGING_EVENT_CONNECTED:
        case MESSAGING_EVENT_TERMINATING:
        case MESSAGING_EVENT_TERMINATED:
        case MESSAGING_EVENT_FAILURE:
        case MESSAGING_EVENT_SUCCESS:
        case MESSAGING_EVENT_OUTGOING:
        default:
        {
            break;
        }
            
        case MESSAGING_EVENT_INCOMING:
        {
            if(eargs.payload){
                
                NSString* contentType = [eargs getExtraWithKey: kExtraMessagingEventArgsContentType];
                NSString* userName = [eargs getExtraWithKey: kExtraMessagingEventArgsFromUserName];
                
                NSData *content = eargs.payload;
                
                // message/cpim content
                if(contentType && [[contentType lowercaseString] hasPrefix:@"message/cpim"]){
                    MediaContent *_content = MediaContent::parse([eargs.payload bytes], [eargs.payload length], [NgnStringUtils toCString:@"message/cpim"]);
                    if(_content){
                        unsigned _clen = dynamic_cast<MediaContentCPIM*>(_content)->getPayloadLength();
                        const void* _cptr = dynamic_cast<MediaContentCPIM*>(_content)->getPayloadPtr();
                        if(_clen && _cptr){
                            const char* _contentTransferEncoding = dynamic_cast<MediaContentCPIM*>(_content)->getHeaderValue("content-transfer-encoding");
                            
                            if(tsk_striequals(_contentTransferEncoding, "base64")){
                                char *_ascii = tsk_null;
                                int ret = tsk_base64_decode((const uint8_t*)_cptr, _clen, &_ascii);
                                if((ret > 0) && _ascii){
                                    content = [NSData dataWithBytes:_ascii length:ret];
                                }
                                else {
                                    TSK_DEBUG_ERROR("tsk_base64_decode() failed with error code equal to %d", ret);
                                }
                                
                                TSK_FREE(_ascii);
                            }
                            else {
                                content = [NSData dataWithBytes:_cptr length:_clen];
                            }
                        }
                        delete _content;
                    }
                }
                
                NSString * showStr = [[NSString alloc]initWithData:content encoding:NSUTF8StringEncoding];
                NgnHistorySMSEvent *smsEvent = [NgnHistoryEvent createSMSEventWithStatus:HistoryEventStatus_Incoming andRemoteParty:userName andContent:content];
                
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                    
                    UILocalNotification* localNotif = [[UILocalNotification alloc] init];
                    localNotif.alertBody = [NSString stringWithFormat:@"%@: %@", userName, showStr];
                    
                    //                        NSLog(@"content === %@",content);
                    localNotif.soundName = UILocalNotificationDefaultSoundName;
                    localNotif.applicationIconBadgeNumber = ++[UIApplication sharedApplication].applicationIconBadgeNumber;
                    localNotif.repeatInterval = 0;
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              kNotifKey_IncomingMsg, kNotifKey,
                                              userName, @"userName",
                                              content,@"content",
                                              nil];
                    localNotif.userInfo = userInfo;
                    [[UIApplication sharedApplication]  presentLocalNotificationNow:localNotif];
                }
                
                BOOL isSoundOpen = AllSoundOpen && NewsSoundOpen;
                BOOL isShakeOpen = AllShakeOpen && NewsShakeOpen;
                if (isSoundOpen && isShakeOpen) {
                    SystemAudio *audio = [[SystemAudio alloc] init];
                    [audio playShakeAndSound];
                }
                else if (isSoundOpen && !isShakeOpen){
                    
                    SystemAudio *audio = [[SystemAudio alloc] init];
                    [audio playSound];
                    
                }
                else if (!isSoundOpen && isShakeOpen){
                    
                    
                    SystemAudio *audio = [[SystemAudio alloc] init];
                    [audio playShake];
                    
                }
                
                
                [[NgnEngine sharedInstance].historyService addEvent:smsEvent];
                
                
                
                
            }
            break;
        }
    }
}



//== INVITE (audio/video, file transfer, chat, ...) events == //
-(void) onInviteEvent:(NSNotification*)notification {
    
    NgnInviteEventArgs* eargs = [notification object];
    
    switch (eargs.eventType) {
        case INVITE_EVENT_INCOMING:
        {
            NgnAVSession* incomingSession = [NgnAVSession getSessionWithId: eargs.sessionId];
            if (incomingSession && [UIApplication sharedApplication].applicationState ==  UIApplicationStateBackground) {
                UILocalNotification* localNotif = [[UILocalNotification alloc] init];
                if (localNotif){
                    bool _isVideoCall = isVideoType(incomingSession.mediaType);
                    NSString *remoteParty = incomingSession.historyEvent ? incomingSession.historyEvent.remotePartyDisplayName : [incomingSession getRemotePartyUri];
                    
                    NSString *stringAlert = [NSString stringWithFormat:@"语音来电 \n %@", remoteParty];
                    if (_isVideoCall)
                        stringAlert = [NSString stringWithFormat:@"视频邀请 \n %@", remoteParty];
                    
                    localNotif.alertBody = stringAlert;
                    localNotif.soundName = UILocalNotificationDefaultSoundName;
                    localNotif.applicationIconBadgeNumber = ++[UIApplication sharedApplication].applicationIconBadgeNumber;
                    localNotif.repeatInterval = 0;
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              kNotifKey_IncomingCall, kNotifKey,
                                              [NSNumber numberWithLong:incomingSession.id], kNotifIncomingCall_SessionId,
                                              nil];
                    localNotif.userInfo = userInfo;
                    [[UIApplication sharedApplication]  presentLocalNotificationNow:localNotif];
                }
            }
            else if(incomingSession){
                
                
                [ZYCallViewController receiveIncomingCall:incomingSession];
            }
            
            break;
        }
            
        case INVITE_EVENT_MEDIA_UPDATED:
        {
            NgnAVSession* session = [NgnAVSession getSessionWithId:eargs.sessionId];
            if (session) {
                if (session.connectionState == CONN_STATE_CONNECTING || session.connectionState == CONN_STATE_CONNECTED) {
                    [ZYCallViewController displayCall:session];
                }
                [NgnAVSession releaseSession:&session];
            }
            break;
        }
            
        case INVITE_EVENT_TERMINATED:
        case INVITE_EVENT_TERMWAIT:
        {
            if ([UIApplication sharedApplication].applicationState ==  UIApplicationStateBackground) {
                // call terminated while in background
                // if the application goes to background while in call then the keepAwake mechanism was not started
                if([NgnEngine sharedInstance].sipService.registered && ![NgnAVSession hasActiveSession]){
                    if([[NgnEngine sharedInstance].configurationService getBoolWithKey:NETWORK_USE_KEEPAWAKE]){
                        [[NgnEngine sharedInstance] startKeepAwake];
                    }
                }
            }
            break;
        }
            
        default:
        {
            break;
        }
    }
}



@end
