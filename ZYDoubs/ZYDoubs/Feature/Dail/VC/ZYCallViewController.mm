//
//  ZYCallViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYCallViewController.h"

@interface ZYCallViewController ()

@end

@implementation ZYCallViewController

#pragma mark - 来电页面跳转
+(BOOL) presentSession: (NgnAVSession*)session{
    
    
    if(session){
    
        if(isVideoType(session.mediaType)){
            
            
//            VideoCallViewController * videoCallController = [[VideoCallViewController alloc] init];
//            
//            videoCallController.sessionId = session.id;
//            videoCallController.workname = name;
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [rootVC presentViewController:videoCallController animated:YES completion:nil];
//            });
            
            
            return YES;
        }
        else if(isAudioType(session.mediaType)){
            
//            AudioCallViewController * audioCallController = [[AudioCallViewController alloc] init];
//            audioCallController.sessionId = session.id;
//            audioCallController.workname = name;
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [rootVC presentViewController:audioCallController animated:YES completion:nil];
//            });
            
            return YES;
        }

    }
    
    return NO;
}


/**
 
 拨打语音
 remoteUri ： impi
 */
+(BOOL) makeAudioCallWithRemoteParty: (NSString*) remoteUri{
    
    NgnAVSession* audioSession = [[NgnAVSession makeAudioCallWithRemoteParty: remoteUri andSipStack: [[NgnEngine sharedInstance].sipService getSipStack]] retain];
    
    
    if(audioSession){
        
//        AudioCallViewController * audioCallController = [[AudioCallViewController alloc] init];
//        audioCallController.sessionId = audioSession.id;
//        audioCallController.workname = name;
//        audioCallController.buttonAccept.hidden = YES;
//        
//        //获取当前的控制器
//        MyRootViewController * rootVC = (MyRootViewController *)[AppDelegate sharedInstance].window.rootViewController;
//        UIViewController * modalViewController = rootVC;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [modalViewController presentViewController:audioCallController animated:YES completion:nil];
//            [audioSession release];
//        });
        
        return YES;
    }

    return NO;
}

/**
 
 拨打视频
 remoteUri ： impi
 */
+(BOOL) makeAudioVideoCallWithRemoteParty: (NSString*) remoteUri{
    NgnAVSession* videoSession = [[NgnAVSession makeAudioVideoCallWithRemoteParty: remoteUri
                                                                      andSipStack: [[NgnEngine sharedInstance].sipService getSipStack]] retain];
    if(videoSession){
        
//        VideoCallViewController * videoCallController = [[VideoCallViewController alloc]init];
//        videoCallController.sessionId = videoSession.id;
//        videoCallController.workname = name;
//        videoCallController.buttonAccept.hidden = YES;
//        
//        //获取当前的控制器
//        MyRootViewController * rootVC = (MyRootViewController *)[AppDelegate sharedInstance].window.rootViewController;
//        UIViewController * modalViewController = rootVC;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [modalViewController presentViewController:videoCallController animated:YES completion:nil];
//            [videoSession release];
//        });
        
        return YES;
    }
    
    return NO;
}

/**
 
 接听语音/视频
 
 */
+(BOOL) receiveIncomingCall: (NgnAVSession*)session{
    return [ZYCallViewController presentSession:session];
}
+(BOOL) displayCall: (NgnAVSession*)session{
    if(session){
        return [ZYCallViewController presentSession:session];
    }
    return NO;
}

- (void)dealloc {
    [super dealloc];
}

@end
