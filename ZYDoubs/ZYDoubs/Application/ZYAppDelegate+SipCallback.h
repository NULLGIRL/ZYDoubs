//
//  ZYAppDelegate+SipCallback.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAppDelegate.h"

@interface ZYAppDelegate (SipCallback)

-(void) onNetworkEvent:(NSNotification*)notification;
-(void) onNativeContactEvent:(NSNotification*)notification;
-(void) onStackEvent:(NSNotification*)notification;
-(void) onRegistrationEvent:(NSNotification*)notification;
-(void) onMessagingEvent:(NSNotification*)notification;
-(void) onInviteEvent:(NSNotification*)notification;

@end
