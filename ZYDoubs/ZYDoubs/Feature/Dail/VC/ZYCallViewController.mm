//
//  ZYCallViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYCallViewController.h"

#import "ZYAudioViewController.h"
#import "ZYVideoViewController.h"

@interface ZYCallViewController ()

@end

@implementation ZYCallViewController

#pragma mark - 来电页面跳转
+(BOOL) presentSession: (NgnAVSession*)session{
    
    
    if(session){
    
        // 获取当前控制器
        UIViewController * currentVC = [UIViewController currentViewController];
        if ([NSStringFromClass([ZYAudioViewController class]) isEqualToString:NSStringFromClass([currentVC class])]) {
            NSLog(@"当前页面是 ZYAudioViewController");
            return NO;
        }
        
        if ([NSStringFromClass([ZYVideoViewController class]) isEqualToString:NSStringFromClass([currentVC class])]) {
            NSLog(@"当前页面是 ZYVideoViewController");
            return NO;
        }

        
        if(isVideoType(session.mediaType)){
            
            
            ZYVideoViewController * videoCallController = [[ZYVideoViewController alloc] init];
            videoCallController.videoSession = session;
        
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [currentVC presentViewController:videoCallController animated:YES completion:nil];
            });
            
            
            
            return YES;
        }
        else if(isAudioType(session.mediaType)){

            ZYAudioViewController * audioCallController = [[ZYAudioViewController alloc] init];
            audioCallController.audioSession = session;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [currentVC presentViewController:audioCallController animated:YES completion:nil];
            });
            
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
        
        // 获取当前控制器
        UIViewController * currentVC = [UIViewController currentViewController];
        
        ZYAudioViewController * audioCallController = [[ZYAudioViewController alloc] init];
        audioCallController.audioSession = audioSession;
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [currentVC presentViewController:audioCallController animated:YES completion:nil];
            [audioSession release];
        });
        
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
        
        // 获取当前控制器
        UIViewController * currentVC = [UIViewController currentViewController];
        
        ZYVideoViewController * videoCallController = [[ZYVideoViewController alloc] init];
        videoCallController.videoSession = videoSession;

        dispatch_async(dispatch_get_main_queue(), ^{
            [currentVC presentViewController:videoCallController animated:YES completion:nil];
            [videoSession release];
        });
        
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
