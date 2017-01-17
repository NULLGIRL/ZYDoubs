//
//  SystemAudio.m
//  idoubs
//
//  Created by 乔香彬 on 16/5/16.
//  Copyright © 2016年 Doubango Telecom. All rights reserved.
//

#import "SystemAudio.h"

@implementation SystemAudio

- (id)initSystemShake
{
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self) {
//        //短信及其他系统声音路径
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
//        NSString *path = [NSString stringWithFormat:@"/System/Library/CoreServices/SpringBoard.app/%@.%@", soundName, soundType];
        [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        [[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  //获取自定义的声音
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            
            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
                sound = nil;
            }
        }
    }
    return self;
}

- (void)play
{
    AudioServicesPlaySystemSound(sound);
}



- (void)playShake{
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}





- (void)playSound{
  
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"candoNotifySound" ofType:@"mp3"];
     NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:@"Tock" ofType:@"caf"];
    //定义一个带振动的SystemSoundID
//    SystemSoundID soundID = 1000;
    SystemSoundID soundID;
    if (path) {
        //创建一个音频文件的播放系统声音服务器
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundID);
        //判断是否有错误
        if (error != kAudioServicesNoError) {
            NSLog(@"%d",(int)error);
        }

    }
    
    //声音
    AudioServicesPlaySystemSound(1007);
}


#pragma mark - 声音+震动
- (void)playShakeAndSound{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"candoNotifySound" ofType:@"mp3"];
    //定义一个SystemSoundID
    SystemSoundID soundID = 1007;
    
    
    if (path) {
        //创建一个音频文件的播放系统声音服务器
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundID);
        //判断是否有错误
        if (error != kAudioServicesNoError) {
            NSLog(@"%d",(int)error);
        }
    }
    

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        //iOS9以上
        
        
        //播放声音和振动
        AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
            //播放成功回调
        });
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0){
        //iOS8 - iOS9
        
        AudioServicesPlayAlertSound(soundID);
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        
    }

}

@end
