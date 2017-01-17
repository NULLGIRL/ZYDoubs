//
//  SystemAudio.h
//  idoubs
//
//  Created by 乔香彬 on 16/5/16.
//  Copyright © 2016年 Doubango Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface SystemAudio : NSObject
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}
- (id)initSystemShake;//系统 震动
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音
- (void)play;//播放


- (void)playShake;//震动
- (void)playSound;//声音
- (void)playShakeAndSound;//震动和声音

@end
