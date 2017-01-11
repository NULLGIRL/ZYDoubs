//
//  ZYSipTools.h
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYSipTools : NSObject

/**注册*/
+(void)sipRegister;
/** sip是否已经注册*/
+(BOOL)sipIsRegister;
/** 配置*/
+(void)UpdateUser_SipConfig;
/**取消注册*/
+(BOOL)sipUnRegister;

/** 是否在时间范围之内*/
+ (BOOL)isBetweenTime;

/** 播放声音*/
+(void)playRing;

/** 停止播放*/
+(void)stopRing;

@end
