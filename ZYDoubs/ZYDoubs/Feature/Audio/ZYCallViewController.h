//
//  ZYCallViewController.h
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSNgnStack.h"

@interface ZYCallViewController : UIViewController
{
    long sessionId;
}

@property (nonatomic) long sessionId;

/**
 
    拨打语音
    remoteUri ： impi
 */
+(BOOL) makeAudioCallWithRemoteParty: (NSString*) remoteUri;

/**
 
    拨打视频
    remoteUri ： impi
 */
+(BOOL) makeAudioVideoCallWithRemoteParty: (NSString*) remoteUri;

/**
 
    接听语音/视频
 
 */
+(BOOL) receiveIncomingCall: (NgnAVSession*)session;
+(BOOL) displayCall: (NgnAVSession*)session;

@end
